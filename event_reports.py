import datetime
import StringIO
from google.appengine.api import users, mail
import sys

__author__ = 'WORKSATION'
import logging
import model
from model import Event
from model import Settings
from google.appengine.ext import deferred, ndb

BATCH_SIZE = 100  # ideal batch size may vary based on entity size.


class PreFormattedEvent(object):
    pass


def formatTimeDelta(delta):
    hours, remainder = divmod(delta.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)

    # Formatted only for hours and minutes as requested
    return '%s:%s:%s' % (hours, minutes, seconds)

def dateToStr(date, timeZoneOffset):
    return (date + datetime.timedelta(hours = timeZoneOffset)).strftime("%Y-%m-%d %H:%M:%S")

def activityToCvs(event):
    return "%s, %s, %s, %s, %s, %s" % (event.nickname, event.activityCode, event.timeSpanAsStr, event.value, event.startTimeAsStr, event.endTimeAsStr)

def activityToHtmlRow(event):
    return "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>" % (event.nickname, event.activityCode, event.timeSpanAsStr, event.value, event.startTimeAsStr, event.endTimeAsStr)

def itemToPreFormattedItem(event, settings):
    formatted = PreFormattedEvent()
    formatted.nickname = event.actor.nickname()
    formatted.startTimeAsStr = dateToStr(event.startTime, settings.timeZoneOffset)
    formatted.endTimeAsStr = dateToStr(event.endTime, settings.timeZoneOffset)
    formatted.timeSpanAsStr = formatTimeDelta(event.endTime - event.startTime)
    formatted.activityCode = event.activityCode
    formatted.value = event.value
    return formatted

def SendEmailDailyReport(currentUser, email, fromDate, toDate):

    cursor = None

    htmlOut = StringIO.StringIO()
    cvsOut = StringIO.StringIO()
    try:
        query = Event.query(
                Event.actor == currentUser,
                Event.endTime >= fromDate,
                Event.endTime <= toDate).order(Event.endTime)
    except:
        logging.info('error cant be prepared %s', sys.exc_info()[0])

        pass


    if cursor:
        query.with_cursor(cursor)

    htmlOut.write("<table border=\"1\">")

    settings = Settings.singletonForUser(currentUser)

    items = query.fetch(BATCH_SIZE)
    preFormatedItems = map(lambda (event): itemToPreFormattedItem(event, settings), items)
    html_items = map(activityToHtmlRow, preFormatedItems)
    cvs_items =  map(activityToCvs, preFormatedItems)

    htmlOut.write("\n\r".join(html_items))
    cvsOut.write("\n\r".join(cvs_items))

    htmlOut.write("</table>")

    mail.send_mail(sender="denis.rykovanov@gmail.com",
                  to=email,
                  subject="Time report since %s " % fromDate.strftime("%Y-%m-%d"),
                  body='see html email',
                  html=htmlOut.getvalue(),
                  attachments=[('report.csv'), (cvsOut.getvalue())])

    htmlOut.close()
    cvsOut.close()
    pass