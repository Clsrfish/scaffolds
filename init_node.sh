#!/bin/bash
echo "node's version @`node -v`"
echo "npm's version @`npm -v`"

cp -a `dirname $0`/scaffold_node/. ./

deps=( \
    koa \
    koa-router \
)
npm install --save ${deps[@]}

dev_deps=( \
    @babel/cli \
    @babel/core \
    @babel/node \
    @babel/preset-env \
    @babel/preset-typescript \
    @types/koa \
    @types/koa-router \
    @types/node \
    awesome-typescript-loader \
    babel-loader \
    babel-preset-env \
    eslint \
    eslint-plugin-typescript \
    source-map-loader \
    ts-node \
    typescript \
    typescript-eslint-parser \
    webpack \
    webpack-cli \
)
npm install --save-dev ${dev_deps[@]}

