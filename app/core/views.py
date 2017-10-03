import markdown
import os
from flask import jsonify, render_template, request, url_for
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
    page_title = 'Index'
    title, content = get_content_from_files('index-title.md', 'index.md')
    guests = [r.asdict() for r in Guest.query.all()]
    return render_template(
        'index.html', page_title=page_title, title=title, content=content, guests=guests
    )


@app.route('/bio')
def bio():
    page_title = 'Bio'
    title, content = get_content_from_files('bio-title.md', 'bio.md')
    return render_template('bio.html', page_title=page_title, title=title, content=content)


@app.route('/tech')
def tech():
    page_title = 'Tech'
    title = get_content_from_files('tech-title.md')[0]
    content = 'tech.html'
    stacks = {
        'Amazon ECS': 'content/ecs.html',
        'Ansible': 'content/ansible.html',
        'Docker': 'content/docker.html',
        'Flask': 'content/flask.html',
        'Haproxy': 'content/haproxy.html',
        'LetsEncrypt': 'content/le.html',
        'Python3': 'content/python.html',
        'SQLAlchemy': 'content/sql.html',
        'SQLite': 'content/sqlite.html',
        'Terraform': 'content/tf.html',
        'acme.sh': 'content/acme.html'
    }
    return render_template(
        'page.html', page_title=page_title, title=title, html_content=content, stacks=stacks
    )


@app.route('/api-docs')
def api_docs():
    page_title = 'API'
    title, content = get_content_from_files('api-docs-title.md', 'api-docs.md')
    return render_template('page.html', page_title=page_title, title=title, md_content=content)


def get_content_from_files(*args):
    """Get content from the given files and return it as a tuple"""
    return [get_content_from_file(i) or '' for i in args]


def get_content_from_file(name):
    """Get content from the file with error handling"""
    path = get_static(name)

    if not os.path.isfile(path):
        app.logger.error('File not found: %s', path)
        return None

    with open(path) as f:
        return f.read().strip()


def get_static(name):
    """Get the path for static file"""
    return os.path.join(CONTENT_PATH, name)


@app.route('/ip')
def plain_ip():
    return get_client_ip()
