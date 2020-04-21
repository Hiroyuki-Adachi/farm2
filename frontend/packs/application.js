require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

import "bootstrap"
import "chart.js"

window.bootbox = require('bootbox');

const $ = require('jquery');
const images = require.context('../images', true);

require('jquery-ui');
require('jquery-ui/ui/widgets/sortable');
require('jquery-ui/ui/widgets/autocomplete');
require('jquery-ui/themes/base/all.css');

require('floatthead');

import '../stylesheets/application';
