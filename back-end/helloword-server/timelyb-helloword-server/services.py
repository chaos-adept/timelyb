from google.appengine.ext.ndb import Key
import update_events

__author__ = 'WORKSATION'

from protorpc import messages
from protorpc import remote
from protorpc.wsgi import service
from model import Event
from model import Activity

from google.appengine.api import users
from google.appengine.ext import ndb, deferred

import datetime

# Create the request string containing the user's name
class EventMessage(messages.Message):
    startTime = messages.StringField(2, required=True)
    endTime = messages.StringField(3, required=True)
    comment = messages.StringField(4, required=False)
    value = messages.FloatField(5, required=True)
    activity = messages.StringField(6, required=True)
    id = messages.StringField(7, required=False)

# Create the response string
class LogEventResponse(messages.Message):
    message = messages.StringField(1, required=True)

class ActivitiesRequest(messages.Message):
    pass

class EventListRequest(messages.Message):
    limit = messages.IntegerField(1, required=True)
    pass

class EventsResponse(messages.Message):
    items = messages.MessageField(message_type=EventMessage, repeated=True, number=1)
    next_cursor = messages.StringField(2, required=False)
    pass

class ActivityItemMessage(messages.Message):
    id = messages.StringField(1, required=False)
    code = messages.StringField(2, required=True)
    name = messages.StringField(3, required=True)
    tags = messages.StringField(4, required=False, repeated=True)
    thumbUrl = messages.StringField(5, required=False)
    defaultEventValue = messages.FloatField(6, required=False)

class ActivitiesResponse(messages.Message):
    items = messages.MessageField(message_type=ActivityItemMessage, repeated=True, number=1)
    next_cursor = messages.StringField(2, required=False)


def parseMsgTime(time):
    return datetime.datetime.strptime( time, "%Y-%m-%dT%H:%M:%S.%fZ" )

def activityToMessage(activity):
    return ActivityItemMessage(id = activity.key.urlsafe(), defaultEventValue = activity.defaultEventValue, code = activity.code, name = activity.name, tags = activity.tags, thumbUrl = activity.thumbUrl)

def eventToMessage(event):
    return EventMessage(id = event.key.urlsafe(), activity = event.activityCode, startTime = event.startTime.isoformat(), endTime = event.endTime.isoformat(), comment = event.comment, value = event.value)

# Create the RPC service to exchange messages
class EventService(remote.Service):

    @remote.method(EventListRequest, EventsResponse)
    def events(self, request):
        qry = Event.query(Event.actor == users.get_current_user()).order(-Event.startTime)
        items = qry.map(eventToMessage, limit = request.limit)
        response = EventsResponse(items = items)
        return response


    # @remote.method(EventListRequest, EventsResponse)
    # def events(self, request):
    #     return EventsResponse(items = [])

    @remote.method(EventMessage, EventMessage)
    def add(self, request):

        if (request.id):
            eventKey = Key(urlsafe = request.id)
            event = eventKey.get()
            event.actor = users.get_current_user()
            event.activityCode = (request.activity)
            event.comment = (request.comment)
            event.startTime = parseMsgTime(request.startTime)
            event.endTime = parseMsgTime(request.endTime)
            event.value = request.value
            event.put()
        else:
            event = Event(
                actor = users.get_current_user(),
                activityCode = (request.activity),
                comment = (request.comment),
                startTime = parseMsgTime(request.startTime), endTime = parseMsgTime(request.endTime),
                value = request.value)
            event.put()

        return eventToMessage(event)

    @remote.method(ActivitiesRequest, ActivitiesResponse)
    def activities(self, request):
        qry = Activity.query(Activity.actor == users.get_current_user())

        items = qry.map(activityToMessage, limit = 100)
        response = ActivitiesResponse(items = items)
        return response

    @remote.method(ActivityItemMessage, ActivityItemMessage)
    def addActivity(self, request):
        #try to find existed

        if (request.id):
            activityKey = Key(urlsafe = request.id)
            activity = activityKey.get()
            oldActivityCode = activity.code
            activity.code = request.code
            activity.name = request.name
            activity.tags = request.tags
            activity.defaultEventValue = request.defaultEventValue
            activity.thumbUrl = request.thumbUrl
            activity.put()

            #update existed items
            if (oldActivityCode != request.code):
                deferred.defer(update_events.UpdateEventActivityName, users.get_current_user(), oldActivityCode, request.code)

            return activityToMessage(activity)
        else:
            activityIter = Activity.query(ndb.AND(
                        Activity.actor == users.get_current_user(),
                        Activity.code == request.code),
                        ).iter(keys_only=True)

            if (activityIter.has_next()):
                activity = activityIter.next()
                activity.code = request.code
                activity.name = request.name
                activity.tags = request.tags
                activity.defaultEventValue = request.defaultEventValue
                activity.thumbUrl = request.thumbUrl
                activity.put()
                return activityToMessage(activity)
            else:
                activity = Activity(actor = users.get_current_user(), defaultEventValue = request.defaultEventValue, name = request.name, code = request.code, tags = request.tags, thumbUrl = request.thumbUrl)
                activity.put()
                return activityToMessage(activity)




app = service.service_mappings([('/service/event', EventService)])