FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./app /app

ENV STATIC_INDEX 1
