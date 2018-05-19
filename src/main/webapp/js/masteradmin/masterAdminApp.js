'use strict';
// Declare app level module which depends on filters, and services
var app = angular.module('masterAdminApp', ['720kb.datepicker', 'angularSpinners', 'ngAnimate', 'toastr']);

app.config(function (toastrConfig) {
    angular.extend(toastrConfig, {
        positionClass: 'toast-bottom-right'
    });
});
