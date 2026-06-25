extends Area2D

var speed = 200

func _ready():
	add_to_group("falling_object")
	print("OBJECT_READY: speed variable = %d" % speed)

func _physics_process(delta):
	position.y += speed * delta
