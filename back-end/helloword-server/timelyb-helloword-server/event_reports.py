import datetime
import StringIO
from google.appengine.api import users, mail

__author__ = 'WORKSATION'
import logging
import model
from model import Event
from google.appengine.ext import deferred, ndb

BATCH_SIZE = 100  # ideal batch size may vary based on entity size.


def formatTimeDelta(delta):
    return str(delta)

def dateToStr(date):
    return date.strftime("%Y-%m-%d %H:%M:%S")

def activityToCvs(event):
    span = formatTimeDelta(event.endTime - event.startTime)
    return "%s, %s, %s, %s, %s, %s" % (event.actor.nickname(), event.activityCode, span, event.value, dateToStr(event.startTime), dateToStr(event.endTime))

def activityToHtmlRow(event):
    span = formatTimeDelta(event.endTime - event.startTime)
    return "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>" % (event.actor.nickname(), event.activityCode, span, event.value, dateToStr(event.startTime), dateToStr(event.endTime))

def SendEmailDailyReport(currentUser, email, fromDate):

    cursor = None

    htmlOut = StringIO.StringIO()
    cvsOut = StringIO.StringIO()

    query = Event.query(
            ndb.AND(
                Event.actor == currentUser,
                Event.endTime >=  fromDate)).order(-Event.endTime)

    if cursor:
        query.with_cursor(cursor)

    htmlOut.write("<table border=\"1\">")

    items = query.fetch(BATCH_SIZE)
    html_items = map(activityToHtmlRow, items)
    cvs_items =  map(activityToCvs, items)

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