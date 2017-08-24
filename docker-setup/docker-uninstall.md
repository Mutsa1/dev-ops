## Docker uninstallation steps ##

Official docker page https://docs.docker.com/engine/installation/linux/ubuntulinux/#uninstallation

```bash
sudo apt-get purge -y docker-engine

sudo apt-get autoremove -y --purge docker-engine

sudo apt-get autoclean
```

The above commands will not remove images, containers, volumes, or user created configuration files on your host. If you wish to delete all images, containers, and volumes run the following command:

```bash
sudo rm -rf /var/lib/docker
```

Remove docker from apparmor.d:

```bash
sudo rm /etc/apparmor.d/docker
```

Remove docker group:

```bash
sudo groupdel docker
```
Now, You have successfully deleted docker.
