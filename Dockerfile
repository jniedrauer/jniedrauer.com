FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./app /app/main
RUN ln -s /app/main/static /app/static

COPY prod_config.conf /etc/jniedrauer/flask.conf

ENV FLASK_CONFIG /etc/jniedrauer/flask.conf

#ENV STATIC_INDEX 1
