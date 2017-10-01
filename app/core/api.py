from flask import jsonify, request
from ..main import app


@app.route('/api/ip')
def api_ip():
    """Return client IP"""
    return api_reply({'ipAddress': get_client_ip()})


def get_client_ip():
    """Return the client x-forwarded-for header or IP address"""
    return request.headers.get('X-Forwarded-For') or request.remote_addr


def api_reply(body={}, success=True):
    """Create a standard API reply interface"""
    return jsonify({**body, 'success': success})
