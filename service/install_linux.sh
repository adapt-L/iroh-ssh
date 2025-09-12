if [ "[INITSYSTEM]" == "openrc" ]; then
	echo "# /etc/conf.d/iroh-ssh-server: config file for /etc/init.d/iroh-ssh-server
IROH_SSH_SERVER_USER=\"[BINARYOWNER]\"
IROH_SSH_SERVER_BIN=\"[BINARYPATH]\"
IROH_SSH_SERVER_PORT=\"[SSHPORT]\"
" > /etc/conf.d/iroh-ssh-server
	echo "#!/sbin/openrc-run
name=\"Iroh-SSH Server\"
description=\"SSH over Iroh\"
command_user=\"\${IROH_SSH_SERVER_USER}\"
command=\"\${IROH_SSH_SERVER_BIN}\"
command_background=1
pidfile=\"/run/\${RC_SVCNAME}.pid\"
command_args=\"server -p --ssh-port \${IROH_SSH_SERVER_PORT}\"
depend() {
	need net
	want sshd
}" > /etc/init.d/iroh-ssh-server
	chmod +x /etc/init.d/iroh-ssh-server
	rc-update add iroh-ssh-server
	rc-service iroh-ssh-server restart
else
	echo "[Unit]
Description=SSH over Iroh

[Service]
Type=simple
User=[BINARYOWNER]
WorkingDirectory=~
ExecStart=/bin/bash -c '[BINARYPATH] server -p --ssh-port [SSHPORT]'
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iroh-ssh-server.service
	systemctl is-active iroh-ssh-server.service
	if [ $? -eq 0 ]; then
		 exit 0
	else
		 systemctl enable iroh-ssh-server.service
		 systemctl start iroh-ssh-server.service
	fi
fi

