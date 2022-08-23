useradd -u 13001 YouTrack
usermod -a -G YouTrack $USER
mkdir ./Data ./Logs ./Conf ./Backups
chmod 750 ./Data ./Logs ./Conf ./Backups
chown YouTrack:YouTrack ./Data ./Logs ./Conf ./Backups