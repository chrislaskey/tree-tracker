#!/usr/lib/virtualenvs/geolocate/bin/python

# Create database
# Load all app.models.* first, hooking them into db. Then call db.create_all().

from datetime import datetime
from app.models import db
from app.models.friends import Friend
from app.models.trees import Tree
from app.models.users import User
from app.security import user_datastore
from sys import argv


try:
    command = argv[1]
except IndexError:
    command = None


db.create_all()


if command == 'test':

    user_datastore.create_user(
        email='player-one@chrislaskey.com',
        screen_name='Chris',
        # password: player-one
        password='$2a$12$96vs6hmhJzBgi1fw4b6vIu87VuzMP2lFIcoIxTJ1U6h9m.AjuNDdO'
    )

    user_datastore.create_user(
        email='player-two@chrislaskey.com',
        screen_name='Gitte',
        # password: player-two
        password='$2a$12$obgmmSNEhciOEbg.Ob1tAuFyopqA4/JsTt/V3OoD.QGkckp0Qc0FW'
    )

    user_datastore.create_user(
        email='player-three@chrislaskey.com',
        screen_name='player-three',
        # password: player-three
        password='$2a$12$bSeMt/jhBiltPTxHHPzcHO/q.vaeN57l25RyFp4eDnow9jegOfEo6'
    )

    db.session.commit()

    db.session.add_all([
        Friend(user_id=1, friend_id=2),
        Friend(user_id=2, friend_id=1),
        Friend(user_id=1, friend_id=3)
    ])

    db.session.add_all([
        Tree(
            latitude     = '42.348483',
            longitude    = '-71.098190',
            address      = '',
            common_name  = 'White Oak',
            user_id      = 2,
            date_created = datetime.utcnow(),
        ),
        Tree(
            latitude     = '42.348427',
            longitude    = '-71.098444',
            address      = '',
            common_name  = 'Norwegian Maple',
            user_id      = 1,
            date_created = datetime.utcnow(),
        ),
        Tree(
            latitude     = '42.349031',
            longitude    = '-71.096286',
            address      = '',
            common_name  = 'Norwegian Maple',
            user_id      = 2,
            date_created = datetime.utcnow(),
        )
    ])

    db.session.commit()
