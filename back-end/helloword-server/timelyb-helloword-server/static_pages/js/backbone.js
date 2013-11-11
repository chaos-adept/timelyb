$(function () {


    var AppState = {
        username: ""
    };

    var Controller = Backbone.Router.extend({
        routes: {
            "": "start", // Пустой hash-тэг
            "!/": "activities", // Начальная страница
            "success": "success", // Блок удачи
            "error": "error", // Блок ошибки
            "logEvent": "logEvent",
            "activities": "activities"

        },

        activities: function () {
            Views.activities.render();
        },

        logEvent: function () {
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
            console.log("checkIn");
            controller.navigate("activities", true);
        },
        render: function () {
            $(this.el).html(this.template(AppState));
        }
    });

    var ActivitiesView = Backbone.View.extend({
        el: $("#block"),

        template: _.template($('#activities').html()),

        events: {

        },
        render: function () {
            $(this.el).html(this.template(AppState));
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
