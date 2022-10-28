extends Area2D

export(int) var radius := 100
export(float) var rotation_speed := PI

onready var collision_shape := $CollisionShape2D
onready var sprite := $Sprite
onready var pivot := $Pivot
onready var orbit_position := $Pivot/OrbitPosition
onready var animation_player: AnimationPlayer = $AnimationPlayer


func init(_position, _radius = radius):
	position = _position
	radius = _radius
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = radius
	var img_size = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1,1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)

func _process(delta: float) -> void:
	pivot.rotation += rotation_speed * delta

func implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()

func capture():
	animation_player.play("capture")
	yield(animation_player, "animation_finished")
