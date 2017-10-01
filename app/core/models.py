import datetime
from ..main import db


class Guest(db.Model):
    """Model for guestbook API"""
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(32), unique=True)
    timestamp = db.Column(db.DateTime, default=datetime.datetime.now())
