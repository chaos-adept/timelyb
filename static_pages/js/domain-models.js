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

var SettingsModel = Backbone.Model.extend({
    constructor: function() {
        this.urlRoot = "/service/settings";
        this.timeZoneOffset = 0;
        Backbone.Model.apply(this, arguments);
    }
});

var ActivityModel = Backbone.Model.extend({
    defaults: {
        id: null, code: null, name: null, tags: [], thumbUrl: null, defaultEventValue: null
    },

    constructor: function() {
        this.urlRoot = "/service/activities";
        Backbone.Model.apply(this, arguments);
    }
});

var StartedEvent = Backbone.Model.extend({
    constructor: function(args) {
        this.urlRoot = "/service/startedEvents";
        this.activityCode = args.activityCode;
        this.eventValue = args.eventValue;
        this.startTime = args.startTime;
        Backbone.Model.apply(this, arguments);
    }
});

var AddEventRequestModel = Backbone.Model.extend({
  constructor: function(event) {
    var currentDate = moment();
    if (event) {
        currentDate = event.startTimeAsDate
    }
    this.year = currentDate.year();
    this.month = currentDate.month();
    this.day = currentDate.date();
    this.startHour = currentDate.hours();
    this.startMinutes = currentDate.minutes();

    this.endHour = this.startHour;
    this.endMinutes = this.startMinutes;

    this.activityCode = null;
    this.id = null;
    this.value = 0;

    if (event) {
        this.id = event.id
        this.activityCode = event.activity;
        this.value = event.value;
        var endDate = event.endTimeAsDate;
        this.endHour = endDate.hours();
        this.endMinutes = endDate.minutes();
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
    settings: new SettingsModel(),
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
    findActivityById: function (activityId) {
        return _.where(AppState.activities(), {id: activityId})[0];
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
    },
    addOrUpdateActivity: function (activity) {
        if (!AppState._activities) {
            AppState._activities = [activity];
        } else {
            var exitedActivity = AppState.findActivityById(activity.id);
            if (exitedActivity) {
                $.extend(exitedActivity, activity);
            } else {
                AppState._activities.push(activity);
            }

        }
    }

};