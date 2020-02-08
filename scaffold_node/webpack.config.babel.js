/* eslint-disable no-undef */
import path from "path";
import webpack from "webpack";

export default {
    mode: "production",
    target: "node",
    entry: {
        index: './src/index.ts',
    },
    output: {
        filename: '[name].js',
        chunkFilename: '[name].js',
        path: path.resolve(__dirname, 'dist'),
    },
    resolve: {
        extensions: ['.ts', '.js', '.json'],
    },
    node: {
        __filename: false,
        __dirname: false
    },
    module: {
        rules: [
            {
                test: /\.(js)|(ts)$/,
                use: [
                    {
                        loader: 'babel-loader',
                        options: {
                            babelrc: true,
                        },
                    }, {
                        loader: 'awesome-typescript-loader',
                    },
                ],
                exclude: [path.resolve(__dirname, 'node_modules')],
            },
            {
                test: /\.js$/,
                use: ['source-map-loader'],
                enforce: 'pre',
            }
        ],
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin()
    ]
};
