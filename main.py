import logging
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


JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

class MainPage(webapp2.RequestHandler):

    def get(self):
        self.redirect('/pages/index.html')


class LogEventPage(webapp2.RequestHandler):

    def post(self):
        # self.response.write('<html><body>You wrote:<pre>')
        # self.response.write(cgi.escape(self.request.get('comment')))
        # self.response.write('</pre></body></html>')
        activity = self.request.get('activity')
        value = float(self.request.get('value'))
        comment = self.request.get('comment')
        startDateTime = datetime.datetime.strptime( self.request.get('startTime'), "%Y-%m-%dT%H:%M:%S.%fZ" ) #dateutil.parser.parse(self.request.get('startTime'))
        endDateTime = datetime.datetime.strptime( self.request.get('endTime'), "%Y-%m-%dT%H:%M:%S.%fZ" ) #dateutil.parser.parse(self.request.get('endTime'))
        event = model.Event(
            actor = users.get_current_user(), activity = activity,
            comment = comment,
            startTime = startDateTime, endTime = endDateTime,
            value = value)


        template = JINJA_ENVIRONMENT.get_template('/templates/logEventResult.html')
        self.response.write(template.render({"event":event}))


class ReportPage(webapp2.RequestHandler):
    def get(self):
        days = int( self.request.get('days') )

        user = users.get_current_user()
        email = user.email()
                # Add the task to the default queue.
        taskqueue.add(url='/reportWorker', method='GET', params={'email': email, 'days':days})

        self.response.write('email is going to be sent at %s' % email)


app = webapp2.WSGIApplication([
    ('/', MainPage),
    ('/report', ReportPage),
    ('/logEvent', LogEventPage)
], debug=True)

