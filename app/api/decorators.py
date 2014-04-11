from functools import wraps
from flask import abort
from flask.ext.login import current_user


def api_login_required(func):
    '''
    Modified version of the Flask-Login @login_required decorator.
    Instead of redirecting returns an API appropriate error message.
    '''
    @wraps(func)
    def decorated(*args, **kwargs):
        if not current_user.is_authenticated():
            abort(403)
        return func(*args, **kwargs)
    return decorated
