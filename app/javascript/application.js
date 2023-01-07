// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "bootstrap";

import moment from 'moment';
window.moment = moment;

import I18n from 'i18n-js/translations';
window.I18n = I18n;
