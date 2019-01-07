<?php

namespace DrupalProject\composer;

use Composer\Script\Event;
use Symfony\Component\Filesystem\Filesystem;

/**
 * Class ScriptHandler.
 */
class ScriptHandler {

  protected static $drupalWebDir = '/src';

  protected static $spbuilderPath = 'scripts/spbuilder';

  protected static $defaultDirList = [
    'modules',
    'profiles',
    'themes',
  ];

  protected static $uriList = [
    'default',
    // 'site1',
  ];

  protected static $composerJsonMaskList = [
    '/sites/*/composer.json',
    '/profiles/*/composer.json',
    '../scripts/spbuilder/composer.json',
  ];

  /**
   * Get the Drupal root.
   *
   * @param string $project_root
   *   The project root.
   *
   * @return string
   *   The Drupal root.
   */
  protected static function getDrupalRoot($project_root) {
    return $project_root . self::$drupalWebDir;
  }

  /**
   * Create required files.
   *
   * @param \Composer\Script\Event $event
   *   THe composer event.
   */
  public static function createRequiredFiles(Event $event) {
    $fs = new Filesystem();
    $project_root = getcwd();
    $root = static::getDrupalRoot($project_root);

    // Required for unit testing.
    foreach (self::$defaultDirList as $dir) {
      if (!$fs->exists($root . '/' . $dir)) {
        $fs->mkdir($root . '/' . $dir);
        $fs->touch($root . '/' . $dir . '/.gitkeep');
      }
    }

    foreach (self::$uriList as $uri) {
      // Create the files directory with chmod 0775.
      if (!$fs->exists($root . '/sites/' . $uri . '/files')) {
        $oldmask = umask(0);
        $fs->mkdir($root . '/sites/' . $uri . '/files', 0775);
        umask($oldmask);
        $event->getIO()->write('Create a sites/' . $uri . '/files directory with chmod 0775');
      }
    }

    // Execute composer install defined on array $composerJsonMaskList.
    $composerPathListToExec = [];
    foreach (self::$composerJsonMaskList as $composer_json_mask) {
      $currentComposerList = glob($root . $composer_json_mask);
      if (is_array($currentComposerList)) {
        $composerPathListToExec = array_merge($composerPathListToExec, $currentComposerList);
      }
    }
    if ($composerPathListToExec) {
      foreach ($composerPathListToExec as $composerPathToExec) {
        exec('cd ' . dirname($composerPathToExec) . ' && composer install && cd -');
        $event->getIO()->write('Composer lauched on ' . $composerPathToExec);
      }
    }

    if (!$fs->exists($project_root . '/bin/spbuilder')) {
      $event->getIO()->write('Installing spbuilder in a separate folder');
      static::installSpbuilder();


      // Make symlink in bin/spbuilder.
      $fs->symlink(
        '../' . static::$spbuilderPath . '/bin/spbuilder',
        './bin/spbuilder'
      );
      $event->getIO()->write('Create spbuilder symlink to ' . $project_root . '/bin/spbuilder');

      //      // Symlink coding standards
      //      if (!$fs->exists('./conf/phpcs-standards')
      //        && $fs->exists('./' . static::$spbuilderPath . '/vendor/smile/php-codesniffer-rules/src')) {
      //        $fs->mkdir($project_root . '/conf');
      //        $fs->symlink(
      //          '../../' . static::$spbuilderPath . '/vendor/smile/php-codesniffer-rules/src',
      //          './conf/phpcs-standards'
      //        );
      //        $event->getIO()->write('Create conf/phpcs-standards symlink');
      //      }
    }

    if ($fs->exists($project_root . '/bin/spbuilder')) {
      // Init spbuilder.
      if (!$fs->exists($project_root . '/.spbuilder.yml')) {
        $event->getIO()->write('Init spbuilder for Drupal 8');
        static::initSpbuilder();
      }
    }

    // Remove the tests directory of dropzonejs library.
    if ($fs->exists($root . '/libraries/dropzone')) {
      if ($fs->exists($root . '/libraries/dropzone/test')) {
        $fs->remove($root . '/libraries/dropzone/test');
      }
    }
  }

  /**
   * Create required files.
   *
   * @param \Composer\Script\Event $event
   *   THe composer event.
   */
  public static function createRequiredDefaultFilesForSites(Event $event) {
    $fs = new Filesystem();
    $project_root = getcwd();
    $root = static::getDrupalRoot($project_root);

    if (!$fs->exists($root . '/sites/default/default.settings.php')) {
      $event->getIO()->write('Missing default.settings.php in sites/default. Abort');
      return;
    }

    if (!$fs->exists($root . '/sites/default/default.services.yml')) {
      $event->getIO()->write('Missing default.services.yml in sites/default. Abort');
      return;
    }

    foreach (self::$uriList as $uri) {
      if ($uri != 'default') {
        // Copy/paste default.settings.php and default.services.yml for sites
        // as it is not managed by Drupal scaffold.
        if (!$fs->exists($root . '/sites/' . $uri . '/default.settings.php')) {
          $fs->copy($root . '/sites/default/default.settings.php', $root . '/sites/' . $uri . '/default.settings.php');
          $event->getIO()->write('Create a sites/' . $uri . '/default.settings.php file');
        }

        if (!$fs->exists($root . '/sites/' . $uri . '/default.services.yml')) {
          $fs->copy($root . '/sites/default/default.services.yml', $root . '/sites/' . $uri . '/default.services.yml');
          $event->getIO()->write('Create a sites/' . $uri . '/default.services.yml file');
        }
      }
    }
  }

  /**
   * Compile assets.
   *
   * @param \Composer\Script\Event $event
   *   The composer event.
   */
  public static function compileAssets(Event $event) {
    $project_root = getcwd();

    exec('cd ' . $project_root . '/scripts/assets && npm install && ./node_modules/.bin/gulp && cd -');
  }

  /**
   * Init spbuilder.
   */
  protected static function initSpbuilder() {
    exec('bin/spbuilder init drupal8');
  }

  /**
   * Install SpBuilder in a separate path for dependencies independence purpose.
   */
  protected static function installSpbuilder() {
    // Install in $spbuilderPath.
    exec('cd ' . static::$spbuilderPath . ' && composer install && cd -');
  }

  /**
   * Remove the spbuilder symlink when preparing archive.
   *
   * Because the scripts folder is removed in the archive so the symlink is
   * broken.
   *
   * @param \Composer\Script\Event $event
   *   The composer event.
   */
  public static function removeSpbuilderSymlink(Event $event) {
    $fs = new Filesystem();
    $project_root = getcwd();

    if ($fs->exists($project_root . '/bin/spbuilder')) {
      $fs->remove($project_root . '/bin/spbuilder');
    }
  }

}
