FROM swaggerapi/swagger-ui:v3.52.3

MAINTAINER LinShare <linshare@linagora.com>

ARG VERSION="6.1.0"
ARG CHANNEL="releases"

ENV LINSHARE_VERSION=$VERSION
RUN apk add wget bzip2

RUN URL="https://nexus.linagora.com/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-core&c=documentation-webservices&v=${VERSION}"; \
 wget --no-check-certificate --progress=bar:force:noscroll \
 -O linshare.tar.bz2 "${URL}&p=tar.bz2"

RUN tar -jxf linshare.tar.bz2 && mv linshare-core /swagger && rm -f linshare.tar.bz2 /swagger/*.yaml

COPY favicon-16x16.png /usr/share/nginx/html/favicon-16x16.png
COPY favicon-32x32.png /usr/share/nginx/html/favicon-32x32.png
ENV URL "./swagger.json"
RUN sed -i -e '/server_name/ i\    autoindex on;' /etc/nginx/nginx.conf
RUN sed -i -e 's;/usr/share/nginx/html/;/usr/share/nginx/linshare/;g' /etc/nginx/nginx.conf
RUN sed -i -e '/<style>/ a\      .try-out__btn { display: none;}'  /usr/share/nginx/html/index.html
COPY ./run.sh /usr/share/nginx/