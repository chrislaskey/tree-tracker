from flask import flash, redirect, render_template
from flask.ext.security import current_user
from .. import app
from .. models import db
from .. models.trees import Tree


@app.route('/tree/<int:tree_id>', methods=('GET', 'POST'))
def tree(tree_id):
    tree = get_tree(tree_id)
    if not tree:
        flash('Could not find the requested tree', 'error')
        return redirect('/')
    return render_template(
        'tree.html',
        current_user = current_user,
        tree = get_tree(tree_id)
    )


def get_tree(tree_id):
    return db.session.query(Tree)\
        .filter_by(id=tree_id)\
        .limit(1)\
        .first()
