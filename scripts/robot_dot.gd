extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal player_died
const SPEED = 70.0
var direction = -1.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_timer_timeout() -> void:
	direction *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and body.alive:
		emit_signal("player_died", body)
