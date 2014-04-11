from . import db


class Friend(db.Model):
    request_status = db.Column(db.String(255))
    user_id = db.Column(db.Integer(), db.ForeignKey('user.id'),
        primary_key=True, index=True)
    friend_id = db.Column(db.Integer(), db.ForeignKey('user.id'),
        primary_key=True, index=True)

    user = db.relationship('User', foreign_keys='Friend.user_id')
    friend = db.relationship('User', foreign_keys='Friend.friend_id')
