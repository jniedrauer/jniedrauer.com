FROM tiangolo/uwsgi-nginx-flask:python3.6

ENV FLASK_CONFIG /etc/jniedrauer/flask.conf

COPY prod_config.conf /etc/jniedrauer/flask.conf

COPY requirements.txt /app/requirements.txt
RUN pip install -Ur requirements.txt

COPY ./app /app/main

RUN ln -s /app/main/static /app/static
RUN mkdir -p /var/lib/sqlite
