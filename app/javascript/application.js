// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Turbo from '@hotwired/turbo';

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
global.jQuery = global.$ = jQuery;

import "chart.js";

import moment from 'moment';
window.moment = moment;

import I18n from 'i18n-js/translations';
window.I18n = I18n;

import Decimal from 'decimal.js';
window.Decimal = Decimal;

import '@fortawesome/fontawesome-free/js/all'
import "/javascripts/jquery.selection";

import loading from "/javascripts/loading";
window.loading = loading;
import * as bootstrap from "bootstrap"
