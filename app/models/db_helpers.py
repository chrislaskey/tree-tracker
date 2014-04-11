from flask import flash
from sqlalchemy.exc import SQLAlchemyError
from . import db
from .. import app


def db_add( item,
            success=u'Successfully added',
            error=u'Error adding to database',
            error_log=u'Error adding item to database'):
    try:
        db.session.add(item)
        db.session.commit()
        flash(success, 'success')
    except SQLAlchemyError as e:
        flash(error, 'error')
        app.logger.error(error_log, extra=e)
