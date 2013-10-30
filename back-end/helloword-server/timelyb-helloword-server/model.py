__author__ = 'WORKSATION'


from google.appengine.ext import ndb

class Event(ndb.Model):
    actor = ndb.UserProperty(required=True)
    startTime = ndb.DateTimeProperty(indexed=True, required=True)
    endTime = ndb.DateTimeProperty(indexed=True, required=True)
    comment = ndb.StringProperty(indexed=False, required=False)
    value = ndb.FloatProperty(required=True)
    activity = ndb.StringProperty(indexed=True, required=True)

