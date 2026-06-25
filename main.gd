extends Node2D

const FallingObject = preload("res://scenes/object.tscn")

var score = 0
var lives = 3

func _ready():
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	var obj = FallingObject.instantiate()
	obj.position.x = randf_range(50, get_viewport_rect().size.x - 50)
	obj.position.y = -30
	obj.area_entered.connect(_on_object_caught.bind(obj))
	obj.tree_exiting.connect(_on_object_missed.bind(obj))
	add_child(obj)

func _on_object_caught(area, obj):
	if area == $Player:
		obj.queue_free()
		score += 1
		$HUD/ScoreLabel.text = "Score: %d" % score

func _on_object_missed(obj):
	if obj.position.y > get_viewport_rect().size.y:
		lives -= 1
		$HUD/LivesLabel.text = "Lives: %d" % lives
		if lives <= 0:
			_game_over()

func _game_over():
	$SpawnTimer.stop()
	get_tree().paused = true
	$HUD/MessageLabel.text = "GAME OVER\nScore: %d\nPress Enter to restart" % score
	$HUD/MessageLabel.show()

func _input(event):
	if event.is_action_pressed("ui_accept") and get_tree().paused:
		get_tree().paused = false
		get_tree().reload_current_scene()
