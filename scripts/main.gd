extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _setup_level() -> void:
	# Connect enemys
	var enemies = $LevelRoot.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
	
			
#-----------------------------
# SIGNALS HANDLERS
#-----------------------------

func _on_player_died(body):
	body.die()
	#print("jugador muerto", body.name)
#
