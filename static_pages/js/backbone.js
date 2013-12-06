$(function () {

    controller = new Controller(); // Создаём контроллер




    Backbone.history.start();  // Запускаем HTML5 History push

});

function navigateToActivityPage() {
    controller.navigate("activities", true);
}

function navigateToStartedEvent() {
    controller.navigate("continue", true)
}
