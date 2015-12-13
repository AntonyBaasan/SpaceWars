/**
 * Created by Antony on 2015-12-12.
 */

var serviceCity = cityModule.service('serviceCity', ['$http', function($http) {
    var urlBase = '/cities';

    this.getFighterCities = function () {
        return $http.get(urlBase+'/fighterslist');
    };

    this.createUnit = function (building) {
        return $http.post(urlBase, building);
    };

    this.deleteUnit = function (id) {
        return $http.delete(urlBase + '/' + id);
    };

}]);