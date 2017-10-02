import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_misaka import Misaka


# app configuration
app = Flask(__name__, static_url_path='')

if os.environ.get('FLASK_CONFIG'):
    app.config.from_envvar('FLASK_CONFIG')
else:
    app.config.from_object('debug_config')

# instantiate the database
db = SQLAlchemy(app)
from .core.models import Guest
db.create_all()

# Add markdown hooks
Misaka(app)

from .core import views, api
