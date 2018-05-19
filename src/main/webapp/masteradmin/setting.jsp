<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/imports.jsp" %>

<div class="container-fluid" ng-controller="settingController">
    <div class="row">
        <div class="form-group form-inline">
            <label for="digicelJamaica" class="control-label">Digicel Jamaica return percent </label>
            <input id="digicelJamaica" ng-model="digicelJamaica" type="number" class="form-control"/>
        </div>
    </div>
</div>

<script>
    app.controller('settingController', function ($scope, $http, spinnerService) {
        $scope.updateDigicelJamaica = function (value) {
            var data = $.param({
                type: 0,
                value: value
            });

            var config = {headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'}};

            $http.post('/masteradmin/setting/update-by-type', data, {
                headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'}
            }).success(function (data, status, headers, config) {

            }).error(function (data, status, header, config) {
                console.error(data);
            });
        };

        $http.get('/masteradmin/setting/find-by-type', {
            params: {type: 0}
        }).success(function (digicelJamaica) {
            $scope.digicelJamaica = parseInt(digicelJamaica.value);
        }).catch(function (err) {
            console.error(err);
        });

        $scope.$watch('digicelJamaica', function (value) {
            if (value == undefined) {
                return;
            }

            $scope.updateDigicelJamaica(value);
        });
    });
</script>
