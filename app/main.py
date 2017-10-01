import os
from flask import Flask, session, g, render_template

app = Flask(__name__)

if os.environ.get('FLASK_CONFIG'):
    app.config.from_envvar('FLASK_CONFIG')
else:
    app.config.from_object('debug_config')

if app.config.get('STATIC_PATH'):
    app.static_folder = os.path.join(app.root_path, app.config['STATIC_PATH'])

from .core import views
