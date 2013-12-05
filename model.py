__author__ = 'WORKSATION'


from google.appengine.ext import ndb

class Event(ndb.Model):
    actor = ndb.UserProperty(indexed=True, required=True)
    startTime = ndb.DateTimeProperty(indexed=True, required=True)
    endTime = ndb.DateTimeProperty(indexed=True, required=True)
    comment = ndb.StringProperty(indexed=False, required=False)
    value = ndb.FloatProperty(required=True)
    activityCode = ndb.StringProperty(indexed=True, required=True) #activity code

class StartedEvent(ndb.Model):
    actor = ndb.UserProperty(indexed=True, required=True)
    startTime = ndb.DateTimeProperty(indexed=True, required=True)
    eventValue = ndb.FloatProperty(required=True)
    activityCode = ndb.StringProperty(indexed=True, required=True) #activity code

class Activity(ndb.Model):
    actor = ndb.UserProperty(indexed=True, required=True)
    code = ndb.StringProperty(indexed=True, required=True)
    name = ndb.StringProperty(indexed=True, required=True)
    thumbUrl = ndb.StringProperty(indexed=False, required=False)
    tags = ndb.StringProperty(indexed=True, required=False, repeated=True)
    defaultEventValue = ndb.FloatProperty(indexed=False, required=False)


class Settings(ndb.Model):
    @classmethod
    def singletonForUser(cls, user):
        return cls.get_or_insert(ndb.Key('Settings', 'User', 'email', user.email()).id(), email = user.email())

    email = ndb.StringProperty(verbose_name='email for reports', indexed=True, required=True)

    timeZoneOffset = ndb.IntegerProperty(
        default =  0,
        verbose_name = "current user timezone",
        indexed = False)