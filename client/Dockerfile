FROM node:alpine3.12 as build-stage

WORKDIR /app

COPY package*.json ./

#RUN npm install

#RUN npm run build

COPY . .

FROM nginx:1.19.1-alpine as production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]