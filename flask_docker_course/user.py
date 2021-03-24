class User():
    def __init__(self, id, username, age):
        self._id = id
        self._username = username
        self._age = age

    def as_dict(self):
        return {
            'id': self._id,
            'username': self._username,
            'age': self._age
        }
