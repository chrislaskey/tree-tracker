from flask_wtf import Form
from wtforms import SelectField, SubmitField, TextField
from wtforms.validators import AnyOf, DataRequired, Optional
from . customfields import TagItField


class AddTreeForm(Form):
    longitude = TextField('Longitude', validators=[DataRequired()])
    latitude = TextField('Latitude', validators=[DataRequired()])
    address = TextField('Address')
    common_name = TextField('Common Name', validators=[DataRequired()])
    submit = SubmitField('Add New Tree')
