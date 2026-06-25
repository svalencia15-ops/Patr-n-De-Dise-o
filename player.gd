extends Area2D

const SPEED = 300

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * SPEED * delta
	position.x = clamp(position.x, 40, get_viewport_rect().size.x - 40)
