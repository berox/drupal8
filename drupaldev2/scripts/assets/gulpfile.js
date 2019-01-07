var gulp = require('gulp');
var watch = require('gulp-watch');
var rename = require('gulp-rename');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var sassGlob = require('gulp-sass-glob');
var spritesmith = require('gulp.spritesmith');
var imagemin = require('gulp-imagemin');

var profile_name = 'TO COMPLETE';
var themes_path = '../../src/profiles/custom/' + profile_name + '/themes/custom';
var base_theme_path = themes_path + '/TO COMPLETE';

var base_theme_css_path = '/profiles/custom/' + profile_name + '/themes/custom/TO COMPLETE';

function generate_theme_styles(theme_path) {
  gulp.src(theme_path + '/scss/custom/*.scss')
    .pipe(sassGlob())
    .pipe(sass({outputStyle: 'compressed'}).on('error', errorHandler))
    .pipe(concat('style.css'))
    .pipe(gulp.dest(theme_path + '/assets/css/'));
}

gulp.task('style_base_theme', generate_theme_styles(base_theme_path));

// Sprite generation.
gulp.task('sprite', function () {
  var spriteData = gulp.src(base_theme_path + '/assets/images/sprite/*.png').pipe(spritesmith({
    imgName: base_theme_path + '/assets/images/spritesheet.png',
    cssName: base_theme_path + '/scss/_sprite.scss',
    imgPath: base_theme_css_path + '/assets/images/spritesheet.png',
    padding: 20
  }));
  return spriteData.pipe(gulp.dest(''));
});

// Optimize images.
function folder_images_optimization(folder_path) {
  gulp.src(folder_path + '/*')
    .pipe(imagemin({
      progressive: true
    }))
    .pipe(gulp.dest(folder_path)).on('error', errorHandler);
}

gulp.task('theme_image_optimization', folder_images_optimization(base_theme_path + '/assets/images'));

gulp.task('styles', [
  'style_base_theme'
]);

gulp.task('image_optimization', [
  'theme_image_optimization'
]);

gulp.task('default', [
  // 'sprite',
  'styles',
  'image_optimization'
]);

// Watch task.
gulp.task('watch', function () {
  gulp.watch([themes_path + '/**/*.scss'], function () {
    generate_theme_styles(base_theme_path);
  });
});

// Handle the error.
function errorHandler(error) {
  console.log(error.toString());
  this.emit('end');
}
