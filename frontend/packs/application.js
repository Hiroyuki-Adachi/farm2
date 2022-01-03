require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
global.jQuery = global.$ = jQuery;

import bootstrap from "bootstrap";
window.bootstrap = bootstrap;
global.bootstrap = bootstrap;

import "chart.js";

import bootbox from 'bootbox';
window.bootbox = bootbox;
global.bootbox = bootbox;

const images = require.context('../images', true);
window.moment = require('moment');

import I18n from 'i18n-js';
window.I18n = I18n;

import Decimal from 'decimal.js';
window.Decimal = Decimal;

require('jquery-ui');
require('jquery-ui/themes/base/all.css');
require('jquery-ui-touch-punch');
require('floatthead');

import "../javascripts/jquery.selection";
import '../stylesheets/application';
