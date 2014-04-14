from . import db


class Tree(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    longitude = db.Column(db.Text())
    latitude = db.Column(db.Text())
    address = db.Column(db.Text())
    common_name = db.Column(db.Text())
    description = db.Column(db.Text())
    date_created = db.Column(db.DateTime())

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    user = db.relationship('User',
        backref=db.backref('trees', lazy='dynamic'))
