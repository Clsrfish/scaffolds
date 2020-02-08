#!/bin/bash
echo "node's version @$(node -v)"
echo "npm's version @$(npm -v)"

cp -a $(dirname $0)/scaffold_react/. ./

deps=(
    @babel/polyfill
    react
    react-dom
    react-loadable
    react-redux
    react-router-dom
    redux
    redux-saga
    core-js
)
npm install --save ${deps[@]}

dev_deps=(
    # deps types start
    @types/react
    @types/react-dom
    @types/react-loadable
    @types/react-redux
    @types/react-router-dom
    # deps types end
    # babel start
    @babel/core
    @babel/plugin-syntax-dynamic-import
    @babel/node
    @babel/preset-env
    @babel/preset-react
    @babel/preset-typescript
    # babel end
    # eslint start
    eslint
    eslint-config-airbnb
    eslint-plugin-import
    eslint-plugin-jsx-a11y
    eslint-plugin-react
    eslint-plugin-typescript
    @typescript-eslint/eslint-plugin
    @typescript-eslint/parser
    babel-eslint
    # eslint end
    # loader start
    css-loader
    node-sass
    sass-loader
    less
    less-loader
    babel-loader
    typescript
    awesome-typescript-loader
    url-loader
    file-loader
    svg-inline-loader
    #load end
    # webpack plugin start
    html-webpack-plugin
    mini-css-extract-plugin
    clean-webpack-plugin
    uglifyjs-webpack-plugin
    # webpack plugin end
    source-map-loader
    # webpack start
    webpack
    webpack-cli
    webpack-dev-server
    webpack-merge
    webpack-pwa-manifest
    workbox-webpack-plugin
    # webpack end
)
npm install --save-dev ${dev_deps[@]}
npm audit fix
