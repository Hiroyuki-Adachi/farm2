require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

import "bootstrap"
import "chart.js"

window.bootbox = require('bootbox');

const $ = require('jquery');

require('jquery-ui');
require('jquery-ui/ui/widgets/sortable');
require('jquery-ui/ui/widgets/autocomplete');

const images = require.context('../images', true);

import '../stylesheets/application';
