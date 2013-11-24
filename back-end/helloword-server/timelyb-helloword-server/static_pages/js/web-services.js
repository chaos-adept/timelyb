function sortActivities(a, b) { // non-anonymous as you ordered...
    return b.code.toLocaleLowerCase() < a.code.toLocaleLowerCase() ?  1 // if b should come earlier, push a to end
         : b.code.toLocaleLowerCase() > a.code.toLocaleLowerCase() ? -1 // if b should come later, push a to begin
         : 0;                   // a and b are equal
}

function sortEvents(a, b) {
    return 0; //todo implement
}


function requestActivities(successHandler, errorHandler, sync) {
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
                    activities.sort(sortActivities);

                    successHandler(activities);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    errorHandler(textStatus + ", " + errorThrown);
                }
            });
}

function requestEvents(successHandler) {
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
                        var startTimeAsDate = Date.parse(event.startTime);
                        var endTimeAsDate = Date.parse(event.endTime);
                        event.startTimeAsDate = startTimeAsDate.add(n).hour();
                        event.endTimeAsDate = endTimeAsDate.add(n).hour();
                    });
                    events.sort(sortEvents);

                    successHandler(events);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + ", " + errorThrown);
                }
            });
}

function sendCheckIn(requestParamObj, successHandler, errorHandler) {
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
                successHandler(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert('request failed : ' + errorThrown);
                errorHandler( textStatus + errorThrown)
            }
        });

}



Backbone.sync = function (method, model, options) {
    console.log(method + model + options);

    switch (model.urlRoot) {
        case '/service/settings':

            $.ajax({
                url: "/service/settings." + method,
                contentType: 'application/json; charset=utf-8',
                type: "POST",
                dataType: 'json',
                async : false,
                data: JSON.stringify(model.toJSON()),
                success: function (data) {
                    model.set(data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert('request failed : ' + errorThrown);
                }});

            break;

    }
};