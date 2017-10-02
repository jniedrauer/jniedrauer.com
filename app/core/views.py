import markdown
import os
from flask import jsonify, render_template, request
from ..main import app, db
from dictalchemy import make_class_dictable
make_class_dictable(db.Model)

from .api import get_client_ip

from .models import Guest


CONTENT_PATH = os.path.join(app.static_folder, 'content')


@app.errorhandler(404)
def not_found(error):
    page_title = '404 File not Found'
    title, _ = get_content_from_files('404-title.md', '404.md')
    return render_template('404.html', page_title=page_title, title=title), 404


@app.route('/')
def index():
    title, content = get_content_from_files('index-title.md', 'index.md')
    guests = [r.asdict() for r in Guest.query.all()]
    return render_template('index.html', title=title, content=content, guests=guests)


@app.route('/bio')
def bio():
    title, content = get_content_from_files('bio-title.md', 'bio.md')
    return render_template('bio.html', title=title, content=content)


def get_content_from_files(*args):
    """Get content from the given files and return it as a tuple"""
    return (get_content_from_file(i) or '' for i in args)


def get_content_from_file(name):
    """Get content from the file with error handling"""
    path = os.path.join(CONTENT_PATH, name)

    if not os.path.isfile(path):
        app.logger.error('File not found: %s', path)
        return None

    with open(path) as f:
        return f.read().strip()


@app.route('/ip')
def plain_ip():
    return get_client_ip()
