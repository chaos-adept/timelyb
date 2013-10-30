import os
import urllib
import cgi
import datetime
import model


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
        user = users.get_current_user()

        if user:
            template_values = { 'nickName': user.nickname() }

            template = JINJA_ENVIRONMENT.get_template('/templates/logEvent.html')
            self.response.write(template.render(template_values))
        else:
            self.redirect(users.create_login_url(self.request.uri))


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


app = webapp2.WSGIApplication([
    ('/', MainPage),
    ('/logEvent', LogEventPage)
], debug=True)

