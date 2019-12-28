const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const webpack = require("webpack")

environment.loaders.append('jquery', {
    test: require.resolve('jquery'),
    use: [{
        loader: 'expose-loader',
        options: '$',
    }, {
        loader: 'expose-loader',
        options: 'jQuery',
    }],
});

environment.loaders.prepend('erb', erb)
module.exports = environment