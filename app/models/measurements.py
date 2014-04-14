from . import db


class Measurement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    width = db.Column(db.Text())
    units = db.Column(db.Text())
    date_created = db.Column(db.DateTime())

    tree_id = db.Column(db.Integer, db.ForeignKey('tree.id'))
    tree = db.relationship('Tree',
        backref=db.backref('measurements', lazy='dynamic'))

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    user = db.relationship('User',
        backref=db.backref('measurements', lazy='dynamic'))
