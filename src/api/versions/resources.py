from flask import Blueprint, jsonify

# Versions infos
from flask import __version__ as flask_version
from marshmallow import __version__ as marshmallow_version
from sqlalchemy import __version__ as sqlalchemy_version
from sys import version as sys_version

resources = Blueprint('versions', __name__)

@resources.route('/versions', methods=['GET'])
def get_versions():
    data = [
        {
            'name': 'Flask',
            'version': flask_version,
            'logoUrl': 'https://flask.palletsprojects.com/en/1.1.x/_images/flask-logo.png',
        },
        {
            'name': 'Marshmallow',
            'version': marshmallow_version,
            'logoUrl': 'https://marshmallow.readthedocs.io/en/stable/_static/marshmallow-logo.png',
        },
        {
            'name': 'Python',
            'version': sys_version,
            'logoUrl': 'https://www.python.org/static/community_logos/python-powered-h-140x182.png',
        },
        {
            'name': 'Sqlalchemy',
            'version': sqlalchemy_version,
            'logoUrl': 'https://www.sqlalchemy.org/img/sqla_logo.png',
        },
    ]
    return jsonify(data)
