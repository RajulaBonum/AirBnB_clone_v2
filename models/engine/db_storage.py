#!/usr/bin/python3
"""This will be the database engine"""
from models.base_model import BaseModel, Base
from models.user import User
from models.state import State
from models.city import City
from models.amenity import Amenity
from models.place import Place
from models.review import Review
from os import getenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session


all_classes = {"State", "City", "Amenity", "User", "Place", "Review"}


class DBStorage:
    """Private class attributes"""

    __engine = None
    __session = None

    """Public instance methods"""
    def __init__(self):
        """Initialize a connection with MySQL and create tables"""
        db_uri = "{0}+{1}://{2}:{3}@{4}:3306/{5}".format(
            'mysql', 'mysqldb', getenv('HBNB_MYSQL_USER'),
            getenv('HBNB_MYSQL_PWD'), getenv('HBNB_MYSQL_HOST'),
            getenv('HBNB_MYSQL_DB'))

        self.__engine = create_engine(db_uri, pool_pre_ping=True)
        self.reload()

        if getenv('HBNB_ENV') == 'test':
            Base.metadata.drop_all(self.__engine)

    def all(self, cls=None):
        """query on the current database session (self.__session)
        all objects depending of the class name (argument cls)"""
        entities = dict()

        if cls:
            return self.get_data_from_table(cls, entities)

        for entity in all_classes:
            entities = self.get_data_from_table(eval(entity), entities)

        return entities

    def new(self, obj):
        """Add the object to the current
        database session (self.__session)"""

        if obj:
            self.__session.add(obj)

    def save(self):
        """Commit all changes of the current
        database session (self.__session)"""

        self.__session.commit()

    def delete(self, obj=None):
        """Delete from the current database session obj if not None"""

        if obj is not None:
            self.__session.delete(obj)

    def reload(self):
        """Create all tables in the database (feature of SQLAlchemy)
        (WARNING: all classes who inherit from Base must be imported
        before calling Base.metadata.create_all(engine))"""

        Base.metadata.create_all(self.__engine)
        session_factory = sessionmaker(
                bind=self.__engine, expire_on_commit=False)
        Session = scoped_session(session_factory)
        self.__session = Session()

    def get_data_from_table(self, cls, structure):
        """Get the data from a MySQL Table
        """

        if type(structure) is dict:
            query = self.__session.query(cls)

            for _row in query.all():
                key = "{}.{}".format(cls.__name__, _row.id)
                structure[key] = _row

            return structure

    def close(self):
        """Close the Session
        call the remove()
        """
        self.__session.remove()
