/**
 * Created by Antony on 2015-12-12.
 */

var serviceBuilding = cityModule.service('serviceBuilding', ['$http', function($http) {
    var urlBase = '/buildings';

    this.getAllBuildings = function () {
        return $http.get(urlBase);
    };

    this.createBuilding = function (building) {
        return $http.post(urlBase, building);
    };

    this.deleteBuilding = function (id) {
        return $http.delete(urlBase + '/' + id);
    };

    this.collectBuilding = function (id) {
        return $http.get(urlBase + '/collect/' + id)
    };

}]);