import os
from flask import Flask, session, g, render_template

app = Flask(__name__)

if os.environ.get('FLASK_CONFIG'):
    app.config.from_envvar('FLASK_CONFIG')
else:
    app.config.from_object('debug_config')
