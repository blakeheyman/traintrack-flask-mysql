from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


commuters = Blueprint('commuters', __name__)

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

    # Query to all the stops at this stop's location
    query = '''
    SELECT name, DATE_ADD(daily_start_time, INTERVAL time_offset MINUTE) AS trainTime
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
        (Select DISTINCT vehicles.id, daily_start_time, route_id, name
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
    ORDER BY name, trainTime
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