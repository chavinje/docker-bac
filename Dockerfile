FROM alpine:3.18
# De grande modifications entre apache2 sur 3.5 et 3.10 (en tache de fond)
MAINTAINER jerome CHAVIN <jerome.chavin@eseo.fr>

RUN apk update && apk upgrade && \
    apk add apache2 libxml2-dev apache2-utils && \
    apk add php82 php82-apache2 php82-mbstring php82-curl \
    php82-mysqli php82-bcmath php82-gd php82-gettext php82-xml php82-xmlreader \
	php82-bz2 php82-curl && \
    mkdir /web/ && chown -R apache.www-data /web && \
    # Modification du fichier de configuration a partir de chercher/remplacer
    # d'après le github https://github.com/nimmis/docker-alpine-apache/blob/master/Dockerfile
    # Prise en compte du DocumentRoot dans /web
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/web"#g' /etc/apache2/httpd.conf && \
#    sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf && \
#    sed -i 's#^ServerRoot .*#ServerRoot /web#g'  /etc/apache2/httpd.conf && \
#    sed -i 's/^#ServerName.*/ServerName webproxy/' /etc/apache2/httpd.conf && \
#    sed -i 's#^IncludeOptional /etc/apache2/conf#IncludeOptional /web/config/conf#g' /etc/apache2/httpd.conf && \
#    sed -i 's#PidFile "/run/.*#Pidfile "/web/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
    # ==> Droit d'afficher le contenu du repertoire /web
    sed -i 's#Directory "/var/www/localhost/htdocs.*#Directory "/web/" >#g' /etc/apache2/httpd.conf && \
#    sed -i 's#Directory "/var/www/localhost/cgi-bin.*#Directory "/web/cgi-bin" >#g' /etc/apache2/httpd.conf && \
#    sed -i 's#/var/log/apache2/#/web/logs/#g' /etc/logrotate.d/apache2 && \
#    sed -i 's/Options Indexes/Options /g' /etc/apache2/httpd.conf && \
    rm -rf /var/cache/apk/*

# Work path
WORKDIR /web

# Copy of demonstration index.html 
COPY web/index.html index.html

VOLUME /web

EXPOSE 80 443

CMD ["/usr/sbin/httpd","-D", "FOREGROUND"]
#ENTRYPOINT ["/bin/sh"]
