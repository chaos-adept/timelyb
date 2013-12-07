    var Controller = Backbone.Router.extend({
        routes: {
            "": "activities", // Пустой hash-тэг
            "!/": "activities", // Начальная страница
            "success": "success", // Блок удачи
            "error": "error", // Блок ошибки
            //"logEvent/:name/:startDate": "logEvent",
            "logEvent/:name": "logEvent",
            "continue": "continueStartedEvent",
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
            if (AppState.justSubmitedEvent == false) {
                AppState.checkAndLoadStartedEvent();
                if (AppState.startedEvent) {
                    navigateToStartedEvent();
                } else {
                    showActivities();
                }
            } else {
                AppState.justSubmitedEvent = false;
                showActivities();
            }


            function showActivities() {
                Views.activities.render();
            }

        },

        logEvent: function (code) {

            //AppState.startDate = moment();

            AppState.checkAndLoadStartedEvent();
            if (AppState.startedEvent) {
                code = AppState.startedEvent.activityCode;
                showStartedEvent();
                return true;
            }
            currentActivity = AppState.findActivity(code);

            var startedEvent = new StartedEvent({activityCode:code, eventValue: currentActivity.defaultEventValue, startTime:moment(new Date().toISOString())});
            console.debug("name: " + code );

            startedEvent.save(undefined, {success:function(startedEvent){
                AppState.startedEvent = startedEvent;
                showStartedEvent();
            }, error:function (){
                console.debug("error: " + code );
                navigateToActivityPage();
            }});

            return true;

            function showStartedEvent() {
                setWindowTitle("'" + code + "', since " + (AppState.startedEvent.startTime).format("HH:mm"));
                Views.logEvent.render();
            }
        },

        continueStartedEvent: function () {
            if (AppState.startedEvent) {
                this.logEvent();
            } else {
                navigateToActivityPage();
            }

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


