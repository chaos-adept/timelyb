__author__ = 'WORKSATION'
import logging
import model
from google.appengine.ext import deferred
from google.appengine.ext import db

BATCH_SIZE = 100  # ideal batch size may vary based on entity size.

def UpdateEventActivityName(oldActivityCode, newActivityCode, cursor=None, num_updated=0):
    query = model.Event.query(model.Event.activityCode == oldActivityCode)
    if cursor:
        query.with_cursor(cursor)

    to_put = []
    for event in query.fetch(limit=BATCH_SIZE):
        event.activityCode = newActivityCode
        to_put.append(event)

    if to_put:
        db.put(to_put)
        num_updated += len(to_put)
        logging.debug(
            'Put %d entities to Datastore for a total of %d',
            len(to_put), num_updated)
        deferred.defer(
            UpdateEventActivityName, oldActivityCode, newActivityCode, cursor=query.cursor(), num_updated=num_updated)
    else:
        logging.debug(
            'UpdateSchema complete with %d updates!', num_updated)