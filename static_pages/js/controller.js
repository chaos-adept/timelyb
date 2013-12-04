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
            "activities": "activities",
            "activities/add": "addActivityPage",
            "activities/edit/:activityCode": "editActivityPage",
            "reports/request": 'requestReportPage',
            "settings": "settings"

        },

        activities: function () {
            setWindowTitle("Activities");
            AppState.checkAndLoadActivities();

            Views.activities.render();
        },

        logEvent: function (code) {

            //AppState.startDate = moment();

            currentActivity = AppState.findActivity(code);

            AppState.startedEvent = new StartedEvent({activityCode:code, eventValue: currentActivity.defaultEventValue, startTime:moment()});
            console.debug("name: " + code );

            setWindowTitle("'" + code + "', since " + AppState.startedEvent.startTime.format("HH:mm"));

            AppState.startedEvent.save();

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

        addActivityPage: function() {
            var model = new ActivityModel();
            var editModelView = new EditActivityView({model: model});
            editModelView.addToStage();
        },

        editActivityPage: function(activityCode) {
            AppState.checkAndLoadActivities();
            var activity = AppState.findActivity(activityCode);
            var model = new ActivityModel();
            model.set(activity);
            var editModelView = new EditActivityView({model: model});
            editModelView.addToStage();
        },

        requestReportPage: function() {
          var requestReportView = new RequestReportView();
          requestReportView.addToStage();
        },

        settings: function () {
            AppState.settings.fetch();
            Views.settingsPage.render();
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


