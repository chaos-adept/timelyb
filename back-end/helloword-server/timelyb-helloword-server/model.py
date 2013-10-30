__author__ = 'WORKSATION'


from google.appengine.ext import ndb

class Event(ndb.Model):
    actor = ndb.UserProperty()
    startTime = ndb.DateTimeProperty(indexed=True)
    endTime = ndb.DateTimeProperty(indexed=True)
    content = ndb.StringProperty(indexed=False)
    value = ndb.FloatProperty()
    activity = ndb.StringProperty(indexed=True)

