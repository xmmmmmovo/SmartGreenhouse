FROM node:12.16.3
COPY ./ /app
WORKDIR /app
# RUN npm config set electron_mirror http://npm.taobao.org/mirrors/electron/
# RUN npm config set electron_custom_dir "7.3.0"
RUN npm install -g @vue/cli --registry=https://registry.npm.taobao.org
RUN npm install --registry=https://registry.npm.taobao.org && npm run build

FROM nginx
RUN mkdir /app
COPY --from=0 /app/dist /app
COPY ./config/nginx/vue-nginx.conf /etc/nginx/nginx.conf
