require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

import "bootstrap";
import "chart.js";

window.bootbox = require('bootbox');

const $ = require('jquery');
const images = require.context('../images', true);
window.moment = require('moment');

import I18n from 'i18n-js';
window.I18n = I18n;

require('jquery-ui');
require('jquery-ui/ui/widgets/sortable');
require('jquery-ui/ui/widgets/autocomplete');
require('jquery-ui/themes/base/all.css');

require('jquery-ui-touch-punch');

require('floatthead');

import "../javascripts/jquery.selection";
import '../stylesheets/application';
