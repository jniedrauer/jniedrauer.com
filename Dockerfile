FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./app /app
COPY prod_config.py /app/config.py

ENV FLASK_CONFIG /app/config.py

#ENV STATIC_INDEX 1
