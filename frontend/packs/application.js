require("@rails/ujs").start();
window.Rails = require("@rails/ujs");

import "bootstrap"
import "chart.js"
import '../stylesheets/application';

window.bootbox = require('bootbox');

const images = require.context('../images', true);
