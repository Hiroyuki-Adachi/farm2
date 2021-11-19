const { environment } = require('@rails/webpacker')
const webpack = require('webpack');

environment.toWebpackConfig().merge({
  resolve: {
    alias: {
      'jquery': 'jquery/src/jquery'
    }
  }
});

module.exports = environment
