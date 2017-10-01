from flask import jsonify, request
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from dictalchemy import make_class_dictable

from ..main import app, db
make_class_dictable(db.Model)

from .models import Guest


@app.route('/api/ip')
def api_ip():
    """Return client IP"""
    return api_reply({'ipAddress': get_client_ip()})


@app.route('/api/guestbook', methods=['GET', 'POST'])
def guestbook():
    """Allow guests to view or post to the guestbook"""
    sucess = False
    reason = "You shouldn't ever see this"
    code = 200

    if request.method == 'POST':
        data = request.get_json(force=True)
        app.logger.debug('/api/guestbook recieved POST: %s', data)
        if data.get('name'):
            success, reason, code = add_guest(data['name'])
        else:
            success = False
            reason = 'RTFM'
            code = 400

        return api_reply({'acknowledged': True}, success=success, reason=reason), code
    else:
        guests = None
        try:
            guests = [r.asdict() for r in Guest.query.all()]
            success = True
            reason = None
        except SQLAlchemyError:
            success = False
            reason = 'Storage read error'
            code = 500

        return api_reply({'guests': guests}, success=success, reason=reason), code


def get_client_ip():
    """Return the client x-forwarded-for header or IP address"""
    return request.headers.get('X-Forwarded-For') or request.remote_addr


def add_guest(name):
    """Add a guest to the database"""
    guest = Guest(name=name)
    db.session.add(guest)
    try:
        db.session.commit()
        return True, None, 200
    except IntegrityError:
        return False, 'Doh! You already signed', 400
    except SQLAlchemyError:
        return False, 'Storage engine error', 500


def api_reply(body={}, success=True, reason=None):
    """Create a standard API reply interface"""
    return jsonify({**body, 'success': success, 'reason': reason})
