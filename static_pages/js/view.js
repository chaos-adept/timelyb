//VIEW

    var LogEventView = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а
        template: _.template($('#logEvent').html()),

        events: {
            "click :button[name='checkIn']": "checkIn",
            "click :button[name='cancel']": "cancel"
        },
        checkIn: function () {
            $(this.el).find(":button[name='checkIn']").disableButton();
            var that = this;
            var value = $(this.el).find("input[name='value']").val();

            AppState.startedEvent.eventValue = value;
            completeStartedEvent(
                {startedEvent: AppState.startedEvent,
                 endTime: new Date()},
            function (){
                AppState.startedEvent = null;
                AppState.justSubmitedEvent = true;
                navigateToActivityPage();
            }, function (){
                $(that.el).find(":button[name='checkIn']").enableButton();
            }
            );
        },
        cancel: function () {
            AppState.startedEvent.destroy();
            AppState.startedEvent = null;
            AppState.justSubmitedEvent = true;
            navigateToActivityPage();
        },
        render: function () {
            $(this.el).html(this.template(AppState.startedEvent.attributes));
        }
    });

    var ActivityItemView = Backbone.View.extend({
        tagName: "div",
        template: _.template($("#activityItem").html()),
        render: function () {
            $(this.el).html(this.template(this.model));
        }
    });

    var ActivitiesView = Backbone.View.extend({
        el: $("#block"),

        template: _.template($('#activities').html()),

        initialize: function () {
            this._itemViews = [];
        },

        events: {

        },
        render: function () {
            var that = this;

            // Clear out this element.
            $(this.el).empty();

            $(this.el).html(this.template(AppState));
            var containerEl = $(this.el).find(".activitiesContainer");
            that._itemViews = [];

            jQuery.each(AppState.activities(), function (itemIndx, item) {
                that._itemViews.push(new ActivityItemView({
                    model: item
                }));
            });



            // Render each sub-view and append it to the parent view's element.
            _(this._itemViews).each(function (dv) {
                dv.render();
                var childRenderEl = dv.$el;
                childRenderEl.show();
                $(containerEl).append(childRenderEl);
            });
        }

    });

    var EventItemView = Backbone.View.extend({
        tagName: "tr",
        template: _.template($("#eventItem").html()),
        render: function () {
            $(this.el).html(this.template(this.model));
        }
    });

    var RecentEventsView = Backbone.View.extend({
        el: $("#block"),
        template: _.template($('#recentEvents').html()),

        initialize: function () {
            this._itemViews = [];
        },

        events: {

        },
        render: function () {
            var that = this;

            // Clear out this element.
            $(this.el).empty();

            $(this.el).html(this.template(AppState));
            var containerEl = $(this.el).find(".eventsContainer");
            that._itemViews = [];

            jQuery.each(AppState.events(), function (itemIndx, item) {
                that._itemViews.push(new EventItemView({
                    model: item
                }));
            });



            // Render each sub-view and append it to the parent view's element.
            _(this._itemViews).each(function (dv) {
                dv.render();
                var childRenderEl = dv.$el;
                childRenderEl.show();
                $(containerEl).append(childRenderEl);
            });
        }
    });

    var Start = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а

        template: _.template($('#start').html()),

        events: {
            //"click input:button": "check" // Обработчик клика на кнопке "Проверить"
        },
        check: function () {
            if ($(this.el).find("input:text").val() == "test") // Проверка текста
                controller.navigate("success", true); // переход на страницу success
            else
                controller.navigate("error", true); // переход на страницу error
        },
        render: function () {
            $(this.el).html(this.template(AppState));
        }
    });

    var Success = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а

        template: _.template($('#success').html()),

        render: function () {
            $(this.el).html(this.template(AppState));
        }
    });

    var Error = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а

        template: _.template($('#error').html()),

        render: function () {
            $(this.el).html(this.template(AppState));
        }
    });


    var SettingPageView = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а

        template: _.template($('#settingsPageView').html()),

        events: {
            "click :button[name='save']": "save",
            "click :button[name='cancel']": "cancel"
        },

        getInputtedTimZone: function () {
            return this.$(".timeZoneInput").val();
        },

        save: function () {
            $(this.el).find(":button[name='submit']").disableButton();
            AppState.settings.set({timeZoneOffset: this.getInputtedTimZone()});
            AppState.settings.save({wait: true});

            $(this.el).find(":button[name='submit']").enableButton();

            navigateToActivityPage();
        },

        cancel: function () {
            navigateToActivityPage();
        },

        render: function () {
            $(this.el).html(this.template(AppState.settings));
        }
    });

    var AddEventView = Backbone.View.extend({
        tagName: "div", // DOM элемент widget'а
        template: _.template($('#addEvent').html()),

        events: {
            "click :button[name='submit']": "submit",
            "click :button[name='cancel']": "cancel"
        },

        serialize: function () {
            var obj = $("form[name='inputValuesForm']").serializeObject();

            return obj;
        },

        submit: function () {

            //todo move to model
            $(this.el).find(":button[name='submit']").disableButton();

            var result = this.serialize();

            this.model.set(result);
            var activity = this.model.getActivity();
            var startDate = this.model.getStartDate();
            var endDate = this.model.getEndDate();

            var reqParamObj =
                   {id: this.model.get('id'),
                    activity: activity,
                    value: this.model.get("value"),
                    startDate: startDate,
                    endDate: endDate};

            sendCheckIn(reqParamObj, this.onSumbitted, this.enableSubmitBtn);


//            sendCheckIn();
        },

        onSumbitted: function (event) {
            AppState.addOrUpdateEvent(event);
            navigateToActivityPage();
        },

        cancel: function () {
            navigateToActivityPage();
        },


        enableSubmitBtn: function () {
            $(this.el).find(":button[name='submit']").enableButton();
        },

        addToStage: function () {
            $("#block").empty();
            this.render();
            $("#block").append(this.el);
        },

        render: function () {
            $(this.el).html(this.template(this.model));
        }
    });

    EditActivityView = Backbone.View.extend({
        tagName: "div", // DOM элемент widget'а
        template: _.template($('#editActivity').html()),

        events: {
            "click :button[name='submit']": "submit",
            "click :button[name='cancel']": "cancel"
        },

        addToStage: function () {
            $("#block").empty();
            this.render();
            $("#block").append(this.el);
        },

        submit: function () {
            $(this.el).find(":button[name='submit']").disableButton();

            var obj = $("form[name='inputValueForm']").serializeObject();
            var tags = obj.tagsAsString.replace(',', ' ').split(' ');
            obj.tags = tags;
            obj.defaultEventValue = parseFloat(obj.defaultEventValue);
            delete obj.tagsAsString;
            this.model.set(obj);

            if (this.model.hasChanged() == true) {
               this.model.save({wait: true});
               this.onSumbitted(this.model.attributes);
            } else {
                navigateToActivityPage();
            }

            $(this.el).find(":button[name='submit']").enableButton();
        },


        onSumbitted: function (activity) {
            AppState.addOrUpdateActivity(activity);
            navigateToActivityPage();
        },

        cancel: function () {
            navigateToActivityPage();
        },

        render: function () {
            $(this.el).html(this.template(this.model.attributes));
        }
    });

    RequestReportView = Backbone.View.extend({
        tagName: "div", // DOM элемент widget'а
        template: _.template($('#requestReport').html()),

        events: {
            "click :button[name='request']": "submit",
            "click :button[name='cancel']": "cancel",
            "click .todayBtn": "setupTodayValues",
            "click .yesterdayBtn": "setupYesterdayValues",
            "click .weekBtn": "setupWeekValues",
            "click .monthBtn": "setupMonthValues"
        },
        //fixme variable names
        setupTodayValues: function() {
            var currentDate = moment().add('days', 1);
            var tomorrow = moment();

            this.setupInputValuesByDates(currentDate, tomorrow);
        },

        setupYesterdayValues: function() {
            var currentDate = moment();
            var yesterdayDate = moment().subtract('days', 1);

            this.setupInputValuesByDates(currentDate, yesterdayDate);
        },

        setupWeekValues: function() {
            var currentDate = moment();
            var week = moment().subtract('weeks', 1);
            this.setupInputValuesByDates(currentDate, week);
        },

        setupMonthValues: function() {
            var currentDate = moment();
            var month = moment().subtract('months', 1);
            this.setupInputValuesByDates(currentDate, month);
        },

        setupInputValuesByDates: function (fromDate, toDate) {
            var data = {};
            data.startYear = toDate.year();
            data.startMonth = toDate.month();
            data.startDay = toDate.date();

            data.endYear = fromDate.year();
            data.endMonth = fromDate.month();
            data.endDay = fromDate.date();

            this.timeObjToFormValues(data);
        },

        timeObjToFormValues: function (data) {
            $("form[name='inputValueForm']").formValuesFromObj(data);
        },

        addToStage: function () {
            $("#block").empty();
            this.render();
            $("#block").append(this.el);
        },

        submit: function () {
            $(this.el).find(":button[name='submit']").disableButton();

            var obj =  $(this.el).find("form[name='inputValueForm']").serializeObject();

            var fromDate = moment({year: obj.startYear, month: obj.startMonth, day: obj.startDay});
            var toDate = moment({year: obj.endYear, month: obj.endMonth, day: obj.endDay});

            requestEventsReport(fromDate, toDate);
            //navigateToActivityPage();

            $(this.el).find(":button[name='submit']").enableButton();
        },


        onSumbitted: function (activity) {
            navigateToActivityPage();
        },

        cancel: function () {
            navigateToActivityPage();
        },

        render: function () {
            $(this.el).html(this.template(AppState));
        }
    });

    Views = {
        start: new Start(),
        success: new Success(),
        error: new Error(),
        logEvent: new LogEventView(),
        activities: new ActivitiesView(),
        recentEventsView: new RecentEventsView(),
        settingsPage: new SettingPageView()
    };