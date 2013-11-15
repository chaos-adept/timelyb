$(function () {


    var AppState = {
        username: "",
        activities: null
    };

    var Controller = Backbone.Router.extend({
        routes: {
            "": "activities", // Пустой hash-тэг
            "!/": "activities", // Начальная страница
            "success": "success", // Блок удачи
            "error": "error", // Блок ошибки
            //"logEvent/:name/:startDate": "logEvent",
            "logEvent/:name": "logEvent",
            "activities": "activities"
        },

        activities: function () {

            if (AppState.activities) {
                Views.activities.render();
            } else {
                requestActivities(function (data){
                    AppState.activities = data;
                    Views.activities.render();
                })
            }
        },

        logEvent: function (code) {
            AppState.startDate = new Date();

            if (!AppState.activities) {
                requestActivities(function (data){
                    AppState.activities = data;
                }, null, true)
            }

            AppState.currentActivity = _.where(AppState.activities, {code: code})[0];
            console.debug("name: " + code );
            Views.logEvent.render();
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
        }
    });

    var controller = new Controller(); // Создаём контроллер

//VIEW

    var LogEventView = Backbone.View.extend({
        el: $("#block"), // DOM элемент widget'а
        template: _.template($('#logEvent').html()),

        events: {
            "click :button[name='checkIn']": "checkIn",
            "click :button[name='cancel']": "cancel"
        },
        cancel: function () {
            console.log("cancel");
        },
        checkIn: function () {
            $(this.el).find(":button[name='checkIn']").attr("disabled", "disabled");

            var value = $(this.el).find("input[name='value']").val();

            sendCheckIn(AppState.currentActivity, value, AppState.startDate, new Date(), function (){
                controller.navigate("activities", true);
            });
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

            that._itemViews = [];

            jQuery.each(AppState.activities, function (itemIndx, item) {
                that._itemViews.push(new ActivityItemView({
                    model: item
                }));
            });

            // Clear out this element.
            $(this.el).empty();

            // Render each sub-view and append it to the parent view's element.
            _(this._itemViews).each(function (dv) {
                dv.render();
                var childRenderEl = dv.$el;
                childRenderEl.show();
                that.$el.append(childRenderEl);
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

    Views = {
        start: new Start(),
        success: new Success(),
        error: new Error(),
        logEvent: new LogEventView(),
        activities: new ActivitiesView()
    };


    Backbone.history.start();  // Запускаем HTML5 History push


});
