import path from 'path';
import merge from 'webpack-merge';
import commom from './webpack.config.common.babel';

export default merge(commom, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    compress: true,
    port: 9090,
    historyApiFallback: true, // 解决刷新浏览器 404 问
  },
});
