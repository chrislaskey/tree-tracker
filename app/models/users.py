from flask.ext.security import UserMixin
from . import db
from . trees import trees_users
from . roles import roles_users


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.Text(), unique=True)
    screen_name = db.Column(db.Text(), unique=True)
    first_name = db.Column(db.Text())
    last_name = db.Column(db.Text())
    password = db.Column(db.String(255))
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime())
    last_login_at = db.Column(db.DateTime())
    current_login_at = db.Column(db.DateTime())
    last_login_ip = db.Column(db.String(255))
    current_login_ip = db.Column(db.String(255))
    login_count = db.Column(db.Integer)
    roles = db.relationship('Role', secondary = roles_users,
        backref = db.backref('users', lazy = 'dynamic'))
    trees = db.relationship('Tree', secondary = trees_users,
        backref = db.backref('users', lazy = 'dynamic'))
    friends = db.relationship('Friend', backref='Friend.friend_id',
        primaryjoin='User.id==Friend.user_id', lazy='joined')
