from flask.ext.restful import Resource


class PublicData(Resource):

    def get(self):
        return {'public': 'data'}
