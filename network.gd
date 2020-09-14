extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 31480
const MAX_CLIENTS = 2

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(peer)
	
func join_server(ip):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func call_peer(node_path, function, data):
	rpc("receive_call", node_path, function, data)
	
remote func receive_call(node_path, function, data):
	get_tree().get_root().get_node(node_path).run_server_func(function, data)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
