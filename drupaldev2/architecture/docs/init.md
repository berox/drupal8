Initialise your project
=======================

Step 0
------

__Ensure to have Ansible 2.1__
```
$ ansible --version
```
=> ansible 2.1.x

Step 1
------

Go to your favorite working directory and run the following commands  

```
$ bash <(curl -sL https://git.smile.fr/drupal/drupal8-architecture-skeleton/raw/master/init.sh)
```

This command will __instantiate the project__ basis through Composer into :

 + a folder called `myproject` for drupal with a subfolder `architecture` (if you have not separate the architecture)
 + a folder called `myproject_drupal` for drupal, and a folder called `myproject_architecture` for the architecture (if you have separate the architecture)

__A prompt will ask you__:

 + The project name. It needs to be a lowercase alphanum (`[a-z0-9]`) and 16 char max
 + Classic Project: If you want the sample data  (Y or N) [NOT IMPLEMENTED YET]
 + Classic Project: If you want to create a separate project for the architecture  (Y or N)
 + If you want to install the Smile modules (Y or N)
 + The default smile user (current user by default) to authorise for delivery. Ex: lamin
 
Then you will have to confirm your choices.

Because it's a convention based installation, by default everything depends on your project name: vhost, mysql user, mysql password, mysql database, ...

If you need more flexibility, you need to edit the right files in `{architecture}/provisioning/inventory/group_vars/` and customise vars according to your need.

If you choose to set a custom delivery user (e.g. smile) you must edit the Ansible configuration file __provisioning/inventory/group_vars/all__ and add all users that need to ssh on the servers :

```
delivery_authorized_smile_users:
  - mabes
```

See the [Ansible parameter list](docs/parameters.md).

Step 2.1 - Classical Project
----------------------------

__Initiate your git project__, by following this procedure:

 + Go on https://git.smile.fr/groups/new and create a new git group with the name of your project (example: xxxxx)
 + Go on https://git.smile.fr/projects/new and create a project named **drupal** in your new git group (i.e. Project owner)
 + You can go on your git project with the following url https://git.smile.fr/xxxxx/drupal
 + go on your drupal project folder and execute the following commands:
 
```
git init
git remote add origin git@git.smile.fr:xxxxx/drupal.git
git add .
git commit -m "init the drupal project"
git push -u origin master
```

Step 2.2 - Separate Architecture
--------------------------------

If you have separate the drupal project and the architecture project, you need also to follow this procedure:

 + Go on https://git.smile.fr/projects/new and create a project named **architecture** in your new git group (i.e. Project owner)
 + You can go on your git project with the following url https://git.smile.fr/xxxxx/architecture
 + go on your architecture project folder and execute the following commands:
 
```
git init
git remote add origin git@git.smile.fr:xxxxx/architecture.git
git add .
git commit -m "init the architecture project"
git push -u origin master
```


Step 3
------

When all the sources are downloaded, you need to go to your *project folder* and run this command

```
$ sudo cdeploy
```
This command will create a new lxc   

Then, you need to go to the *architecture folder*, and run this command

```
$ ./scripts/provision.sh lxc
```
This command will provision the lxc with Ansible recipe   


Step 4
------

Now you can install Drupal database using the following command in the *architecture folder*

```
# ./scripts/install.sh lxc [site_folder] [uri]

$ ./scripts/install.sh lxc default mysite.lxc
```

This could take time to init the database

Note:

 + `install.sh` script should be only use to initialize your local virtual machine (lxc), for other servers, use `deploy.sh`
 + `default` must be the same as the value contained in `{project folder}/src/sites/sites.php` : `$site[URI_OF_YOUR_PROJECT]`

Step 5
------

You can now change some project basic configurations :
 + In ./{drupal}/composer.json :
     + name ([group_name]/[project_name])
     + description


 + In ./{architecture}/provisioning/inventory/group_vars/all
     + delivery_authorized_smile_users: add the smile users that will be allowed to deliver
     + deploy_release_path: need to follow this structure __../../{drupal}/build/dist/[git_group_name]-[git_project_name]-{{ deploy_version }}.tar.gz__
       WARNING: for this path, it must be adapted if the architecture is separated from the drupal sources.


 + In ./{drupal}/.spbuilder.yml
     + package.vcs.url: Provide your git URL


+ In ./{drupal}/JenkinsFile
     + update the [drupal_git_url], [git group name] and [git project name].

You can also change these files :

 + ./README.md

__Commit all the sources__

Step 6
------

To test your fresh installation, go to

 + http://[PROJECT_NAME].lxc/                   for the front-office
 + http://[PROJECT_NAME].lxc/user/login         for the back-office (login: admin, passwd: drupaldev2)
 + http://[PROJECT_NAME].lxc:1080/              for the maildev interface
 + http://[PROJECT_NAME].lxc:9200/_plugin/head/ for the elastic search interface

__Taste the sweet flavor of the so trendy Drupal 8 new project factory__ :+1:
