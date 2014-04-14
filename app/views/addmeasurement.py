from datetime import datetime
from flask import redirect, render_template
from flask.ext.security import current_user
from .. import app
from .. models import db
from .. models.db_helpers import db_add
from .. models.measurements import Measurement
from .. forms.addmeasurementform import AddMeasurementForm


@app.route('/tree/<int:tree_id>/add-measurement', methods=('GET', 'POST'))
def add_measurement(tree_id):
    form = AddMeasurementForm()
    if form.validate_on_submit():
        if not current_user.is_authenticated():
            return app.login_manager.unauthorized()
        save_add_measurement(form, tree_id)
        url = '/tree/{0}'.format(tree_id)
        return redirect(url)
    return render_template(
        'add-measurement.html',
        current_user = current_user,
        tree_id = tree_id,
        add_measurement_form = form
    )


def save_add_measurement(form, tree_id):
    new_measurement = Measurement(
        width        = form.width.data,
        units        = form.units.data,
        date_created = datetime.utcnow(),
        tree_id      = tree_id,
        user_id      = current_user.id,
    )
    db_add(
        new_measurement,
        u'New tree measurement successfully added.',
        u'An error occured when trying to add a new tree measurement.'
    )
