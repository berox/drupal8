# Prerequisites on the host machine

The following lines concernes **your** computer. it does not concern the *serveur* or the *lxc*.

**DO NOT INSTALL** anything on the *server* or on the *lxc*.

You must have a workstation under [SmileBuntu](https://wiki.smile.fr/view/Systeme.ConfigPostes/ConfigUbuntu),
or at least install all the [Smile Packages](https://wiki.smile.fr/view/Adminsys/UbuntuSmilebuntu)
(like [smile-ca](https://wiki.smile.fr/view/Systeme/ConfigPostes/SmileSSLCertificates#How_to_install_in_Linux) package).

If you have the latest SmileBuntu, you have to install the following PHP extensions or packages in order to make it works:

+ php-curl
+ php-mbstring
+ php-xml
+ php-zip
+ python-ldap

With the following command:

```
sudo apt-get install php-curl php-mbstring php-xml php-zip python-ldap
```

## For Hosting and Developers

The following lines are necessary for provisioning process. They concern Hosting and Developers.

+ LDAP:     You must install the **python-ldap** package
+ LDAP:     You must [upload your SSH key to the LDAP ](https://wiki.smile.fr/view/Systeme/UsingSmileLDAP#Upload_your_SSH_key_to_the_LDAP)
+ GIT:      You must install the **git** packages
+ GIT:      You must have your ssh key linked with your [git account](https://git.smile.fr/profile/keys)
+ Ansible:  You must [install and configure](https://wiki.smile.fr/view/Systeme/AnsibleIntro) Ansible 2.1

## Only For Developers 

The following lines are necessary to develop on the Drupal project. They concern only Developers.

+ LXC:      You must [install and configure](https://wiki.smile.fr/view/Dirtech/LxcForDevs) the lxc management tools 
+ Composer: You must [install](https://getcomposer.org/doc/00-intro.md#globally) Composer in the last stable version
+ Composer: You must [configure](https://wiki.smile.fr/view/PHP/HowToConfigComposer) Composer

```
{
    "github-oauth": {
        "github.com": "[Your Github key]"
    }
}
```

To build files generated with Gulp, you must install the following packages on the host machine:
+ npm
+ node
+ gulp

To do that, you need to download node on the official website (LTS version is better). :
https://nodejs.org/en/download/

Extract the content on local folder /home/[pintagram]/[path-to-node]/
After the extraction, rename the main folder to "node".

With the console go into the folder /home/[pintagram]/[path-to-node]/node/bin
and run the following lines (thinks to update the "[path-to-node]" and "[pintagram]" path):
+ sudo ln -sf /home/[pintagram]/[path-to-node]/node/bin/node /usr/bin/node
+ sudo ln -sf /home/[pintagram]/[path-to-node]/node/bin/npm /usr/bin/npm

Last step, the gulp installation :
+ npm install -g gulp
+ sudo ln -sf /home/[pintagram]/[path-to-node]/node/bin/gulp /usr/bin/gulp

That's all, you are ready to gulp some files now.

Either installed using distribution packages or manually.

You can also add the following lines (not mandatory). 

+ Composer: Install [Prestissimo plugin](https://github.com/hirak/prestissimo#prestissimo-composer-plugin) to speed up composer install command
