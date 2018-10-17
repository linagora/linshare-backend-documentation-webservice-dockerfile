from httpd:2.4

MAINTAINER LinShare <linshare@linagora.com>

ARG VERSION="2.2.0-1"
ARG CHANNEL=releases
ARG EXT="com"

ENV LINSHARE_VERSION=$VERSION

RUN apt-get update && apt-get install wget bzip2 -y && apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/local/apache2/htdocs/index.html

RUN URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-core&c=documentation-ws-api-delegation&v=${VERSION}"; \
 wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2 "${URL}&p=tar.bz2" \
 && wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2.sha1 "${URL}&p=tar.bz2.sha1" \
 && sed -i 's#^\(.*\)#\1\tlinshare.tar.bz2#' linshare.tar.bz2.sha1 \
 && sha1sum -c linshare.tar.bz2.sha1 --quiet && rm -f linshare.tar.bz2.sha1

RUN tar -jxf linshare.tar.bz2 -C /usr/local/apache2/htdocs && \
chown -R www-data /usr/local/apache2/htdocs/linshare-core && \
mv -v /usr/local/apache2/htdocs/linshare-core /usr/local/apache2/htdocs/documentation-ws-api-delegation && \
rm -f linshare.tar.bz2


RUN URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-core&c=documentation-ws-api-userv1&v=${VERSION}"; \
 wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2 "${URL}&p=tar.bz2" \
 && wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2.sha1 "${URL}&p=tar.bz2.sha1" \
 && sed -i 's#^\(.*\)#\1\tlinshare.tar.bz2#' linshare.tar.bz2.sha1 \
 && sha1sum -c linshare.tar.bz2.sha1 --quiet && rm -f linshare.tar.bz2.sha1

RUN tar -jxf linshare.tar.bz2 -C /usr/local/apache2/htdocs && \
chown -R www-data /usr/local/apache2/htdocs/linshare-core && \
mv -v /usr/local/apache2/htdocs/linshare-core /usr/local/apache2/htdocs/documentation-ws-api-userv1 && \
rm -f linshare.tar.bz2


RUN URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-core&c=documentation-ws-api-userv2&v=${VERSION}"; \
 wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2 "${URL}&p=tar.bz2" \
 && wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2.sha1 "${URL}&p=tar.bz2.sha1" \
 && sed -i 's#^\(.*\)#\1\tlinshare.tar.bz2#' linshare.tar.bz2.sha1 \
 && sha1sum -c linshare.tar.bz2.sha1 --quiet && rm -f linshare.tar.bz2.sha1

RUN tar -jxf linshare.tar.bz2 -C /usr/local/apache2/htdocs && \
chown -R www-data /usr/local/apache2/htdocs/linshare-core && \
mv -v /usr/local/apache2/htdocs/linshare-core /usr/local/apache2/htdocs/documentation-ws-api-userv2 && \
rm -f linshare.tar.bz2

COPY ./httpd.extra.conf /usr/local/apache2/conf/extra/httpd.extra.conf
RUN cat /usr/local/apache2/conf/extra/httpd.extra.conf >> /usr/local/apache2/conf/httpd.conf

COPY ./linshare-documentation.conf /usr/local/apache2/conf/extra/linshare-documentation.conf

EXPOSE 80
