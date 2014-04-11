from wtforms import Field
from wtforms.widgets import TextInput


class TagItField(Field):
    '''
    Allows multiple fields with the same name attribute:
        <input name="repeated"/><input name="repeated"/>

    Returns a list with each value in it.
    If no values are present it returns an empty list.
    '''
    widget = TextInput()

    def process_formdata(self, valuelist):
        if valuelist:
            self.data = valuelist
        else:
            self.data = []
