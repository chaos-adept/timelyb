__author__ = 'WORKSATION'

from protorpc import messages
from protorpc import remote
from protorpc.wsgi import service
from model import Event



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

# Create the RPC service to exchange messages
class EventService(remote.Service):

    @remote.method(LogEventRequest, LogEventResponse)
    def add(self, request):

        return LogEventResponse(message='Hello there, %s!' % request.activity)


app = service.service_mappings([('/service/event', EventService)])