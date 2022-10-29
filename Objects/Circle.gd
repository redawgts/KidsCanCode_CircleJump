extends Area2D

enum Modes { STATIC, LIMITED }

var radius := 100
var rotation_speed := PI
var mode = Modes.STATIC
var move_range := 100
var move_speed := 1.0
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null

onready var move_tween: Tween = $MoveTween
onready var collision_shape := $CollisionShape2D
onready var sprite := $Sprite
onready var pivot := $Pivot
onready var orbit_position := $Pivot/OrbitPosition
onready var animation_player: AnimationPlayer = $AnimationPlayer


func init(_position, _radius = radius, _mode = Modes.LIMITED):
	set_mode(_mode)
	position = _position
	radius = _radius
	sprite.material = sprite.material.duplicate()
	$SpriteEffect.material = sprite.material
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = radius
	var img_size = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	set_tween()


func _process(delta: float) -> void:
	pivot.rotation += rotation_speed * delta
	if mode == Modes.LIMITED and jumper:
		check_orbits()
		update()


func _draw() -> void:
	if jumper:
		var r = ((radius - 50) / num_orbits) * (1 + num_orbits - current_orbits)
		draw_circle_arc_poly(
			Vector2.ZERO, r + 10, orbit_start + PI / 2,
			$Pivot.rotation + PI / 2,
			Settings.theme["circle_fill"]
		)


func draw_circle_arc_poly(center, _radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI / 2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * _radius)
	draw_polygon(points_arc, colors)


func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		if Settings.enable_sound:
			$Beep.play()
		$Label.text = str(current_orbits)
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation


func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		Modes.STATIC:
			$Label.hide()
			color = Settings.theme["circle_static"]
		Modes.LIMITED:
			current_orbits = num_orbits
			$Label.text = str(current_orbits)
			$Label.show()
			color = Settings.theme["circle_limited"]
	sprite.material.set_shader_param("color", color)


func implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()


func capture(target):
	jumper = target
	animation_player.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation


func set_tween(object=null, key=null):
	if move_range == 0:
		return
	move_range *= -1
	move_tween.interpolate_property(self, "position:x",
			position.x, position.x + move_range,
			move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()
