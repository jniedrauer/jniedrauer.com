from flask import jsonify, render_template, request
from ..main import app, db
from dictalchemy import make_class_dictable
make_class_dictable(db.Model)

from .api import get_client_ip

from .models import Guest


@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404


@app.route('/')
def index():
    guests = [r.asdict() for r in Guest.query.all()]
    return render_template('index.html', guests=guests)


@app.route('/ip')
def plain_ip():
    return get_client_ip()
