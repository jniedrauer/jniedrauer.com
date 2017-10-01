from flask import jsonify, request
from ..main import app


@app.route('/api/ip')
def api_ip():
    return jsonify({'Success': True, 'ipAddress': get_client_ip()})


def get_client_ip():
    return request.headers.get('X-Forwarded-For') or request.remote_addr
