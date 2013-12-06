import datetime
import StringIO
from google.appengine.api import users, mail
import sys
import math

__author__ = 'WORKSATION'
import logging
import model
from model import Event
from model import Settings
from google.appengine.ext import deferred, ndb

BATCH_SIZE = 100  # ideal batch size may vary based on entity size.


PIE_CHART_TEMPLATE_HEADER = '''
<html>
  <head>
    <meta charset="utf-8">
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Activity', 'Seconds'],
          //['Work',     11],

'''

PIE_CHART_TEMPLATE_DATA_ROW_ITEM = "['%s', %d]"



PIE_CHART_TEMPLATE_FOOTHDER = '''
        ]);

        var options = {
          title: 'Activities'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="piechart" style="width: 900px; height: 500px;"></div>
  </body>
</html>
'''


class PreFormattedEvent(object):
    pass


def formatTimeDelta(delta):
    hours, remainder = divmod(delta.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)

    # Formatted only for hours and minutes as requested
    return '%02d:%02d:%02d' % (hours, minutes, seconds)

def dateToStr(date, timeZoneOffset):
    return (date + datetime.timedelta(hours = timeZoneOffset)).strftime("%Y-%m-%d %H:%M:%S")

def activityToCvs(event):
    return "%s, %s, %s, %s, %s, %s" % (event.nickname, event.activityCode, event.timeSpanAsStr, event.value, event.startTimeAsStr, event.endTimeAsStr)

def activityToHtmlRow(event):
    return "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>" % (event.nickname, event.activityCode, event.timeSpanAsStr, event.value, event.startTimeAsStr, event.endTimeAsStr)

def itemToPreFormattedItem(event, settings, fromDate, toDate):
    formatted = PreFormattedEvent()
    formatted.nickname = event.actor.nickname()

    startTime = max(fromDate, event.startTime)#lambda (): if (fromDate < event.startTime) : fromDate else: event.startTime
    endTime = min(toDate, event.endTime)

    formatted.startTimeAsStr = dateToStr(startTime, settings.timeZoneOffset)
    formatted.endTimeAsStr = dateToStr(endTime, settings.timeZoneOffset)
    formatted.timeSpan = endTime - startTime
    formatted.timeSpanAsStr = formatTimeDelta(formatted.timeSpan)
    formatted.activityCode = event.activityCode
    formatted.value = event.value
    return formatted

def summaryItemToDataItemRow(value):
    return PIE_CHART_TEMPLATE_DATA_ROW_ITEM % (value[0], value[1].total_seconds())

def SendEmailDailyReport(currentUser, email, fromDate, toDate):

    #todo refactor

    cursor_inDateRange = None
    cursor_outDateRange = None
    queryEndInDateRange = None
    queryStartInDateRange = None

    try:
        queryEndInDateRange = Event.query(
            Event.actor == currentUser,
            (ndb.AND(Event.endTime >= fromDate,
                           Event.endTime < toDate)),

        ).order(Event.endTime)

        queryStartInDateRange = Event.query(
            Event.actor == currentUser,
            Event.startTime >= fromDate
        ).order(-Event.startTime) # the only event could be started and not completed in range with max time


                   # ndb.AND(Event.endTime < toDate,
                   #         Event.endTime > toDate)
    except:
        logging.info('error cant be prepared %s', sys.exc_info()[0])

        pass


    if cursor_inDateRange:
        queryEndInDateRange.with_cursor(cursor_inDateRange)

    if cursor_outDateRange:
        queryStartInDateRange.with_cursor(cursor_outDateRange)

    settings = Settings.singletonForUser(currentUser)

    inRangeItems = queryEndInDateRange.fetch(BATCH_SIZE)
    outRangeItems = queryStartInDateRange.fetch(1) # the only event could be started and not completed in range with max time
    if (len(outRangeItems) > 0):
        outRangeItem = outRangeItems[0]
        if ((outRangeItem.startTime < toDate) and (outRangeItem.endTime > toDate)):
            outRangeItem.endTime = toDate
            inRangeItems.append(outRangeItem)


    preFormatedItems = map(lambda (event): itemToPreFormattedItem(event, settings, fromDate, toDate), inRangeItems)

    summary = {}

    markedTime = datetime.timedelta(seconds=0)

    for item in preFormatedItems:
        if item.activityCode in summary:
            summary[item.activityCode] += item.timeSpan
        else:
            summary[item.activityCode] = item.timeSpan

        markedTime += item.timeSpan


    totalDelta = (toDate - fromDate)


    htmlOut = StringIO.StringIO()

    htmlOut.write("<h2>Summary:</h2>")

    htmlOut.write("<table border=\"1\">")



    noneTimeDelta = toDate - fromDate - markedTime

    summary['None'] =  noneTimeDelta

    for (sumKey, sumDelta) in summary.iteritems():
        markedTime += sumDelta
        percent = math.floor(sumDelta.total_seconds() / totalDelta.total_seconds() * 100)
        htmlOut.write("<tr><td>%s</td><td>%d%%</td><td>%s</td></tr>" % (sumKey, percent, formatTimeDelta(sumDelta)))

    htmlOut.write("</table>")

    htmlOut.write("<br/>")
    htmlOut.write("<h2>Details:</h2>")

    htmlOut.write("<table border=\"1\">")

    html_items = map(activityToHtmlRow, preFormatedItems)
    cvs_items =  map(activityToCvs, preFormatedItems)

    htmlOut.write("\n\r".join(html_items))

    cvsOut = StringIO.StringIO()
    cvsOut.write("\n\r".join(cvs_items))

    htmlOut.write("</table>")

    charOut = StringIO.StringIO()

    charOut.write(PIE_CHART_TEMPLATE_HEADER)

    charDataItems = map( summaryItemToDataItemRow , summary.iteritems())
    charOut.write("\n\r,".join(charDataItems))
    charOut.write(PIE_CHART_TEMPLATE_FOOTHDER)

    mail.send_mail(sender="chaos.lab.games@gmail.com",
                  to=email,
                  subject="Time report: %s - %s" % (fromDate.strftime("%Y-%m-%d"), toDate.strftime("%Y-%m-%d")),
                  body='see html email',
                  html=htmlOut.getvalue(),
                  attachments=[('report.csv', cvsOut.getvalue()), ('chart.html', charOut.getvalue()) ])

    htmlOut.close()
    cvsOut.close()
    charOut.close()
    pass