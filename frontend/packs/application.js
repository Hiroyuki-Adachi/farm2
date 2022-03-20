import '@hotwired/turbo-rails';

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
global.jQuery = global.$ = jQuery;

import "bootstrap";
import "chart.js";

const images = require.context('../images', true);
import moment from 'moment';
window.moment = moment;

import I18n from 'i18n-js';
window.I18n = I18n;

import Decimal from 'decimal.js';
window.Decimal = Decimal;

require('jquery-ui');
require('jquery-ui/themes/base/all.css');
require('jquery-ui-touch-punch');
require('floatthead');

import '@fortawesome/fontawesome-free/js/all'
import "../javascripts/jquery.selection";
import '../stylesheets/application';
