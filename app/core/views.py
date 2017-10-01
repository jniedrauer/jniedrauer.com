from flask import jsonify, render_template, request
from ..main import app
from .api import get_client_ip


@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404


@app.route('/')
def index():
    return render_template('index.html', title='Hello World!')


@app.route('/ip')
def plain_ip():
    return get_client_ip()
