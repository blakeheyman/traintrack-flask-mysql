from flask import Blueprint, request, jsonify, make_response
import json
from src import db


commuters = Blueprint('commuters', __name__)

# Get all of a user's favorites
@commuters.route('/commuters/<email>/favorites')
def get_favorites(email):
    cursor = db.get_db().cursor()
    query = '''SELECT favorites.nickname, stops.id, stops.location_name, routes.name 
        FROM favorites JOIN commuters ON favorites.com_email = commuters.email 
        JOIN stops ON favorites.stop_id = stops.id 
        JOIN routes ON stops.route_id = routes.id 
        WHERE STRCMP(commuters.email, \'{0}\') = 0
    '''.format(email)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

# # Get all the commuters from the database
# @products.route('/products', methods=['GET'])
# def get_products():
#     # get a cursor object from the database
#     cursor = db.get_db().cursor()

#     # use cursor to query the database for a list of products
#     cursor.execute('SELECT id, product_code, product_name, list_price FROM products')

#     # grab the column headers from the returned data
#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))

#     return jsonify(json_data)

# # get the top 5 products from the database
# @products.route('/mostExpensive')
# def get_most_pop_products():
#     cursor = db.get_db().cursor()
#     query = '''
#         SELECT product_code, product_name, list_price, reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 5
#     '''
#     cursor.execute(query)
#        # grab the column headers from the returned data
#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))

#     return jsonify(json_data)