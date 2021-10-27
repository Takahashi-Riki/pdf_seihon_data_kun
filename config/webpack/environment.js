const { environment } = require('@rails/webpacker')
module.exports = environment

//jquery
const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

//jquery-ui
environment.toWebpackConfig().merge({
    resolve: {
        alias: {
            'jquery': 'jquery/src/jquery'
        }
    }
});