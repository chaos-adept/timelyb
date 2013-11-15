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
                    successHandler(data.items);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    errorHandler(textStatus + ", " + errorThrown);
                }
            });
}

function sendCheckIn(activity, value, startDate, endDate, successHandler) {

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
            }
        });

}