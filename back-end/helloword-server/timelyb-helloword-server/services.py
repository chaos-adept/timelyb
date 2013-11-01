__author__ = 'WORKSATION'

from protorpc import messages
from protorpc import remote
from protorpc.wsgi import service
from model import Event

from google.appengine.api import users
from google.appengine.ext import ndb

import datetime

# Create the request string containing the user's name
class LogEventRequest(messages.Message):
    startTime = messages.StringField(2, required=True)
    endTime = messages.StringField(3, required=True)
    comment = messages.StringField(4, required=False)
    value = messages.FloatField(5, required=True)
    activity = messages.StringField(6, required=True)

# Create the response string
class LogEventResponse(messages.Message):
    message = messages.StringField(1, required=True)

class ActivitiesRequest(messages.Message):
    pass

class ActivityItemMessage(messages.Message):
    name = messages.StringField(1, required=True)
    description = messages.StringField(2, required=False)

class ActivitiesResponse(messages.Message):
    items = messages.MessageField(message_type=ActivityItemMessage, repeated=True, number=1)
    next_cursor = messages.StringField(2, required=False)


def parseMsgTime(time):
    return datetime.datetime.strptime( time, "%Y-%m-%dT%H:%M:%S.%fZ" )

def nameToActivityMessage(event):
    return ActivityItemMessage(name = event.activity)

# Create the RPC service to exchange messages
class EventService(remote.Service):

    @remote.method(LogEventRequest, LogEventResponse)
    def add(self, request):
        event = Event(
            actor = users.get_current_user(),
            activity = (request.activity),
            comment = (request.comment),
            startTime = parseMsgTime(request.startTime), endTime = parseMsgTime(request.endTime),
            value = request.value)
        event.put()
        return LogEventResponse(message='Event has been added')

    @remote.method(ActivitiesRequest, ActivitiesResponse)
    def activities(self, request):
        qry = Event.query(
                ndb.AND(
                    Event.actor == users.get_current_user(),
                    Event.endTime >=  datetime.datetime.now() - datetime.timedelta(days=14)),
           projection=['activity'], distinct=True)
        items = qry.map(nameToActivityMessage, limit = 20)
        response = ActivitiesResponse(items = items)
        return response


app = service.service_mappings([('/service/event', EventService)])