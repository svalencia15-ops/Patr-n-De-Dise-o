extends Node2D

const FallingObject = preload("res://scenes/object.tscn")

# Variables de juego
var score = 0
var lives = 3
var speed_multiplier = 1.0
var last_speed_increase = 0

# Sistema observador
var observers = []

func _ready():
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start()
	
	# Registrar observadores
	register_observer(self)

# Patrón observador: registrar observadores
func register_observer(observer):
	if observer not in observers:
		observers.append(observer)

# Patrón observador: notificar a los observadores
func notify_observers(event_type: String, data: Dictionary):
	for observer in observers:
		observer.on_game_event(event_type, data)

# Método requerido por el patrón observador
func on_game_event(event_type: String, data: Dictionary):
	match event_type:
		"lives_changed":
			_on_lives_changed(data)
		"score_changed":
			_on_score_changed(data)
		"speed_changed":
			_on_speed_changed(data)

func _on_spawn_timer_timeout():
	var obj = FallingObject.instantiate()
	obj.position.x = randf_range(50, get_viewport_rect().size.x - 50)
	obj.position.y = -30
	
	# Aplicar multiplicador de velocidad ANTES de añadir al árbol
	obj.speed = 200 * speed_multiplier
	
	obj.area_entered.connect(_on_object_caught.bind(obj))
	add_child(obj)

func _process(_delta):
	# Verificar objetos que pasaron la pantalla
	for child in get_children():
		if child.is_in_group("falling_object"):
			if child.position.y > get_viewport_rect().size.y:
				_on_object_missed(child)
				child.queue_free()

func _on_object_caught(area, obj):
	if area == $Player:
		obj.queue_free()
		score += 1
		
		# Aumentar velocidad cada 20 puntos
		if score % 20 == 0 and score > last_speed_increase:
			speed_multiplier *= 1.05  # Aumentar 5%
			last_speed_increase = score
			print("Velocidad aumentada: %.2f%% - Multiplicador: %.2f" % [5.0, speed_multiplier])
			# Notificar evento
			notify_observers("speed_changed", {"multiplier": speed_multiplier, "score": score})
		
		# Notificar cambio de puntuación
		notify_observers("score_changed", {"score": score})
		$HUD/ScoreLabel.text = "Score: %d" % score

func _on_object_missed(obj):
	lives -= 1
	print("¡Bola perdida! Vidas restantes: %d" % lives)
	
	# Notificar cambio de vidas
	notify_observers("lives_changed", {"lives": lives, "reason": "missed"})
	$HUD/LivesLabel.text = "Lives: %d" % lives
	
	if lives <= 0:
		_game_over()

# Manejadores de eventos del observador
func _on_lives_changed(data: Dictionary):
	print("Vidas cambiaron: %d (razón: %s)" % [data.lives, data.reason])
	# Aquí puedes añadir efectos visuales o de sonido
	if data.lives <= 1:
		print("¡Cuidado! Solo te queda una vida")

func _on_score_changed(data: Dictionary):
	print("Puntuación: %d" % data.score)

func _on_speed_changed(data: Dictionary):
	print("Velocidad multiplicada por: %.2f" % data.multiplier)

func _game_over():
	$SpawnTimer.stop()
	get_tree().paused = true
	$HUD/MessageLabel.text = "GAME OVER\nScore: %d\nPress Enter to restart" % score
	$HUD/MessageLabel.show()

func _input(event):
	if event.is_action_pressed("ui_accept") and get_tree().paused:
		get_tree().paused = false
		score = 0
		lives = 3
		speed_multiplier = 1.0
		last_speed_increase = 0
		get_tree().reload_current_scene()
