extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var parent = get_parent()  # Referencia al padre

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var alive = true
var score: int = 0

# Cargar la escena del nuevo personaje
const PLAYER_GOOD_SCENE = preload("res://scenes/player_good.tscn")

func _ready() -> void:
	_setup_player()

func _setup_player() -> void:
	# Conectar máscaras
	var masks = $"../masks"
	if masks:
		for mask in masks.get_children():
			mask.collected.connect(change_good)

func change_good() -> void:
	score += 1
	print(score)
	
	# Cambiar al personaje bueno cuando el score alcanza cierto valor
	# Por ejemplo, cambiar después de recoger 3 máscaras:
	if score >= 1:
		switch_to_player_good()

func switch_to_player_good() -> void:
	# Crear instancia del nuevo personaje
	var player_good_instance = PLAYER_GOOD_SCENE.instantiate()
	
	# Copiar posición y estado
	player_good_instance.position = self.position
	player_good_instance.velocity = self.velocity
	player_good_instance.alive = self.alive
	
	# Reemplazar en el árbol de nodos
	var parent_node = self.get_parent()
	var self_index = self.get_index()
	
	# Remover el jugador actual
	parent_node.remove_child(self)
	
	# Agregar el nuevo jugador
	parent_node.add_child(player_good_instance)
	parent_node.move_child(player_good_instance, self_index)
	
	# Liberar el nodo antiguo
	self.queue_free()

# El resto de tu código permanece igual...
func _physics_process(delta: float) -> void:
	if !alive:
		return
	
	# Run Animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite.animation = "walk"
	elif velocity.x == 0:
		animated_sprite.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite.flip_h = false
		
	if direction == -1.0:
		animated_sprite.flip_h = true

func die() -> void:
	death_sound.play()
	animated_sprite.animation = "walk"
	alive = false
