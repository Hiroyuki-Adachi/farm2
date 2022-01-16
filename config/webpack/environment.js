const { environment } = require('@rails/webpacker')
const webpack = require('webpack');

environment.toWebpackConfig().merge({
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery',
      Popper: 'popper.js'
    }
  }
});

module.exports = environment
