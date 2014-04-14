from flask_wtf import Form
from wtforms import SubmitField, TextField
from wtforms.validators import DataRequired, Optional


class AddTreeForm(Form):
    longitude = TextField('Longitude', validators=[DataRequired()])
    latitude = TextField('Latitude', validators=[DataRequired()])
    address = TextField('Address', validators=[Optional()])
    common_name = TextField('Common Name', validators=[DataRequired()])
    submit = SubmitField('Add New Tree')
