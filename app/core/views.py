from flask import jsonify, render_template, request
from ..main import app


@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404


@app.route('/')
def index():
    return render_template('index.html', title='Hello World!')


@app.route('/ip')
def plain_ip():
    return request.remote_addr


@app.route('/api/ip')
def api_ip():
    return jsonify({'Success': True, 'ipAddress': request.remote_addr})
