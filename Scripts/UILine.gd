tool
extends Sprite

export(NodePath) var start setget set_start
export(NodePath) var end setget set_end

var start_start
var end_start

func _ready():
	if !Engine.editor_hint:
		start_start = get_node(start).position
		end_start = get_node(end).position
		update_start_end()

func _process(delta):
	if !Engine.editor_hint:
		get_node(start).position += Vector2(-1 + randf()*2, -1 + randf()*2) * 0.1
		get_node(end).position += Vector2(-1 + randf()*2, -1 + randf()*2) * 0.1
		update_start_end()

func set_start(_start):
	start = _start
	update_start_end()

func set_end(_end):
	end = _end
	update_start_end()

func update_start_end():
	if has_node(start) and has_node(end):
		var _start = get_node(start)
		var _end = get_node(end)
		var dir = (_end.position - _start.position).normalized()
		
		var start_pos = _start.position + dir * (_start.texture.get_width()/2-12 if _start.get("texture") else 0)
		var end_pos = _end.position - dir * (_end.texture.get_width()/2-12 if _end.get("texture") else 0)
		
		rotation = dir.angle()
		position = (start_pos + end_pos)/2
		region_rect.size.x = (start_pos - end_pos).length()