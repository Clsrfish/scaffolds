import merge from 'webpack-merge';
import UglifyjsWebpackPlugin from 'uglifyjs-webpack-plugin';
import commom from './webpack.config.common.babel';

export default merge(commom, {
  mode: 'production',
  plugins: [
    new UglifyjsWebpackPlugin({
      parallel: true,
      uglifyOptions: {
        warnings: false,
        keep_fnames: false,
        compress: {
          drop_console: true,
          drop_debugger: true,
        },
        output: {
          comments: false,
          beautify: false,
        },
      },
    }),
  ],
});
