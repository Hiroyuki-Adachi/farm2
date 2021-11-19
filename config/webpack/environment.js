const { environment } = require('@rails/webpacker')
const webpack = require('webpack');

environment.toWebpackConfig().merge({
  resolve: {
    alias: {
      $: 'jquery',
      jQuery: 'jquery',
      Popper: 'popper.js'
    }
  }
});

module.exports = environment
