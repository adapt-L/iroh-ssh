if [ "[INITSYSTEM]" == "openrc" ]; then
	rc-service iroh-ssh-server stop
	rc-update del iroh-ssh-server
	rm /etc/init.d/iroh-ssh-server
	rm /etc/conf.d/iroh-ssh-server
else
	systemctl stop iroh-ssh-server.service
	systemctl disable iroh-ssh-server.service
	rm /etc/systemd/system/iroh-ssh-server.service
	systemctl daemon-reload
fi
