from flask.ext.security import ConfirmRegisterForm
from wtforms import TextField
from wtforms.validators import DataRequired


class ExtendedConfirmRegisterForm(ConfirmRegisterForm):
    screen_name = TextField(
        'Screen Name',
        [DataRequired('Screen name not provided')]
    )
