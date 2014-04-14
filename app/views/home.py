from flask import render_template
from flask.ext.security import login_required, current_user
from .. import app
from .. models import db
from .. models.trees import Tree
from .. models.measurements import Measurement
from .. models.users import User


@app.route('/')
@login_required
def index():
    return render_template(
        'home.html',
        current_user = current_user,
        is_first_login = is_first_login(),
        trees = get_trees(),
        recent_trees = get_recent_trees(),
        recent_measurements = get_recent_measurements(),
    )


def get_trees():
    return db.session.query(Tree).all()


def get_recent_trees():
    return db.session.query(Tree)\
        .order_by(Tree.date_created.desc())\
        .limit(5)\
        .all()

def get_recent_measurements():
    return db.session.query(Measurement)\
        .order_by(Measurement.date_created.desc())\
        .limit(5)\
        .all()

def is_first_login():
    return current_user.last_login_at == current_user.current_login_at
