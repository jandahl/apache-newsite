#!/usr/bin/env bash

if [[ $(id -un) != "root" ]]; then
  echo -e "\n\tMust be root to run this script. Use\n\t\tsudo `basename $0`\n"
  exit 1
fi

function aboutMe {
  echo -e "Basic Apache Site Enabler v. 2012-12-06"
	echo -e "Create a standard config for \033[1;31mFQDN\033[0m, where FQDN is the domain name of the site you want"
	echo -e "Note, if you want to use subdomains (e.g. 'www') you must either explicitly create this or make a ServerAlias line"
	echo -e "Also sets the resulting dirs and files to belong to www-data:www-data with 775 rights."
	echo -e "\nUsage:"
	echo -e "\n\t\tsudo `basename $0` \033[1;31mFQDN\033[0m\n\n"
	echo -e "\n\n\t\t[033[1;31mWarning! This script does not (yet) sanitise input!\n"
	exit 0
}

createSite() {
	fqdn=$1

	mkdir -p /var/www/$fqdn/public_html
	cp /var/www/index.html /var/www/$fqdn/public_html/
	cp /etc/apache2/sites-available/default /etc/apache2/sites-available/$fqdn

	chown www-data:www-data /var/www/$fqdn/public_html/ /etc/apache2/sites-available/$fqdn
	chmod 755 /var/www/$fqdn/public_html/ /etc/apache2/sites-available/$fqdn

	## sudo -e /etc/apache2/sites-available/$fqdn
	## should replace above line with an in-place replacement sed line

	/usr/sbin/a2ensite $fqdn
	/usr/sbin/service apache2 reload

}

if [ $# -ne 1 ]; then
	aboutMe
else
	createSite $1
fi
