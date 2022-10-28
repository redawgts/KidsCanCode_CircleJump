extends Node


var Circle = preload("res://objects/circle.tscn")
var Jumper = preload("res://objects/jumper.tscn")

var player

func _ready() -> void:
	randomize()
	new_game()

func new_game():
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_jumper_captured")
	spawn_circle($StartPosition.position)

func spawn_circle(_position = null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)

func _on_jumper_captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
