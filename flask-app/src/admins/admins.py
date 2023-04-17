from flask import Blueprint, request, jsonify, make_response
import json
from src import db


admins = Blueprint('admins', __name__)

# Delete a stop as an admin
@admins.route('/stops/<stop_id>', methods=['DELETE'])
def delete_stop(stop_id):
    cursor = db.get_db().cursor()
    query = '''DELETE FROM stops WHERE id = {0}
    '''.format(stop_id)
    cursor.execute(query)
    db.get_db().commit()
    if cursor.rowcount == 1:
        return jsonify({'message': 'Stop deleted successfully.'}), 200
    else:
        return jsonify({'message': 'Stop does not exist.'}), 404

# View all reports
@admins.route('/reports', methods=['GET'])
def get_reports():
    cursor = db.get_db().cursor()
    # Order by date to show most recent first
    query = '''SELECT * FROM reports ORDER BY timestamp DESC'''
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    if len(json_data) == 0:
        return jsonify({'message': 'No reports found.'}), 404
    return jsonify(json_data)

# Create a new location
@admins.route('/locations', methods=['POST'])
def add_location():
    cursor = db.get_db().cursor()
    query = '''INSERT INTO locations (name, latitude, longitude, handicap_accessible) 
        VALUES (\'{0}\', {1}, {2}, {3})
    '''.format(request.json['name'], request.json['latitude'], request.json['longitude'], request.json['handicap_accessible'])
    try:
        cursor.execute(query)
        db.get_db().commit()
        return jsonify({'message': 'Location added successfully.'}), 201
    except:
        return jsonify({'message': 'Location already exists.'}), 409

# # Get all admins from the DB
# @customers.route('/customers', methods=['GET'])
# def get_customers():
#     cursor = db.get_db().cursor()
#     cursor.execute('select company, last_name,\
#         first_name, job_title, business_phone from customers')
#     row_headers = [x[0] for x in cursor.description]
#     json_data = []
#     theData = cursor.fetchall()
#     for row in theData:
#         json_data.append(dict(zip(row_headers, row)))
#     the_response = make_response(jsonify(json_data))
#     the_response.status_code = 200
#     the_response.mimetype = 'application/json'
#     return the_response

# # Get customer detail for customer with particular userID
# @customers.route('/customers/<userID>', methods=['GET'])
# def get_customer(userID):
#     cursor = db.get_db().cursor()
#     cursor.execute('select * from customers where id = {0}'.format(userID))
#     row_headers = [x[0] for x in cursor.description]
#     json_data = []
#     theData = cursor.fetchall()
#     for row in theData:
#         json_data.append(dict(zip(row_headers, row)))
#     the_response = make_response(jsonify(json_data))
#     the_response.status_code = 200
#     the_response.mimetype = 'application/json'
#     return the_response