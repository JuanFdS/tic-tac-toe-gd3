extends Node
# Our WebSocketClient instance
var _client = WebSocketClient.new()
var connected = false
var created_room
var room_code

func room_code():
	return room_code

func create_client(user_created_room):
	_client = WebSocketClient.new()
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url("ws://tateti-websocket-server.herokuapp.com")
	if err != OK:
		print("Unable to connect")
		set_process(false)
	created_room = user_created_room

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	connected = false

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	connected = true
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	if(created_room):
		send({"accion": "create"})
	else:
		send({"accion": "join", "codigo": room_code})

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var mensaje = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result

	if(!mensaje.has("error")):
		if(mensaje["accion"] == "create" || mensaje["accion"] == "join"):
			room_code = mensaje["codigo"]
			get_tree().change_scene("res://Main.tscn")
		if(mensaje["accion"] == "actualizarTablero"):
			print(mensaje)
			get_tree().get_root().get_node('Main').actualizarTablero(mensaje["tablero"], mensaje["jugadorActual"])

func send(message):
	message["codigo"] = room_code
	if(connected):
		_client.get_peer(1).put_packet(JSON.print(message).to_utf8())

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func join(codigo):
	room_code = codigo
	create_client(false)
	

func crear():
	create_client(true)
