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

            sendCheckIn(
                    {activity: AppState.currentActivity,
                    value: value,
                    startDate: AppState.startDate,
                    endDate: new Date()},
            function (){
                navigateToActivityPage();
            }, function (){
                $(that.el).find(":button[name='checkIn']").enableButton();
            }
            );
        },
        cancel: function () {
            navigateToActivityPage();
        },
        render: function () {
            $(this.el).html(this.template(AppState));
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
        tagName: "div",
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

    Views = {
        start: new Start(),
        success: new Success(),
        error: new Error(),
        logEvent: new LogEventView(),
        activities: new ActivitiesView(),
        recentEventsView: new RecentEventsView()
    };