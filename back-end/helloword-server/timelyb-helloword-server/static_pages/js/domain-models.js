/**
 * Created with PyCharm.
 * User: WORKSATION
 * Date: 16.11.13
 * Time: 7:24
 * To change this template use File | Settings | File Templates.
 */

var AppState = {
    username: "",
    _activities: null,
    checkAndLoadActivities: function () {
        if (!AppState._activities) {
            requestActivities(function (data){
                AppState._activities = data;
            }, null, true)
        }
    },
    getActivities: function () {
        AppState.checkAndLoadActivities();
        return AppState._activities;
    },
    activities: function () {
        return AppState.getActivities();
    }
};

var AddEventRequestModel = Backbone.Model.extend({
  constructor: function() {
    var currentDate = new Date();
    this.year = currentDate.getFullYear();
    this.month = currentDate.getMonth();
    this.day = currentDate.getDate();
    this.startHour = currentDate.getHours();
    this.startMinutes = currentDate.getMinutes();
    this.endHour = this.startHour;
    this.endMinutes = this.startMinutes;
    this.activityCode = null;
    Backbone.Model.apply(this, arguments);
  },

  activitiesOptions: function () {
    return AppState.activities();
  }
});