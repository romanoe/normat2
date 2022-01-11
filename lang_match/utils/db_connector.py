from contextlib import contextmanager
import psycopg2

@contextmanager
def connect_database(serv):
    """
Connect to a database using a postgres service defined in pg_service.conf. The PGSYSCONFDIR should be defined.
    :param serv: String
        The name of the service to use.
    :return: psycopg Connection class
        A connection object to be used with SQL queries.
    """
    # Check if PGSYSCONFDIR is defined. If yes connect to database.

    con = psycopg2.connect(service=serv)
    try:
        yield con
    except psycopg2.OperationalError:
        raise "Could not connect to the database using the provided service."
    finally:
        con.close()
        print('Deconnecting')


