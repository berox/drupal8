LXC deployment on existing project
==================================

Step 0
------

__Ensure to have Ansible 2.1__
```
$ ansible --version
```
=> ansible 2.1.x

Step 1
------

Clone your drupal project repository.

Clone your architecture project repository (if it has been separated).
 
 

Step 2
------

Go to your *project folder* and run those commands


```
$ composer install --ignore-platform-reqs
```

> IMPORTANT:
>   * When installing / updating Drupal modules or Composer libraries, you must
>     use composer inside your LXC so you don't have to use it with the
>     --ignore-platform-reqs option. So the right version is downloaded to match
>     your requirements.

```
$ composer drupal-scaffold
```

Step 3
------

Go to your *project folder* and run this command

```
$ sudo cdeploy
```
This command will create a new lxc   

Go to your *architecture folder* and run this command

```
$ bash scripts/provision.sh lxc
```
This command will provision the lxc with ansible recipe   

Step 4
------

Go to your *architecture folder* and run thoses commands

```
$ ./scripts/install.sh lxc [site_folder] [uri]
$ ./scripts/setup-upgrade.sh lxc // Not necessary.
```

If you use Smile Reconfigure module, you can also run thoses commands

```
$ ./scripts/drupal.sh lxc smilereconfigure:apply-conf -e lxc
$ ./scripts/cache-clean.sh lxc
```


Step 5
------

To test your fresh installation, go to
 
 + http://[PROJECT_NAME].lxc/                   for the front-office
 + http://[PROJECT_NAME].lxc/admin/             for the back-office (login: admin, passwd: drupaldev2)
 + http://[PROJECT_NAME].lxc:1080/              for the maildev interface
 + http://[PROJECT_NAME].lxc:9200/_plugin/head/ for the elastic search interface
 
__That's all folks__
