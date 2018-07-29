# OS: Ubuntu 18.04 LTS

## Prerequisites
# download debug-crash.qcow.xz
# download debug-crash.xml
# this script will install the bare minimum stuff to debug the problem

[ ! -f debug-crash.qcow.xz -o ! -f debug-crash.xml ] && echo "please download the files: debug-crash.qcow.xz debug-crash.xml" && exit 1

case $1 in
	install)
		sudo apt-get -y install libvirt-clients libvirt-daemon-system
		mkdir -p images
		cp debug-crash.qcow.xz debug-crash.xml images
		cd images
		unxz debug-crash.qcow.xz
		sed -i "s/\/var\/lib\/uvtool\/libvirt\/images/${PWD//\//\\/}/g" debug-crash.xml
		;;
	start)
		[ -d images ] && cd images && virsh create debug-crash.xml
		;;
	console)
		[ -d images ] && cd images && echo "'Ctrl' + 'Alt Gr' + ']' (it keyboard) to exit" && virsh console debug-crash
		;;
	stop)
		[ -d images ] && cd images && virsh shutdown debug-crash
		;;
	uninstall)
		if [ -d images ]; then
			cd images
			virsh shutdown debug-crash
			cd -
			rm -rf images
		fi

		sudo apt-get -y remove libvirt-clients libvirt-daemon-system
		sudo apt-get -y autoremove
		sudo apt-get -y autoclean
		;;
	apache2)
cat << EOF
1) journalctl > out.txt
2) vim out.txt and search for apache2 to find the errors
3) add the ServerName "192.168.122.15" line by modifying /etc/apache2/apache2.conf to fix the following error:
   debug-crash apachectl[2165]: AH00558: apache2: Could not reliably determine the server's fully qualified
   domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
4) commented out the line include the extra.conf file that is a link to /dev/urandom to fix the error:
   debug-crash apachectl[2439]: [Wed Jun 20 06:37:38.566851 2018] [[core:error] [pid 2441:tid 140266548263872]
   AH00554: Access to file /etc/apache2/extra.conf denied by server: not a regular file
5) sudo systemctl start apache2
6) sudo systemctl status apache2 to verify if there is any further error
7) open a browser on the url http://192.168.122.15 to verify that everything is working fine
EOF
		;;
	crash)
echo << EOF
1) post conf command generates a segfault calling it with no root permissions 
EOF
		;;
	*)
		;;
esac
