from flask.ext.restful import Api
from .. import app
from . helloworld import HelloWorld
from . publicdata import PublicData
from . privatedata import PrivateData


api = Api(app)


api.add_resource(HelloWorld,  '/api')
api.add_resource(PrivateData, '/api/private')
api.add_resource(PublicData,  '/api/public')
