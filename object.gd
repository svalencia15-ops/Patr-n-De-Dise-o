extends Area2D

var speed = 200

func _physics_process(delta):
	position.y += speed * delta
