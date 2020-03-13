#! /bin/sh

set -e

NGINX_ROOT=/usr/share/nginx/html/
NGINX_ROOT_LS=/usr/share/nginx/linshare
INDEX_FILE=$NGINX_ROOT/index.html

mkdir -p ${NGINX_ROOT_LS}
cp -v ${NGINX_ROOT}/favicon-16x16.png ${NGINX_ROOT_LS}/favicon-16x16.png
cp -v ${NGINX_ROOT}/favicon-32x32.png ${NGINX_ROOT_LS}/favicon-32x32.png
cp -v ${NGINX_ROOT}/favicon-32x32.png ${NGINX_ROOT_LS}/favicon.ico

node /usr/share/nginx/configurator $INDEX_FILE

sed -i "s|https://petstore.swagger.io/v2/swagger.json|swagger.json|g" $INDEX_FILE

for l_file in $(ls /swagger)
do
    l_dir=${NGINX_ROOT_LS}/$(echo $l_file| sed -e 's/.json$//')
    cp -r $NGINX_ROOT ${l_dir}/
    cp -v /swagger/${l_file} ${l_dir}/swagger.json
    l_title=$(grep title ${l_dir}/swagger.json | cut -d '"' -f 4)
    sed -i -e "s/Swagger UI/LinShare ${l_title}/g" ${l_dir}/index.html
    # find ${l_dir} -type f -regex ".*\.\(html\|js\|css\)" -exec sh -c "gzip < {} > {}.gz" \;
done
exec nginx -g 'daemon off;'
