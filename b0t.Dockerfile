FROM node:21-alpine AS build

ARG PUB_SRV_NAME=draw.mydomain.com
ARG PUB_SRV_NAME_WS=ws.draw.mydomain.com
ARG VITE_APP_BACKEND_V2_GET_URL=https://draw.mydomain.com/api/v2/scenes/
ARG VITE_APP_BACKEND_V2_POST_URL=https://draw.mydomain.com/api/v2/scenes/
ARG VITE_APP_WS_SERVER_URL=https://ws.draw.mydomain.com/

ENV PUB_SRV_NAME=${PUB_SRV_NAME}
ENV PUB_SRV_NAME_WS=${PUB_SRV_NAME_WS}
ENV VITE_APP_BACKEND_V2_GET_URL=${VITE_APP_BACKEND_V2_GET_URL}
ENV VITE_APP_BACKEND_V2_POST_URL=${VITE_APP_BACKEND_V2_POST_URL}
ENV VITE_APP_WS_SERVER_URL=${VITE_APP_WS_SERVER_URL}

WORKDIR /opt/node_app

COPY package.json yarn.lock ./
RUN yarn --ignore-optional --network-timeout 600000

#COPY --from=download /opt/node_app/excalidraw/ .
RUN yarn build:app:docker

FROM nginx:1.25.4-alpine

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1