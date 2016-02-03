/**
 * Created by Antony on 2015-12-12.
 */

var serviceCity = cityModule.service('serviceCity', ['$http', function($http) {
    var urlBase = '/cities';

    this.getMyCityInfo = function () {
        return $http.get(urlBase+'/1.json');//put 1 just to redirect to SHOW method
    };

    this.getFighterCities = function () {
        return $http.get(urlBase+'/fighterslist');
    };

    this.fightWithCity = function (cityId) {
        return $http.get(urlBase+'/fight/'+cityId);
    };


}]);