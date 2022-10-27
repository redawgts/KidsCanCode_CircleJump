extends Area2D

onready var collision_shape := $CollisionShape2D
onready var sprite := $Sprite
onready var pivot := $Pivot
onready var orbit_position := $Pivot/OrbitPosition

export(int) var radius := 100
export(float) var rotation_speed := PI

func _ready() -> void:
	init()

func init(_radius = radius):
	radius = _radius
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = radius
	var img_size = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1,1) * radius / img_size
	orbit_position.position.x = radius + 25

func _process(delta: float) -> void:
	pivot.rotation += rotation_speed * delta
