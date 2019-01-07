Prepare your package for delivery
=================================

You can build a delivery archive using spbuilder.
Spbuilder will:

 + Get the sources from your vcs repository
 + Launch the composer install
 + Remove the useless files and folders
 + Create the archive
 
Launch the following command from the *drupal folder*:
```
$ bin/spbuilder package
```

By default, it uses your current branch.

You can specify a specific branch with the `--force-branch` option.

You can specify a specific tag with the `--force-tag` option.
 
*See https://git.smile.fr/dirtech/spbuilder for more information.*

Then, you can use the deploy script to deliver this package on a specific environment.
 
The deploy script also integrate a optional package building step of the requested version
before trying to deliver, if you want to do packaging and deploying in a single step.

