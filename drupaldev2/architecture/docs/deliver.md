Deliver the sources
===================

Step 0
------

__Ensure to have Ansible 2.1__
```
$ ansible --version
```
=> ansible 2.1.x

__Modify the integration/staging/preprod/prod parameters__
 
Specify the correct hostname and all the specific configuration of your integration/staging/preprod/prod environment:

 + ./{architecture}/provisioning/inventory/[inte,staging,preprod,prod]
 + ./{architecture}/provisioning/inventory/group_vars/[inte,staging,preprod,prod]

Step 1
------

First, you can provision your integration/staging/preprod/prod environment with the same provisioning script as for the LXC
to initialise the environment or deploy new configurations (from the *architecture folder*)
```
$ ./scripts/provision.sh [inte,staging,preprod,prod]
```

**Important:**
+ Add your public key on server: ssh-copy-id -i /home/[pintagram]/.ssh/id_dsa.pub root@[server-name]
+ If you are on an environment with separate servers for Redis, Mysql, and Elastic Search, after the first provisioning,
+ you must ask to the Hosting to update the **IP** the alias **myfrontX**, **mydb**, **myredis**, ... in the **/etc/hosts** file of each servers.

Step 2
------

Then, we will deliver the archive (see [Packaging documentation](./packaging.md)) using Ansible (from the *architecture folder*).
```
$ ./scripts/deploy.sh [inte,staging,preprod,prod] [-p packageVersion or -b VCSbranch or -t VCStag] [-f]
```

> If the script doesn't find the requested package it will try to generate it with `bin/spbuilder package -n --force-version="master-20160307120000"`

You must use the **[-f]** parameter if it is the first deploy.

Ansible will:

 + Copy the archive on the remote environment
 + Create the releases/shared/current folder structure
 + Unarchive in the releases folder
 + Add the Symlinks to the shared folders
 + Deploy the configuration files (settings.php, services.yml)
 + Add the maintenance flag if needed
 + Launch the drupal database upgrade if needed
 + Import features
 + Import translations
 + Remove the maintenance flag if needed
 + Modify the symlink "current"
 
> **Note**: The deploy.yml ansible script take 3 extra vars :
>  * first_deployment [Y/N]

Step 2.1
--------

__On the first deployment and if you have a NFS__, move the multi-front shared folders and files from the shared directory and create symlinks:

 + src/sites/default/settings.php
 + src/sites/default/services.php
 + src/sites/default/files
 
Step 2.2
--------

__On the first deployment__, you can also install Drupal database and cron using the installation script (from the *architecture folder*).

```
$ ./scripts/install.sh [inte,staging,preprod,prod] [site_folder] [uri]
```

Step 3
------

**Not implemented for now.**

__On the first deployment and if the drupal_mode is production__, you need to generate static and di files (from the *architecture folder*)

```
$ ./scripts/generate-static-di.sh [inte,staging,preprod,prod]
```
