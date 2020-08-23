FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

FROM nginx

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 8081

ENTRYPOINT ["nginx", "-g", "daemon off;"]

