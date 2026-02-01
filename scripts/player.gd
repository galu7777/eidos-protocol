extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var alive = true
var score: int = 0 
func _ready() -> void:
	_setud_player()

func _setud_player() -> void:
	# Connect masks
	var masks = $"../masks"
	if masks:
		for mask in masks.get_children():
			mask.collected.connect(change_good)
			
func change_good() -> void:
	score += 1
	print(score)

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
	
