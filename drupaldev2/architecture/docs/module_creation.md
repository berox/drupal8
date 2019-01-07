Creating Drupal 8 module for Smile
===================================

_@TODO updates this file to suits D8 arch_

Step 1
------

Develop and test your module on the Drupal 8 Dev Projet

1. request access to https://git.smile.fr/drupal8/dev-modules repository
2. clone the repository
3. install using the [drupal 8 skeleton repository instructions for existing project](lxc.md)
4. add your module sources into `app/code/Smile`.
5. create a module in `app/code/Example` that will use your module and serve as integration exemple 
6. access the dev Drupal 8 <http://d8modules.lxc> and test your module

Step 2
------

Create the repo for your module.

1. request DT for a repository creation under the Drupal 8 group <https://git.smile.fr/groups/drupal8>
2. create this file hierarchy in your repo :
    * .gitignore
    * CHANGELOG.md
    * composer.json
    * CONTRIBUTING.md
    * LICENSE.md
    * README.md
3. put your module sources directly in this folder 
4. update the doc files by looking into another repo to respect the content organisation ex: <https://git.smile.fr/drupal8/module-setup/tree/master>


Step 3
------

Once your module as been validated by the DT.
Submit a contribution on capi : <https://capi.smile.fr/PHP/Drupal8>

Step 4
------

To add your module to the Smile packagist
1. add your repo to this file <https://git.smile.fr/dirtech/satis/blob/smile/sources/drupal8.json>
2. ask for a MR
