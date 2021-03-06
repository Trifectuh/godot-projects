extends Node2D

var player1
var player2

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	player1 = preload('res://mover/mover.tscn').instance()
	player1.position = $SpawnPoints/Spawn.position
	
	add_child(player1)
		
func _player_connected(_id):
	player2 = preload('res://mover/mover.tscn').instance()
	player2.position = $SpawnPoints/Spawn2.position
	
	
	if get_tree().has_network_peer() and get_tree().is_network_server():
		player2.set_network_master(get_tree().get_network_connected_peers()[0])
		add_child(player2)
	elif get_tree().has_network_peer():
		player2.set_network_master(get_tree().get_network_unique_id())
		add_child(player2)
	
	print("my unique id: ", get_tree().get_network_unique_id())
		
func _player_disconnected(_id):
	player2.queue_free()
	
func _server_disconnected(_id):
	player1.queue_free()
