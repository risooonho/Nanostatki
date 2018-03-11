extends Node

onready var camera = $Camera
onready var players = $Players.get_children()

#const DZOOM = 0.1

#var zoom = 1

func _ready():
	pass

func _physics_process(delta):
	var cam_pos = Vector2()
	var min_y = 10000
	var min_x = 10000
	var max_y = -10000
	var max_x = -10000
	
	for player in players:
		min_y = min(player.position.y, min_y)
		min_x = min(player.position.x, min_x)
		max_y = max(player.position.y, max_y)
		max_x = max(player.position.x, max_x)
		cam_pos += player.position
	
	camera.position = cam_pos / players.size()
	
	var new_zoom = max(min(max(abs(min_x - max_x) / 600, abs(min_y - max_y) / 300), 4), 1)
#	if abs(new_zoom - zoom) > DZOOM: zoom += sign(new_zoom - zoom) * DZOOM
	camera.zoom = Vector2(new_zoom, new_zoom)