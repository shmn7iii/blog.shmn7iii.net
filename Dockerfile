FROM node:18.18.2 AS build

WORKDIR /app
COPY . .
RUN --mount=type=secret,id=notion_api_secret \
    --mount=type=secret,id=database_id \
    export NOTION_API_SECRET=$(cat /run/secrets/notion_api_secret) && \
    export DATABASE_ID=$(cat /run/secrets/database_id) && \
    npm install && \
    npm run build

FROM httpd:2.4 AS runtime
COPY --from=build /app/dist /usr/local/apache2/htdocs/
EXPOSE 80
