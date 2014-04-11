from flask.ext.restful import Resource


class HelloWorld(Resource):

    def get(self):
        return {'hello': 'world'}
