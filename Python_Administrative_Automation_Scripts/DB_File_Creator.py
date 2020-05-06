"""
This script will upload the extracted company emails csv file into a sql lite database file
"""
import csv
import os
import sqlite3


# Local method to create database file saved in specified path
def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by db_file
    :param db_file: database file
    :return: Connection object or None
    """
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Exception as e:
        print(e)

    return None


# Local method to create database file saved in memory
def create_memory_connection():
    """ create a database connection to a database that resides
        in the memory
    """
    try:
        conn = sqlite3.connect(':memory:')
        print(sqlite3.version)
    except Exception as e:
        print(e)
    finally:
        conn.close()


def create_table(conn, create_table_sql):
    """ create a table from the create_table_sql statement
    :param conn: Connection object
    :param create_table_sql: a CREATE TABLE statement
    :return:
    """
    try:
        c = conn.cursor()
        c.execute(create_table_sql)
    except Exception as e:
        print(e)


def main():
    database = r'C:\Python\Data Science Stuff\Tutorial Scripts\emails.db'  # path and name to db file that will be made
    os.chdir(r'C:\Data Science Stuff\Tutorial Scripts')  # change directory to where 1 csv file is for upload
    # reference: https://sqlite.org/datatype3.html

    # SQL code for making a table specific to format of a csv file (columns and data types)
    sql_create_emails_table = """ CREATE TABLE IF NOT EXISTS emails (
                                        Sent_On TEXT,
                                        Sender_Name TEXT NOT NULL,
                                        CC_Recipients TEXT,
                                        Subject TEXT,
                                        Body TEXT
                                    ); """

    sql_create_tasks_table = """CREATE TABLE IF NOT EXISTS tasks (
                                    id INTEGER PRIMARY KEY,
                                    name TEXT NOT NULL,
                                    priority INTEGER,
                                    status_id INTEGER NOT NULL,
                                    project_id INTEGER NOT NULL,
                                    begin_date TEXT NOT NULL,
                                    end_date TEXT NOT NULL,
                                    FOREIGN KEY (project_id) REFERENCES emails (id)
                                );"""

    # create a database connection
    conn = create_connection(database)
    if conn is not None:
        # create EMAILS table
        create_table(conn, sql_create_emails_table)

        # import csv to EMAILS table connection
        cur = conn.cursor()
        with open('lesa_emails_to_convert.csv', 'r') as fin:

            # csv.DictReader uses first line in file for column headings by default
            dr = csv.DictReader(fin)  # comma is default delimiter
            to_db = [(i['Sent On'], i['Sender Name'], i['CC Recipients'], i['Subject'], i['Body']) for i in dr]

        cur.executemany("INSERT INTO emails (Sent_On, Sender_Name, CC_Recipients, Subject, Body) VALUES (?, ?, ?, ?, ?);", to_db)
        conn.commit()
        conn.close()

    else:
        print("Error! Could not connect or create the database file.")


if __name__ == '__main__':
    main()
