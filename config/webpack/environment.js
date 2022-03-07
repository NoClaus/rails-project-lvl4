const { environment } = require('@rails/webpacker')
const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  Popper: ['@popperjs/core', 'default']
}))

module.exports = environment