import Rails from "@rails/ujs";
window.Rails = Rails;

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
global.jQuery = global.$ = jQuery;

import "bootstrap";
import "chart.js";

import bootbox from 'bootbox';
window.bootbox = bootbox;
global.bootbox = bootbox;

const images = require.context('../images', true);
import moment from 'moment';
window.moment = moment;

import I18n from 'i18n-js';
window.I18n = I18n;

import Decimal from 'decimal.js';
window.Decimal = Decimal;

import 'jquery-ui';
import 'jquery-ui/ui/widgets/sortable';
import 'jquery-ui/ui/widgets/autocomplete';
import 'jquery-ui/themes/base/all.css';

import 'jquery-ui-touch-punch';

import 'floatthead';

import "../javascripts/jquery.selection";
import '../stylesheets/application';

Rails.start();
