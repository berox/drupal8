Grunt for theme development
===========================

Installation
------------

_@TODO Change doc link and update to suits D8 needs_

[Official Doc](http://devdocs.drupal.com/guides/v2.0/frontend-dev-guide/css-topics/css_debug.html#grunt_prereq)

On LXC env, NPM and Grunt-CLI are already installed (Ansible parameter drupal_install_grunt).

You have just to do the following commands:

```
$ ssh root@XXXXXX.lxc
$ cd /var/www/XXXXXX/
$ npm install
$ npm update
$ exit
* ./scripts/permissions.sh lxc
```

And then:

* add your theme to the Grunt configuration in the `dev/tools/grunt/configs/themes.js` file.
* copy the file `Gruntfile.js.sample` to `Gruntfile.js` (without any modification)
* copy the file `package.json.sample` to `package.json` (without any modification)
* launch `npm install` (on the lxc, on the project folder)
* launch `grunt` to test (on the lxc, on the project folder)
* commit the 3 files you have created

Usage
------

To use grunt while developing a theme you need to put frontend workflow on server side mode in Configuration > Developper > Frontend workflow.
Then follow those three steps :
* build static files : `./scripts/drupal.sh lxc setup:static-content:deploy`
* update permission : `./scripts/permissions.sh lxc`
* run exec grunt task : `./scripts/grunt.sh lxc exec:YOURTHEMENAME`
* run less grunt task : `./scripts/grunt.sh lxc less:YOURTHEMENAME`
* run watch grunt task : `./scripts/grunt.sh lxc watch:YOURTHEMENAME`
