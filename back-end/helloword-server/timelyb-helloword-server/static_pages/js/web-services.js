function sortActivities(a, b) { // non-anonymous as you ordered...
    return b.code.toLocaleLowerCase() < a.code.toLocaleLowerCase() ?  1 // if b should come earlier, push a to end
         : b.code.toLocaleLowerCase() > a.code.toLocaleLowerCase() ? -1 // if b should come later, push a to begin
         : 0;                   // a and b are equal
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
                    activities = data.items;
                    activities.sort(sortActivities);

                    successHandler(activities);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    errorHandler(textStatus + ", " + errorThrown);
                }
            });
}

function sendCheckIn(activity, value, startDate, endDate, successHandler, errorHandler) {

        $.ajax({
            url: "/service/event.add",
            contentType: 'application/json; charset=utf-8',
            type: "POST",
            dataType: 'json',
            data: JSON.stringify({
                activity: activity.code,
                value: value,
                startTime: startDate.toISOString() ,
                endTime: endDate.toISOString()
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