from google.appengine.ext.ndb import Key
import update_events

__author__ = 'WORKSATION'

from protorpc import messages
from protorpc import remote
from protorpc.wsgi import service
from model import *

from google.appengine.api import users
from google.appengine.ext import ndb, deferred
from google.appengine.api.taskqueue import taskqueue

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
    code = messages.StringField(2, required=False)
    name = messages.StringField(3, required=False)
    tags = messages.StringField(4, required=False, repeated=True)
    thumbUrl = messages.StringField(5, required=False)
    defaultEventValue = messages.FloatField(6, required=False)

class ActivitiesResponse(messages.Message):
    items = messages.MessageField(message_type=ActivityItemMessage, repeated=True, number=1)
    next_cursor = messages.StringField(2, required=False)

class SettingsMessage(messages.Message):
    timeZoneOffset = messages.IntegerField(1, required=False)
    logoutUrl = messages.StringField(2, required=False)
    nickname = messages.StringField(3, required=False)

class RequestReportMessage(messages.Message):
    fromDate = messages.StringField(1, required=True)
    toDate = messages.StringField(2, required=True)

class RequestReportResponseMessage(messages.Message):
    message = messages.StringField(1, required=False)


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





class SettingsService(remote.Service):

    @remote.method(SettingsMessage, SettingsMessage)
    def read(self, request):
        userSettings = Settings.singletonForUser(users.get_current_user())
        request.nickname = users.get_current_user().nickname()
        request.logoutUrl = users.create_logout_url('/')
        request.timeZoneOffset = userSettings.timeZoneOffset
        return request

    @remote.method(SettingsMessage, SettingsMessage)
    def create(self, request):
        return self.update(request)

    @remote.method(SettingsMessage, SettingsMessage)
    def update(self, request):
        userSettings = Settings.singletonForUser(users.get_current_user())
        if (request.timeZoneOffset != userSettings.timeZoneOffset):
            userSettings.timeZoneOffset = request.timeZoneOffset
            userSettings.put()
        return request
    pass


class ActivityService(remote.Service):
    def addActivity(self, request):
        #todo refactor , try optimize

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

    @remote.method(ActivityItemMessage, ActivityItemMessage)
    def read(self, request):
        if (request.id):
            return activityToMessage(Key(urlsafe = request.id).get())
        else:
            if (request.code):
                activity = Activity.query(Activity.code == request.code, Activity.actor == users.get_current_user()).fetch(1)[0]
                return activityToMessage(activity)
        return None #todo throw error

    @remote.method(ActivityItemMessage, ActivityItemMessage)
    def create(self, request):
        return self.update(request)

    @remote.method(ActivityItemMessage, ActivityItemMessage)
    def update(self, request):
        return self.addActivity(request)


class ReportRequestService(remote.Service):
    @remote.method(RequestReportMessage, RequestReportResponseMessage)
    def request(self, request):
        user = users.get_current_user()
        email = user.email()
        fromDate = parseMsgTime(request.fromDate)
        toDate = parseMsgTime(request.toDate)
        taskqueue.add(url='/reportWorker', method='GET', params={'email': email, 'fromDate':fromDate, 'toDate':toDate, 'type': 'dateSpan'})
        return RequestReportResponseMessage(message = 'report from %s to %s, email is going to be sent at %s' % (fromDate, toDate, email))




app = service.service_mappings([('/service/event', EventService), ('/service/settings', SettingsService), ('/service/activity', ActivityService), ('/service/reportRequest', ReportRequestService)])