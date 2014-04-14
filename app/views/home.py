from flask import render_template
from flask.ext.security import login_required, current_user
from .. import app
from .. models import db
from .. models.trees import Tree
from .. models.users import User


@app.route('/')
@login_required
def index():
    return render_template(
        'home.html',
        current_user = current_user,
        is_first_login = is_first_login(),
        trees = get_trees()
    )


def get_trees():
    return db.session.query(Tree).all()


def is_first_login():
    return current_user.last_login_at == current_user.current_login_at
