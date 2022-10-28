extends Area2D

signal captured

var velocity = Vector2(100, 0)
var jump_speed = 1000
var target = null
var trail_length = 25

onready var trail := $Trail/Points


func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()


func _physics_process(delta: float):
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)

	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta


func jump():
	target.implode()
	target = null
	velocity = transform.x * jump_speed


func die():
	target = null
	queue_free()


func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)


func _on_visibility_notifier_screen_exited() -> void:
	if !target:
		die()
