extends Area2D

var speed = 200

func _ready():
	add_to_group("falling_object")

func _physics_process(delta):
	position.y += speed * delta
