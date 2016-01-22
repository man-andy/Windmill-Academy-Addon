'use strict';

var gulp = require('gulp');
var taskLoader = require('gulp-simple-task-loader');
var plugins = require('gulp-load-plugins')();
var config = require('./config.json');

taskLoader({
    taskDirectory: 'bower_components/gulp-tasks/tasks',
    plugins: plugins,
    config: config
});

gulp.task('ie8-headjs', function() {
    gulp.src([
        "bower_components/jquery-legacy/dist/jquery.js",
        "javascript/jquery.noconflict.js",
        "bower_components/jquery-placeholder/jquery.placeholder.min.js",
        "javascript/head.js"
    ])
    .pipe(plugins.concat('ie8-head.min.js'))
    .pipe(plugins.uglify({"mangle": true}))
    .pipe(gulp.dest('javascript/optimized/'))
});

gulp.task('ie8-bodyjs', function() {
    gulp.src([
        "bower_components/Respond/dest/respond.src.js",
        "bower_components/REM-unit-polyfill/js/rem.js",
        "bower_components/selectivizr/selectivizr.js"
    ])
    .pipe(plugins.concat('ie8-body.min.js'))
    .pipe(plugins.uglify({"mangle": true}))
    .pipe(gulp.dest('javascript/optimized/'))
});
