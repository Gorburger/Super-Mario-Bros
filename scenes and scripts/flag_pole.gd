extends Area2D
var player
var change_pos: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(_body: Node2D) -> void:
	change_pos = true
	player.can_recieve_input = false

func _process(_delta: float) -> void:
	if change_pos:
		if !player.is_on_floor():
			player.velocity = Vector2(0,0)
			player.global_position.y += 1
			
		elif player.global_position.x < 3276:
			player.velocity = Vector2(0,0)
			player.global_position.x += 1
			if player.mario_level == 2:
				player.sprite.play("super_walk")
			else:
				player.sprite.play("walk")
		else:
			player.sprite.hide()
			set_physics_process(false)
			var level = get_tree().get_first_node_in_group("level")
			level.game_won()
