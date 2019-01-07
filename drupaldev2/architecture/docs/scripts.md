Script list
===========

 + __scripts/cache-clean.sh [env] [uri]__ : Clean Redis, Drupal and Varnish cache.
 + __scripts/deploy.sh [env] [-p packageVersion or -b branch or -t tag] [-f]__ : Deploy the given version (or a specific tag or branch) on the target environment. If it is the first deployment on an evironment, use the -f option.
 + __scripts/install.sh [env] [folder_name] [uri]__ : Install Drupal on LXC using the Drupal setup.
 + __scripts/generate-settings.sh [env]__ : Regenerate sahred files (settings.php, services.yml, sites.php) on the given environment.
 + __scripts/permissions.sh [env]__ : Restore the file permissions on the given environment.
 + __scripts/provision.sh [env]__ : Install all needed components and configure them.
 + __scripts/run-tests-phpunit.sh [env] --group=my_group OR /path/to/test/file__ : Launch PHPUnit tests.
 + __scripts/set-maintenance.sh [env] [enable|disable] [uri]__ : Add or remove the maintenance flag.
 + __scripts/setup-upgrade.sh [env] [folder_name] [uri]__ : Launch the Drupal setup upgrade on the given environment.
 + __scripts/upgrade-lxc.sh [env] [uri]__ : Launch the Drupal setup upgrade on the lxc environment with composer install command before.
