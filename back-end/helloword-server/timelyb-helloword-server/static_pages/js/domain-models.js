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

var AddEventRequestModel = Backbone.Model.extend({
  constructor: function(event) {
    var currentDate = new Date();
    if (event) {
        currentDate = new Date(event.startTime)
    }
    this.year = currentDate.getFullYear();
    this.month = currentDate.getMonth();
    this.day = currentDate.getDate();
    this.startHour = currentDate.getHours();
    this.startMinutes = currentDate.getMinutes();

    this.endHour = this.startHour;
    this.endMinutes = this.startMinutes;

    this.activityCode = null;
    this.id = null;
    this.value = 0;

    if (event) {
        this.id = event.id
        this.activityCode = event.activity;
        this.value = event.value;
        var endDate = new Date(event.endTime);
        this.endHour = endDate.getHours();
        this.endMinutes = endDate.getMinutes();
    }

    Backbone.Model.apply(this, arguments);
  },
    getStartDate: function () {
        var result = new Date(parseInt(this.attributes.year), parseInt(this.attributes.month), parseInt(this.attributes.day), parseInt(this.attributes.startHour), parseInt(this.attributes.startMinutes), 0, 0);
        return result;
    },
    getEndDate: function () {
        var result = new Date(this.attributes.year, this.attributes.month, this.attributes.day, this.attributes.endHour, this.attributes.endMinutes, 0, 0);
        return result;
    },
  activitiesOptions: function () {
    return AppState.activities();
  },
  getActivity: function () {
      return AppState.findActivity(this.attributes.activityCode)
  }
});

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
    },
    checkAndLoadEvents: function () {
        if (!AppState._events) {
            requestEvents(function (data){
                AppState._events = data;
            });
        }
    },
    events: function () {
        AppState.checkAndLoadEvents();
        return AppState._events;
    },
    findEvent: function (eventId) {
        return _.where(AppState.events(), {id: eventId})[0];
    },
    addOrUpdateEvent: function (event) {
        var existedEvent = AppState.findEvent(event.id);
        if (existedEvent) {
            $.extend(existedEvent, event);
        } else {
            AppState.events().push(event)
        }
    }

};