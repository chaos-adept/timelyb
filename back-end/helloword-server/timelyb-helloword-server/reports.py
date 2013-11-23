import os
import urllib
import cgi
import datetime
from google.appengine.api.taskqueue import taskqueue
from google.appengine.api.users import User
import event_reports
from model import Settings
import model

from google.appengine.ext import ndb, deferred

from google.appengine.api import users
from google.appengine.ext import ndb

import jinja2
import webapp2

class ReportWorker(webapp2.RequestHandler):
    def get(self):
        email = self.request.get('email')
        days = int(self.request.get('days'))


        user = User(email = email)

        settings = Settings.singletonForUser(user)

        timeZoneDelta = datetime.timedelta(hours=settings.timeZoneOffset)

        utcDate =  datetime.datetime.today() #fixme might be incorrect
        utcDateTrimmed = datetime.datetime.combine(utcDate, datetime.time(0,0))


        fromDate = utcDateTrimmed - datetime.timedelta(days=days) - timeZoneDelta
        toDate = utcDateTrimmed - datetime.timedelta(days=days-1) - timeZoneDelta

        event_reports.SendEmailDailyReport(user, email, fromDate, toDate)

app = webapp2.WSGIApplication([
    ('/reportWorker', ReportWorker),
], debug=True)