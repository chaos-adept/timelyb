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

def activityToCvs(event):
    span = formatTimeDelta(event.endTime - event.startTime)
    return "%s, %s, %s, %s, %s, %s" % (event.actor.nickname(), event.activityCode, span, event.value, event.startTime.strftime("%Y-%m-%d %H:%M:%S"), event.endTime.strftime("%Y-%m-%d %H:%M:%S"))

def SendEmailDailyReport(currentUser, email, fromDate):

    cursor = None

    output = StringIO.StringIO()

    query = Event.query(
            ndb.AND(
                Event.actor == currentUser,
                Event.endTime >=  fromDate))

    if cursor:
        query.with_cursor(cursor)

    items = query.map(activityToCvs, limit = BATCH_SIZE)

    output.write("\n\r".join(items))

    mail.send_mail(sender="denis.rykovanov@gmail.com",
                  to=email,
                  subject="Time report since %s " % fromDate.strftime("%Y-%m-%d"),
                  body=output.getvalue(),  attachments=[('report.csv'), (output.getvalue())])

    output.close()
    pass