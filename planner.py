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
import logging

class ReportPlannerPage(webapp2.RequestHandler):

    def addReportJob(self, settings, days):
        logging.info('make plan for settings %s' % settings)
        utcDate =  datetime.datetime.utcnow() #fixme might be incorrect
        utcDateTrimmed = datetime.datetime.combine(utcDate, datetime.time(0,0))

        eta = utcDateTrimmed + datetime.timedelta(days = 1) - datetime.timedelta(hours = settings.timeZoneOffset)
        taskqueue.add(url='/reportWorker', method='GET', params={'email': settings.email, 'days':days - 1}, eta = eta)
        pass

    def get(self):
        reportType = self.request.get('reportType')
        logging.info('request type %s' % reportType)

        isFinished = False
        next_cursor = None
        while (not isFinished):
            settingsList, next_cursor, more = model.Settings.query().fetch_page(250, start_cursor=next_cursor)
            for settings in settingsList:
                self.addReportJob(settings, 1)
            isFinished = not (more and next_cursor)

        self.response.write('report processed')

app = webapp2.WSGIApplication([
    ('/reportPlanner', ReportPlannerPage),
], debug=True)