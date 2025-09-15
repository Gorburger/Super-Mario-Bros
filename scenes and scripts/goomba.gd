extends CharacterBody2D

@export var direction: Vector2 = Vector2(-1, 0)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var hit_collision: CollisionShape2D = $hit_detector/CollisionShape2D
@onready var attack_collision: CollisionShape2D = $collision_detector/CollisionShape2D


const SPEED = 1

func _ready() -> void:
	if direction == Vector2.LEFT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(_delta: float) -> void:
	move_and_collide(direction * SPEED)
	if not raycast.is_colliding():
		reverse_direction()

func reverse_direction():
	direction *= -1
	if direction == Vector2.LEFT:
		sprite.flip_h = false
		raycast.position.x *= -1
	else:
		sprite.flip_h = true
		raycast.position.x *= -1
	


func collision_detected(body: Node2D) -> void:
	if raycast.is_colliding():
		if body is CharacterBody2D:
			if body.collision_layer == 4:
				body.queue_free()
				death()
			else:
				body.take_damage()
		else:
			reverse_direction()



func hit_detected(body: Node2D) -> void:
	var height_difference: float = (body.global_position.y - global_position.y)
	if height_difference < -5:
		body.bounce(-200)
		death()
		Info.Score += 50
	
func _on_animation_finished() -> void:
	if sprite.animation == "death":
		queue_free()

func death():
	var player = get_tree().get_first_node_in_group("Player")
	player.enemy_death_sound.play()
	hit_collision.set_deferred("disabled", true)
	attack_collision.set_deferred("disabled", true)
	set_physics_process(false)
	sprite.play("death")
