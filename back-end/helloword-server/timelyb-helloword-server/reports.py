import os
import urllib
import cgi
import datetime
from google.appengine.api.taskqueue import taskqueue
from google.appengine.api.users import User
import event_reports
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
        fromDate = datetime.datetime.now() - datetime.timedelta(days=days)
        user = User(email = email)
        event_reports.SendEmailDailyReport(user, email, fromDate)

app = webapp2.WSGIApplication([
    ('/reportWorker', ReportWorker),
], debug=True)