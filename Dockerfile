FROM alpine/git as clone
WORKDIR /app
RUN git clone -b master https://github.com/vote-of-confidence/ui-root.git

FROM node:lts-alpine as build-stage
WORKDIR /app
COPY --from=clone /app/ui-root/package*.json ./
RUN npm install
COPY --from=clone /app/ui-root/. .
RUN npm run build


FROM nginx as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /app
EXPOSE 8080
