FROM nginx:alpine
#RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN mkdir -p /etc/nginx/ssl \
    && apk add --no-cache openssl \
    && openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096
COPY nginx.conf /etc/nginx/nginx.conf
