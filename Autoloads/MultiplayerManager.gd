extends Node

const PORT = 9999

signal on_player_connect(peer_id)
signal on_player_disconnect(peer_id)

func _ready() -> void:
	pass

func host_server() -> void:
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(PORT)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_connected.connect(remove_player)

func join_server(server:String = "localhost") -> void:
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(server, PORT)
	
	multiplayer.multiplayer_peer = client_peer

func add_player(peer_id:int) -> void:
	on_player_connect.emit(peer_id)

func remove_player(peer_id:int) -> void:
	on_player_disconnect.emit(peer_id)
