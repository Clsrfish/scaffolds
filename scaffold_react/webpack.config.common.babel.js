import path from 'path';
import { DefinePlugin } from 'webpack';
import WorkboxPlugin from 'workbox-webpack-plugin';
import WebpackPwaManifest from 'webpack-pwa-manifest';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import { CleanWebpackPlugin } from 'clean-webpack-plugin';

import PACKAGE from './package.json';

const SERVICE_WORKER_FILE_NAME = 'service-worker.js';

export default {
  // babel-polyfill used for this https://labs.chiedo.com/blog/regenerateruntime-error-in-react
  entry: {
    index: './src/index.tsx',
  },
  output: {
    filename: 'js/[name].[contenthash:8].js',
    chunkFilename: 'js/[name].[contenthash:8].js',
    path: path.resolve(__dirname, 'dist'),
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx', '.json'],
  },
  module: {
    rules: [
      {
        test: /\.(js)|(ts)x?$/,
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
      },
      {
        test: /\.(css|less|scss)$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              modules: true,
              localIdentName: '[name].[local].[contenthash:4]',
            },
          },
          {
            loader: 'less-loader',
            options: {
              strictMath: true,
              noIeCompat: true,
            },
          },
          {
            loader: 'sass-loader',
          },
        ], // 顺序不能错，否则报错
      },
      {
        test: /\.(png|jpe?g|gif|svg)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 1000,
              name: 'assets/img/[name].[contenthash:4].[ext]',
            },
          },
        ],
      },
    ],
  },
  optimization: {
    runtimeChunk: {
      name: 'runtime',
    },
    splitChunks: {
      chunks: 'all',
      maxAsyncRequests: 5,
      maxInitialRequests: 3,
      automaticNameDelimiter: '.',
      name: true,
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          priority: -10,
          name: 'vendors',
        },
      },
    },
  },
  plugins: [
    new DefinePlugin({
      SERVICE_WORKER_FILE: JSON.stringify(SERVICE_WORKER_FILE_NAME),
    }),
    new MiniCssExtractPlugin({
      filename: 'css/[name].[contenthash:8].css',
      chunkFilename: 'css/[name].[contenthash:8].css',
    }),
    new HtmlWebpackPlugin({
      title: `${PACKAGE.name}`,
      favicon: 'assets/favicon.ico',
      template: 'src/index.ejs',
    }),
    new CleanWebpackPlugin(),
    new WorkboxPlugin.GenerateSW({
      swDest: SERVICE_WORKER_FILE_NAME,
      clientsClaim: true,
      skipWaiting: true,

      // globIgnores: ['node_modules/**/*', 'service-worker.js'],

      exclude: [/\.(?:png|jpe?g|gif|svg)$/],
      runtimeCaching: [{
        urlPattern: /\.(?:png|jpe?g|gif|svg)$/,
        handler: 'staleWhileRevalidate',
        options: {
          cacheName: 'images',
          expiration: {
            maxEntries: 10,
          },
        },
      }],
    }),
    new WebpackPwaManifest({
      name: `${PACKAGE.name}`,
      short_name: PACKAGE.name,
      description: PACKAGE.description,
      start_url: '.',
      theme_color: 'aliceblue',
      background_color: 'aliceblue',
      orientation: 'portrait',
      display: 'standalone',
      fingerprints: false,
      ios: true,
      inject: true,
      icons: [
        {
          src: 'assets/icon.jpg',
          sizes: [96, 128, 144, 192, 256, 384, 512], // multiple sizes
          destination: 'icons',
        },
      ],
    }),
  ],
};
