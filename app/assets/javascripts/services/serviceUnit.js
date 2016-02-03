/**
 * Created by Antony on 2015-12-12.
 */

var serviceUnit = cityModule.service('serviceUnit', ['$http', function($http) {
    var urlBase = '/units';

    this.getAllUnits = function () {
        return $http.get(urlBase);
    };

    this.createUnit = function (building) {
        return $http.post(urlBase, building);
    };

    this.deleteUnit = function (id) {
        return $http.delete(urlBase + '/' + id);
    };

}]);