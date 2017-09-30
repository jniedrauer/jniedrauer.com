FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./app /app
COPY app.conf /etc/jniedrauer/app.conf

ENV FLASK_CONFIG /etc/jniedrauer/app.conf

#ENV STATIC_INDEX 1
