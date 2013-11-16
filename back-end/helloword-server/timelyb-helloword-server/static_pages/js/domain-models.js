/**
 * Created with PyCharm.
 * User: WORKSATION
 * Date: 16.11.13
 * Time: 7:24
 * To change this template use File | Settings | File Templates.
 */

$.fn.serializeObject = function()
{
   var o = {};
   var a = this.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           o[this.name] = this.value || '';
       }
   });
   return o;
};

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
    },
    findActivity: function (activityCode) {
        return _.where(AppState.activities(), {code: activityCode})[0];
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
  },
  getActivity: function () {
      return AppState.findActivity(this.attributes.activityCode)
  }
});