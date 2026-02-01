extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal collected




func _on_body_entered(_body: Node2D) -> void:
	animated_sprite.animation = "collected"
	collected.emit()
	call_deferred("_disable_collision")
	
func _disable_collision() -> void:
	collision_shape.disabled = true
	

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite.animation == "collected":
		queue_free()
