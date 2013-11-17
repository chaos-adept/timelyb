    var Controller = Backbone.Router.extend({
        routes: {
            "": "activities", // Пустой hash-тэг
            "!/": "activities", // Начальная страница
            "success": "success", // Блок удачи
            "error": "error", // Блок ошибки
            //"logEvent/:name/:startDate": "logEvent",
            "logEvent/:name": "logEvent",
            "addEvent": "addEventPage",
            "event/edit/:id": "editEventPage",
            "events/recent": "recentEvents",
            "activities": "activities"
        },

        activities: function () {

            AppState.checkAndLoadActivities();

            Views.activities.render();
        },

        logEvent: function (code) {
            AppState.startDate = new Date();

            AppState.checkAndLoadActivities();

            AppState.currentActivity = AppState.findActivity(code);
            console.debug("name: " + code );
            Views.logEvent.render();
        },

        addEventPage: function() {
            AppState.checkAndLoadActivities();
            var model = new AddEventRequestModel();
            var addEventView = new AddEventView({model: model});
            addEventView.addToStage();
        },
        editEventPage: function (eventId) {
            var event = AppState.findEvent(eventId);
            var model = new AddEventRequestModel(event);
            var editEventView = new AddEventView({model: model});
            editEventView.addToStage();
        },

        start: function () {
            if (Views.start != null) {
                Views.start.render();
            }
        },

        success: function () {
            if (Views.success != null) {
                Views.success.render();
            }
        },

        error: function () {
            if (Views.error != null) {
                Views.error.render();
            }
        },

        recentEvents: function () {
            if (Views.recentEventsView != null) {
                Views.recentEventsView.render();
            }
        }
    });


