require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

const jQuery = require('jquery');
window.jQuery = window.$ = jQuery;
global.jQuery = global.$ = jQuery;

import "bootstrap";
import "chart.js";

const bootbox = require('bootbox');
window.bootbox = bootbox;
global.bootbox = bootbox;

const images = require.context('../images', true);
window.moment = require('moment');

import I18n from 'i18n-js';
window.I18n = I18n;

import Decimal from 'decimal.js';
window.Decimal = Decimal;

require('jquery-ui');
require('jquery-ui/ui/widgets/sortable');
require('jquery-ui/ui/widgets/autocomplete');
require('jquery-ui/themes/base/all.css');

require('jquery-ui-touch-punch');

require('floatthead');

import "../javascripts/jquery.selection";
import '../stylesheets/application';
