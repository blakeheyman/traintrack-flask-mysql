from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


commuters = Blueprint('commuters', __name__)

# Create a new commuter
@commuters.route('/commuters', methods=['POST'])
def add_commuter():
    data = request.json
    current_app.logger.info(data)

    qry = f'''INSERT INTO commuters (email, password, first_name, last_name) VALUES
     ('{data['email']}', '{data['password']}', '{data['first_name']}', '{data['last_name']}')'''

    try:
        db.get_db().cursor().execute(qry)
        db.get_db().commit()
        return jsonify({'message': 'Commuter created.'}), 201
    except:
        return jsonify({'message': 'Commuter already exists.'}), 409

# Get all of a user's favorites
@commuters.route('/<email>/favorites', methods=['GET'])
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

    if len(json_data) == 0:
        return jsonify({'message': 'No favorites found for this user.'}), 404
    return jsonify(json_data)

# Add a favorite to a user's favorites
@commuters.route('/<email>/favorites', methods=['POST'])
def add_favorite(email):
    cursor = db.get_db().cursor()
    query = '''INSERT INTO favorites (com_email, stop_id, nickname) 
        VALUES (\'{0}\', {1}, \'{2}\')
    '''.format(email, request.json['stop_id'], request.json['nickname'])
    try:
        cursor.execute(query)
        db.get_db().commit()
        return jsonify({'message': 'Favorite added successfully.'}), 201
    except:
        return jsonify({'message': 'Favorite already exists.'}), 409

# Delete a favorite from a user's favorites
@commuters.route('/<email>/favorites/<stop_id>', methods=['DELETE'])
def delete_favorite(email, stop_id):
    cursor = db.get_db().cursor()
    query = '''DELETE FROM favorites 
        WHERE STRCMP(com_email, \'{0}\') = 0 AND stop_id = {1}
    '''.format(email, stop_id)
    cursor.execute(query)
    db.get_db().commit()
    if cursor.rowcount == 1:
        return jsonify({'message': 'Favorite deleted successfully.'}), 200
    else:
        return jsonify({'message': 'Favorite does not exist.'}), 404

# Update the nickname of a favorite
@commuters.route('/<email>/favorites/<stop_id>', methods=['PUT'])
def update_favorite(email, stop_id):
    cursor = db.get_db().cursor()
    query = '''UPDATE favorites 
        SET nickname = \'{0}\' 
        WHERE STRCMP(com_email, \'{1}\') = 0 AND stop_id = {2}
    '''.format(request.json['nickname'], email, stop_id)
    cursor.execute(query)
    db.get_db().commit()
    if cursor.rowcount == 1:
        return jsonify({'message': 'Nickname updated successfully.'}), 200
    else:
        return jsonify({'message': 'Nickname was not updated.'}), 400

# Submit a report for a problem
@commuters.route('/reports', methods=['POST'])
def submit_report():
    cursor = db.get_db().cursor()
    query = '''INSERT INTO reports (message, commuter_email) 
        VALUES (\'{0}\', \'{1}\')
    '''.format(request.json['message'], request.json['email'])
    try:
        cursor.execute(query)
        db.get_db().commit()
        return jsonify({'message': 'Report submitted successfully.'}), 201
    except:
        return jsonify({'message': 'Report was not submitted.'}), 400
    

# Get the train times at a stop
@commuters.route('/stops/<stop_id>/times', methods=['GET'])
def get_times(stop_id):
    cursor = db.get_db().cursor()

    query = '''
    SELECT name, type, DATE_ADD(daily_start_time, INTERVAL time_offset MINUTE) AS trainTime
    FROM 
        (SELECT stops.route_id AS route_id, SUM(time_to_next) AS time_offset
        FROM stops 
        JOIN
            (SELECT route_id, sequence_num AS last_seq
            FROM stops 
            JOIN routes r on stops.route_id = r.id
            WHERE stops.id IN 
                (SELECT id FROM stops
                WHERE location_name = (SELECT location_name FROM stops WHERE id = {0}))) 
            AS routes_with_seq_num
        USING (route_id)
        WHERE sequence_num < last_seq
        GROUP BY last_seq) 
        AS Offsets
    JOIN
        (Select DISTINCT type, vehicles.id, daily_start_time, route_id, name
        FROM vehicles 
        JOIN
            (SELECT name, route_id, sequence_num AS last_seq
            FROM stops 
            JOIN routes r on stops.route_id = r.id
            WHERE stops.id IN 
                (SELECT id FROM stops
                WHERE location_name = (SELECT location_name FROM stops WHERE id = {0}))) 
            AS routes_with_seq
        USING (route_id))
        AS VehicleStartTimes
    ORDER BY name, type, trainTime
    '''.format(stop_id)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    for row in json_data:
        row['trainTime'] = str(row['trainTime'])
    current_app.logger.info(json_data)
    
    return jsonify(json_data), 200

# Update stop information
@commuters.route('/stops/<stop_id>', methods=['PUT'])
def update_stop(stop_id):
    data = request.json
    cursor = db.get_db().cursor()

    # Update the stop's open attribute
    if 'open' in data:
        query = '''UPDATE stops SET open = {0} WHERE id = {1}'''.format(data['open'], stop_id)
        cursor.execute(query)
        db.get_db().commit()
        if cursor.rowcount > 0:
            return jsonify({'message': 'Stop updated successfully.'}), 200
        else:
            return jsonify({'message': 'Stop was not updated.'}), 404
    else:
        return jsonify({'message': 'Body must include open'}), 422


# Return all locations
@commuters.route('/locations', methods=['GET'])
def get_locations():
    cursor = db.get_db().cursor()
    query = '''SELECT * from locations'''
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data), 200

# "Purchase" a new transit card
@commuters.route('/transitcards', methods=['POST'])
def purchase_transitcard():
    # Make sure the balance is positive
    if request.json['balance'] <= 0:
        return jsonify({'message': 'Balance must be positive.'}), 400

    cursor = db.get_db().cursor()
    query = '''INSERT INTO transit_cards (balance, email) 
        VALUES ({0}, \'{1}\')
    '''.format(request.json['balance'], request.json['email'])

    try:
        cursor.execute(query)
        db.get_db().commit()
        return jsonify({'message': 'Transit card purchased successfully.'}), 201
    except:
        return jsonify({'message': 'Invalid email.'}), 400

# Return all routes
@commuters.route('/routes', methods=['GET'])
def get_routes():
    cursor = db.get_db().cursor()
    query = 'SELECT * from routes'
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    if len(json_data) == 0:
        return jsonify({'message': 'No routes found.'}), 404    
    return jsonify(json_data), 200

# Return info for a given route
@commuters.route('/routes/<route_id>', methods=['GET'])
def get_route(route_id):
    cursor = db.get_db().cursor()
    query = 'SELECT * FROM routes WHERE routes.id = {0}'.format(route_id)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    if len(json_data) == 0:
        return jsonify({'message': 'Route does not exist.'}), 404
    return jsonify(json_data), 200

# Return stops for a given route
@commuters.route('/routes/<route_id>/stops', methods=['GET'])
def get_route_stops(route_id):
    cursor = db.get_db().cursor()
    query = '''SELECT id, time_to_next, location_name, open 
         FROM stops WHERE route_id = {0}
         ORDER BY sequence_num ASC
         '''.format(route_id)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    if len(json_data) == 0:
        return jsonify({'message': 'Route has no associated stops.'}), 404
    return jsonify(json_data), 200