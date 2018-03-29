extends Node2D

var texture = load("res://Sprites/Common/Electrofield.png")

func _ready():
	pass

func _process(delta):
	update()

func _draw():
	var width = 300
	var height = 300
	var w = texture.get_width()
	var h = texture.get_height()
	draw_rect(Rect2(0, 0, width, height), Color(1, 1, 1))
	
	for x in range(width/w + 1):
		var rw = w - min(x * w, width) % w
		draw_texture_rect_region(texture, Rect2(x * w, 0, rw, 64), Rect2(0, 0, rw, 64))