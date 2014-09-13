function sortActivities(a, b) { // non-anonymous as you ordered...
    return b.code.toLocaleLowerCase() < a.code.toLocaleLowerCase() ?  1 // if b should come earlier, push a to end
         : b.code.toLocaleLowerCase() > a.code.toLocaleLowerCase() ? -1 // if b should come later, push a to begin
         : 0;                   // a and b are equal
}

function sortEvents(a, b) {
    return 0; //todo implement
}


function requestActivities(successHandler, errorHandler, sync) {
    notifyRequestStarted();

            $.ajax({
                url: "/service/event.activities",
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                async : !sync,
                dataType: 'json',
                data: JSON.stringify({
                }),
                success: function (data) {
                    var activities = data.items;
                    if (!activities) {
                        activities = [];
                    }
                    activities.sort(sortActivities);

                    successHandler(activities);

                    notifyRequestCompleted();
                },
                error: function (jqXHR, textStatus, errorThrown) {

                    errorHandler(textStatus + ", " + errorThrown);

                    notifyRequestCompleted();

                }
            });
}

function requestStartedEvent(successHandler, errorHandler) {
    notifyRequestStarted();

            $.ajax({
                url: "/service/startedEvents.getStartedEvent",
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                async : false,
                dataType: 'json',
                data: JSON.stringify({
                }),
                success: function (data) {
                    var startedEvent = data.startedEvent;
                    if (startedEvent) {
                        startedEvent.startTime = moment(startedEvent.startTime);
                        var d = new Date();
                        var n = -d.getTimezoneOffset() / 60;
                        startedEvent.startTime = startedEvent.startTime.add('hours', n);
                        startedEvent = new StartedEvent(startedEvent);
                        successHandler(startedEvent);
                    } else {
                        successHandler(undefined);
                    }



                    notifyRequestCompleted();
                },
                error: function (jqXHR, textStatus, errorThrown) {

                    notifyRequestCompleted();
                    if (errorHandler) {
                        errorHandler(textStatus + ", " + errorThrown);
                    }


                }
            });
}

function requestEventsReport(fromDate, toDate) {
    notifyRequestStarted();

            $.ajax({
                url: "/service/reportRequest.request",
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                async : 'false',
                dataType: 'json',
                data: JSON.stringify({
                    fromDate: fromDate.toISOString(),
                    toDate: toDate.toISOString()
                }),
                success: function (data) {
                    alert(data.message);
                    notifyRequestCompleted();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    var responseText = (jqXHR.responseText);
                    alert(textStatus + ", " + errorThrown + ' , ' + responseText );

                    notifyRequestCompleted();

                }
            });
}

function requestEvents(successHandler) {
    notifyRequestStarted();

            $.ajax({
                url: "/service/event.events",
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                async : false,
                dataType: 'json',
                data: JSON.stringify({
                    limit: 50
                }),
                success: function (data) {



                    var events = data.items;
                    //correct time from utc to local
                    var d = new Date();
                    var n = -d.getTimezoneOffset() / 60;

                    _.each(events, function correctTime(event){
                        var startTimeAsDate = moment(event.startTime);
                        var endTimeAsDate = moment(event.endTime);
                        if (startTimeAsDate) {
                            event.startTimeAsDate = startTimeAsDate.add('hours', n);//startTimeAsDate.add(n).hour();
                        } else {
                            event.startTimeAsDate = new Date()
                        }
                        if (endTimeAsDate) {
                            event.endTimeAsDate = endTimeAsDate.add('hours', n);//endTimeAsDate.add(n).hour();
                        } else {
                            event.endTimeAsDate = new Date()
                        }

                    });
                    //events.sort(sortEvents);

                    successHandler(events);

                    notifyRequestCompleted();
                },
                error: function (jqXHR, textStatus, errorThrown) {

                    notifyRequestCompleted();

                    alert(textStatus + ", " + errorThrown);
                }
            });
}

function sendCheckIn(requestParamObj, successHandler, errorHandler) {
    notifyRequestStarted();

        $.ajax({
            url: "/service/event.add",
            contentType: 'application/json; charset=utf-8',
            type: "POST",
            dataType: 'json',
            data: JSON.stringify({
                id: requestParamObj.id,
                activity: requestParamObj.activity.code,
                value: requestParamObj.value,
                startTime: requestParamObj.startDate.toISOString() ,
                endTime: requestParamObj.endDate.toISOString()
            }),
            success: function (data) {
                notifyRequestCompleted();
                successHandler(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                notifyRequestCompleted();
                alert('request failed : ' + errorThrown);
                errorHandler( textStatus + errorThrown)
            }
        });

}

function completeStartedEvent(paramsArgs, successHandler, errorHandler) {
    notifyRequestStarted();

        $.ajax({
            url: "/service/startedEvents.complete",
            contentType: 'application/json; charset=utf-8',
            type: "POST",
            dataType: 'json',
            data: JSON.stringify({
                startedEvent: {
                    id:paramsArgs.startedEvent.get('id'),
                    startTime : paramsArgs.startedEvent.get('startTime').toISOString(),
                    eventValue : paramsArgs.startedEvent.get('eventValue'),
                    activityCode : paramsArgs.startedEvent.get('activityCode')
                },
                endTime: paramsArgs.endTime.toISOString()
            }),
            success: function (data) {
                notifyRequestCompleted();
                successHandler(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                notifyRequestCompleted();
                alert(textStatus + ", " + errorThrown + ' , ' + responseText );
                errorHandler( textStatus + errorThrown)
            }
        });
}



Backbone.sync = function (method, model, options) {
    console.log(method + model + " " + model.urlRoot + options);

    switch (model.urlRoot) {
        case '/service/settings':
            notifyRequestStarted();
            $.ajax({
                url: "/service/settings." + method,
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                dataType: 'json',
                async : false,
                data: JSON.stringify(model.toJSON()),
                success: function (data) {
                    notifyRequestCompleted();
                    model.set(data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    notifyRequestCompleted();
                    alert('request failed : ' + errorThrown);
                }});

            break;
        case "/service/activities":
            notifyRequestStarted();
            $.ajax({
                url: "/service/activity." + method,
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                dataType: 'json',
                async : false,
                data: JSON.stringify(model.toJSON()),
                success: function (data) {
                    notifyRequestCompleted();
                    model.set(data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    notifyRequestCompleted();
                    alert('request failed : ' + errorThrown);
                }});


            break;
        case "/service/startedEvents":
            notifyRequestStarted();
            $.ajax({
                url: "/service/startedEvents." + method,
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                dataType: 'json',
                async : false,
                data: method == "delete" ? JSON.stringify({id:model.get('id')}) : JSON.stringify(model.toJSON()),
                success: function (data) {
                    notifyRequestCompleted();
                    data.startTime = moment(data.startTime);
                    model.set(data);
                    if (options && options.success) {
                        options.success(model)
                    }

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    notifyRequestCompleted();
                    alert('request failed : ' + errorThrown);
                    if (options && options.success) {
                        options.error(arguments)
                    }
                }});
            break;
    }
};