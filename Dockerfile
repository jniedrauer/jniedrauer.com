FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./app /app/main
RUN ln -s /app/main/static /app/static
RUN mkdir -p /var/lib/sqlite

COPY requirements.txt /app/requirements.txt
RUN pip install -Ur requirements.txt

COPY prod_config.conf /etc/jniedrauer/flask.conf

ENV FLASK_CONFIG /etc/jniedrauer/flask.conf

#ENV STATIC_INDEX 1
