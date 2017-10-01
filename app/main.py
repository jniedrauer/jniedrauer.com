import os
from flask import Flask

app = Flask(__name__, static_url_path='')

if os.environ.get('FLASK_CONFIG'):
    app.config.from_envvar('FLASK_CONFIG')
else:
    app.config.from_object('debug_config')

from .core import views, api
