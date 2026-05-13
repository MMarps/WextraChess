FROM postgres:16-alpine

COPY ./tools/ /docker-entrypoint-initdb.d/

RUN chmod -R 755 /docker-entrypoint-initdb.d