# HomeLab
[![pipeline status](https://gitlab.arthurvardevanyan.com/ArthurVardevanyan/HomeLab/badges/production/pipeline.svg)](https://gitlab.arthurvardevanyan.com/ArthurVardevanyan/HomeLab/-/commits/production)

## Desktop

```bash
git merge --no-ff develop
git merge --no-ff production

scp -r /home/arthur/vmware windowsBackup@10.0.0.3:/backup/Virtual_Machine_Backup/vmware

7z a -t7z -m0=lzma2 -mx=9 -mfb=128 -md=256m -ms=on archive.7z FOLDER

system76-power profile performance
```

## NAS

```bash
sudo apt install cockpit cockpit-pcp
https://github.com/optimans/cockpit-zfs-manager


sudo apt-get autopurge ubuntu-advantage-tools

sudo gsettings set org.gnome.Vino require-encryption false

sudo service apache2 restart

sudo systemctl start gdm3
sudo systemctl stop  gdm3
```

### Logging

```bash
journalctl --disk-usage
sudo journalctl --rotate
sudo journalctl --vacuum-time=2days
sudo journalctl --vacuum-files=5
sudo journalctl --vacuum-time=1s && sudo journalctl --rotate --vacuum-size=5000M
sudo nano /etc/systemd/journald.conf
sudo rm /etc/systemd/journald.conf

sudo journalctl --vacuum-size=1M
sudo systemctl daemon-reload
```

### ZFS

```bash
/usr/sbin/zfs send  backup/Timeshift@20210801 | pv | ssh arthur@10.42.0.105 /usr/sbin/zfs receive -F backup/Timeshift
/usr/sbin/zfs send  backup/File_Storage@20210801 | pv | ssh arthur@10.42.0.105 /usr/sbin/zfs receive -F backup/File_Storage

/usr/sbin/zfs send -i backup/File_Storage backup/File_Storage@2021.08.01 | pv | ssh arthur@10.42.0.105 /usr/sbin/zfs receive -F backup/
File_Storage



zfs send backup/File_Storage@2021.06.14-10.22.09 | ssh arthur@10.0.0.2 zfs receive -F backup/File_Storage
zfs send backup/Timeshift@2021.06.14-10.39.17    | ssh arthur@10.0.0.2 zfs receive -F backup/Timeshift
zfs send backup/WindowsBackup@2021.06.14-12.56.48        | ssh arthur@10.0.0.2 zfs receive -F backup/WindowsBackup
zfs send backup/Virtual_Machine_Backup@2021.06.14-13.06.38        | ssh arthur@10.0.0.2 zfs receive -F backup/Virtual_Machine_Backup
```

### Docker Commands

```bash
sudo usermod -aG docker $USER

sudo rm docker-compose.yaml && sudo nano docker-compose.yaml
sudo rm docker-compose.yaml && nano docker-compose.yaml
docker system prune -a
docker image prune -a
docker kill $(docker ps -q)
docker-compose down
docker-compose pull
sudo docker-compose --compatibility up --detach  --remove-orphans
```

### SSL

```bash
sudo certbot --agree-tos -d server.arthurvardevanyan.com --manual --preferred-challenges dns certonly
cp -r /etc/letsencrypt/live/server.arthurvardevanyan.com/ /backup/Timeshift/letsencrypt/server.arthurvardevanyan.com

sudo certbot --agree-tos -d "*.arthurvardevanyan.com" --manual --preferred-challenges dns certonly
```

### Cockpit Cert

```bash
sudo su

rm /etc/cockpit/ws-certs.d/1-my-cert.cert

cat  /etc/letsencrypt/live/server.arthurvardevanyan.com/fullchain.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert
cat  /etc/letsencrypt/live/server.arthurvardevanyan.com/privkey.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert

# WildCard
cat  /etc/letsencrypt/live/arthurvardevanyan.com/fullchain.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert
cat  /etc/letsencrypt/live/arthurvardevanyan.com/privkey.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert
systemctl restart cockpit.socket
```

### GitLab

```bash
gitlab-ctl registry-garbage-collect
gitlab-ctl reconfigure

sudo certbot --agree-tos -d gitlab.arthurvardevanyan.com --manual --preferred-challenges dns certonly

rm -rf /docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com*
mkdir /home/arthur/docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com/
cat /etc/letsencrypt/live/gitlab.arthurvardevanyan.com/fullchain.pem >> /home/arthur/docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com/fullchain.pem
cat /etc/letsencrypt/live/gitlab.arthurvardevanyan.com/privkey.pem   >> /home/arthur/docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com/privkey.pem
cat /etc/letsencrypt/live/gitlab.arthurvardevanyan.com/fullchain.pem >> /home/arthur/docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com.crt
cat /etc/letsencrypt/live/gitlab.arthurvardevanyan.com/privkey.pem   >> /home/arthur/docker/gitlab/config/ssl/gitlab.arthurvardevanyan.com.key
```

### Nextcloud

```bash
sudo -u www-data php occ delete:old

sudo -u www-data php occ files:scan-app-data
sudo -u www-data php occ maintenance:repair

sudo -u www-data php occ preview:delete_old
sudo -u www-data php occ preview:generate-all

sudo rm -r ~/docker/nextcloud/letsencrypt/
sudo cp -r /etc/letsencrypt/ ~/docker/nextcloud/

# Adds SVG Support
docker exec nextcloud bash -c 'apt-get update && apt-get install -y --no-install-recommends $(apt-cache search libmagickcore-6.q[0-9][0-9]-[0-9]-extra | cut -d " " -f1)'
```

### Database

```sql
CREATE USER 'arthur'@'10.0.0.X' IDENTIFIED BY 'arthur'; 
GRANT ALL PRIVILEGES ON *.* TO `arthur`@`10.0.0.X`;

FLUSH PRIVILEGES;

% for everything

CREATE USER 'spotifyTest'@'10.42.0.%' IDENTIFIED BY 'spotifyTest'; 
GRANT ALL PRIVILEGES ON spotifyTest.* TO `spotifyTest`@`10.42.0.%`;

mysql -u root -p spotifyTest < spotifyTest.sql

GRANT SELECT, LOCK TABLES, SHOW VIEW ON *.* TO 'backup'@'10.42.0.1' IDENTIFIED BY 'backup';
```

### Analytics For Spotify

```bash
clear && cat /var/log/apache2/error.log 
clear &&  cat /home/root/analytics-for-spotify/analytics-for-spotify.log  | grep -v DEBUG 
cat test.log | grep -v DEBUG > test_noDebug.log
`
```

### Ansible

```bash
ansible-playbook -i ansible/inventory --ask-become-pass ansible/server.yaml --ask-pass
ansible-playbook -i ansible/inventory --ask-become-pass ansible/desktop.yaml --ask-pass
```

### Kubernetes

<https://k3s.io/> <https://upcloud.com/community/tutorials/deploy-kubernetes-dashboard/>

#### Helm

<https://helm.sh/docs/helm/helm_install/>
