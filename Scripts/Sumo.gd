extends Node

const START = 0.4
const ARENA_SIZE = 764
const ARENA_COLORS = {Color(1, 1, 0): Color(1, 0.5, 0), Color(0, 1, 0): Color(0.5, 1, 0), Color(0, 1, 1): Color(0.25, 0.5, 1), Color(1, 0, 1): Color(0.5, 0, 1)}
const BACKGROUND_W = 3508
const BACKGROUND_H = 2480

onready var players = $"../Players"
var wintext
var o_wintext
var continu
var stats

var win = -1
var wins = [0, 0, 0, 0]
var teams = []

func _ready():
	$Inside/Shape.shape.radius = ARENA_SIZE
	$"../Camera".limit_left = -BACKGROUND_W/2
	$"../Camera".limit_right = BACKGROUND_W/2
	$"../Camera".limit_top = -BACKGROUND_H/2
	$"../Camera".limit_bottom = BACKGROUND_H/2
	
	var players = 0
	for i in range(4): if get_parent().players_joined[i] > -1:
		players += 1
		teams.append(i)
	
	var deg = 360 / players
	for i in range(players):
		var point = $StartingPositions.get_child(teams[i])
		point.position = Vector2(cos(deg2rad(i * deg)) * ARENA_SIZE * START, sin(deg2rad(i * deg)) * ARENA_SIZE * START)
		point.rotation_degrees = deg * i + 180
	
	wintext = get_parent().register_UI($WinText, self)
	continu = get_parent().register_UI($Continue, self)
	stats = get_parent().register_UI($Stats, self)
	o_wintext = wintext.text
	
	$Background.set_texture_size(BACKGROUND_W, BACKGROUND_H)

func _process(delta):
	if win == -1 and players.get_child_count() == 1:
		var player = players.get_child(0)
		player.pause = true
		win = player.team
		wins[win] += 1
		
		var text = "ZWYCIĘSTWA: \n"
		for i in range(teams.size()):
			text += "GRACZ" + str(teams[i]+1) + ": " + str(wins[teams[i]]) + "        "
		stats.text = text
		
		wintext.visible = true
		stats.visible = true
		wintext.text = o_wintext % str(player.team+1)
		wintext.modulate = Com.PLAYER_COLORS[win]
		$Arena.modulate = Com.PLAYER_COLORS[player.team]
		
		yield(get_tree().create_timer(3), "timeout")
		
		if stats.visible: continu.visible = true
		
	elif win > -1:
		if Input.is_action_just_pressed("ui_accept"):
			stats.visible = false
			wintext.visible = false
			continu.visible = false
			win = -1
			get_parent().restart_scene()
		elif Input.is_action_just_pressed("ui_cancel"):
			get_tree().change_scene_to(load("res://Scenes/MainMenu.tscn"))

func process_camera(camera, players):
	if win > -1:
		camera.position = Vector2()
		camera.zoom = Vector2(3, 3)
		return true

func _player_left(body):
	if body.is_in_group("players") and players.get_child_count() > 1:
		body.queue_free()