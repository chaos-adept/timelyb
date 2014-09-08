angular.module('timeLybApp',['ng', 'timer'])
.controller('FetchController', ['$scope', '$http', '$templateCache',
    function ($scope, $http, $templateCache) {

        $scope.isLoading = false;

        $http({method: 'POST', url: '/service/event.activities', data: {}}).
            success(function(data, status, headers, config) {
              $scope.activities = data.items;
            }).
            error(function(data, status, headers, config) {
              // called asynchronously if an error occurs
              // or server returns response with an error status.
            });

        $http({method: 'POST', url: '/service/startedEvents.getStartedEvent', data:{}}).
            success(function(data, status, headers, config) {
              $scope.startedEvent = data.startedEvent;
            }).
            error(function(data, status, headers, config) {
              // called asynchronously if an error occurs
              // or server returns response with an error status.
            });


        $scope.startActivity = function (activity) {
            var startedEvent = {
                startTime: moment().toISOString(),
                eventValue: activity.defaultEventValue,
                activityCode: activity.code
            };

            $http({method: 'POST', url: '/service/startedEvents.create', data:startedEvent}).
                success(function(data, status, headers, config) {
                  $scope.startedEvent = data;
                }).
                error(function(data, status, headers, config) {
                  // called asynchronously if an error occurs
                  // or server returns response with an error status.
                });

        }

        $scope.cancelEvent = function () {
            $http({method: 'POST', url: '/service/startedEvents.delete', data:$scope.startedEvent}).
                success(function(data, status, headers, config) {
                  $scope.startedEvent = undefined;
                }).
                error(function(data, status, headers, config) {
                  // called asynchronously if an error occurs
                  // or server returns response with an error status.
                });
        };

        $scope.completeEvent = function () {
            $http({method: 'POST', url: '/service/startedEvents.complete', data:{
                    startedEvent:$scope.startedEvent,
                    endTime: moment().toISOString()
                    }}).
                success(function(data, status, headers, config) {
                  $scope.startedEvent = undefined;
                }).
                error(function(data, status, headers, config) {
                  // called asynchronously if an error occurs
                  // or server returns response with an error status.
                });
        };

    }]);