from datetime import datetime
from flask import redirect, render_template
from flask.ext.security import current_user
from .. import app
from .. models import db
from .. models.db_helpers import db_add
from .. models.trees import Tree
from .. forms.addtreeform import AddTreeForm


@app.route('/add-tree', methods=('GET', 'POST'))
def add_tree():
    form = AddTreeForm()
    if form.validate_on_submit():
        if not current_user.is_authenticated():
            return app.login_manager.unauthorized()
        save_add_tree(form)
        return redirect('/')
    return render_template(
        'add-tree/with-gps.html',
        current_user = current_user,
        add_tree_form = form
    )


def save_add_tree(form):
    new_tree = Tree(
        longitude    = form.longitude.data,
        latitude     = form.latitude.data,
        address      = form.address.data,
        common_name  = form.common_name.data,
        date_created = datetime.utcnow(),
        user_id      = current_user.id,
    )
    db_add(
        new_tree,
        u'New tree successfully added.',
        u'An error occured when trying to add a new tree.'
    )
