from flask.ext.restful import Resource
from . decorators import api_login_required


class PrivateData(Resource):

    @api_login_required
    def get(self):
        return {'private': 'data'}
