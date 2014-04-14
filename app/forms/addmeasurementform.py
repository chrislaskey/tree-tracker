from flask_wtf import Form
from wtforms import SubmitField, TextField
from wtforms.validators import DataRequired, Optional


class AddMeasurementForm(Form):
    width = TextField('Width', validators=[DataRequired()])
    units = TextField('Units', validators=[DataRequired()])
    submit = SubmitField('Add New Tree Measurement')
