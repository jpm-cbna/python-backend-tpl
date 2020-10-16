# Python libraries

# External libraries
from flask.logging import default_handler
from flask_migrate import Migrate
from flask_cors import CORS

# This project files
from shared import logging
from api import create_api, db
from api.descriptions.resources import resources as descriptions_ressources
from api.versions.resources import resources as versions_ressources

# Import all models for Migrate
from api.descriptions.entities import Description


# TODO: use flask config.
#config = config.get()

# Initialize logging
logging.setup()

# Creating the Flask application
api = create_api()

# Database migration
migrate = Migrate(api, db)

# TODO: configure allowed url for CORS with config file parameters.
CORS(api)

# Register blueprints
api.register_blueprint(descriptions_ressources)
api.register_blueprint(versions_ressources)
