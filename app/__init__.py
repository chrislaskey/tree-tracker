from flask import Flask


app = Flask(__name__)
app.config.from_object('app.config')


from . import api
from . import mail
from . import models
from . import security
from . import views
