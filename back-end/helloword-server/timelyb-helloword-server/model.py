__author__ = 'WORKSATION'


from google.appengine.ext import ndb

class Event(ndb.Model):
    actor = ndb.UserProperty(indexed=True, required=True)
    startTime = ndb.DateTimeProperty(indexed=True, required=True)
    endTime = ndb.DateTimeProperty(indexed=True, required=True)
    comment = ndb.StringProperty(indexed=False, required=False)
    value = ndb.FloatProperty(required=True)
    activityCode = ndb.StringProperty(indexed=True, required=True) #activity code

class Activity(ndb.Model):
    actor = ndb.UserProperty(indexed=True, required=True)
    code = ndb.StringProperty(indexed=True, required=True)
    name = ndb.StringProperty(indexed=True, required=True)
    thumbUrl = ndb.StringProperty(indexed=False, required=False)
    tags = ndb.StringProperty(indexed=True, required=False, repeated=True)
