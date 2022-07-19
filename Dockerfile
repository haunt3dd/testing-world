FROM node:16.14.0-buster as build

WORKDIR /code

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm ci --production

COPY . /code/

RUN npm run build

# Nginx Web Server
FROM nginx:1.21-alpine

COPY --from=build /code/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/default.conf /etc/nginx/conf.d
COPY nginx/nginx.conf  /etc/nginx
COPY nginx/mime.types /etc/nginx
# RUN mv /etc/nginx/conf.d/nginx.conf /etc/nginx/conf.d/default.conf

# Fireup Nginx
EXPOSE 80
CMD ["nginx","-g","daemon off;"]