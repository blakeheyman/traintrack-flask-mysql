from flask import Blueprint, request, jsonify, make_response, current_app
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

# Create a new vehicle
@admins.route('/vehicle', methods=['POST'])
def create_vehicle():
    data = request.json
    current_app.logger.info(data)

    qry = f'''INSERT INTO vehicles (type, route_id, daily_start_time) VALUES
    ('{data['type']}', {data['route_id']}, '{data['daily_start_time']}')'''
    if 'commission_date' in data:
        qry = f'''INSERT INTO vehicles (type, route_id, commission_date, daily_start_time) VALUES
        ('{data['type']}', {data['route_id']}, '{data['commission_date']}', '{data['daily_start_time']}')'''

    cursor = db.get_db().cursor()
    try:
        cursor.execute(qry)
        db.get_db().commit()
        return jsonify({'message': 'Vehicle created.'}), 201
    except:
        return jsonify({'message': 'Failed to create vehicle.'}), 400

# Change a vehicle's schedule
@admins.route('/vehicle/<id>', methods=['PUT'])
def update_vehicle_schedule(id):
    data = request.json
    current_app.logger.info(data)

    qry = f'''UPDATE vehicles
    SET daily_start_time = '{data["daily_start_time"]}', route_id = {data["route_id"]}
    WHERE id = {id}'''

    cursor = db.get_db().cursor()
    try:
        cursor.execute(qry)
        db.get_db().commit()
        if cursor.rowcount == 0:
            return jsonify({'message': 'Vehicle ID not found.'}), 404

        return jsonify({'message': 'Vehicle schedule updated.'}), 200
    except:
        return jsonify({'message': 'Unable to update vehicle schedule.'}), 400

# Add an alert to a stop
@admins.route('/alerts/<stop_id>', methods=['POST'])
def add_alert(stop_id):
    data = request.json
    current_app.logger.info(data)

    qry = f'''INSERT INTO alerts (message, start_date, end_date, severity, stop_id) VALUES
    ('{data['message']}', '{data['start_date']}', '{data['end_date']}', {data['severity']}, {stop_id})'''

    cursor = db.get_db().cursor()
    try:
        cursor.execute(qry)
        db.get_db().commit()
        return jsonify({'message': 'Alert created.'}), 201
    except:
        return jsonify({'message': 'Failed to create alert.'}), 400

# Update route information
@admins.route('/routes/<route_id>', methods=['PUT'])
def update_route(route_id):
    cursor = db.get_db().cursor()
    query = '''UPDATE routes 
        SET name = \'{1}\', time_period = \'{2}\'
        WHERE id = \'{0}\'
    '''.format(route_id, request.json['name'], request.json['time_period'])
    cursor.execute(query)
    db.get_db().commit()
    if cursor.rowcount == 1:
        return jsonify({'message': 'Route updated successfully.'}), 200
    else:
        return jsonify({'message': 'Route was not updated.'}), 400