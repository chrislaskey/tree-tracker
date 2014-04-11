from flask.ext.security import Security, SQLAlchemyUserDatastore
from .. import app
from .. models.roles import db, Role
from .. models.users import User
from . register import ExtendedConfirmRegisterForm


user_datastore = SQLAlchemyUserDatastore(db, User, Role)

security = Security(
    app,
    user_datastore,
    confirm_register_form = ExtendedConfirmRegisterForm
)
