extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var fireball_marker: Node2D = $fireball_marker
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var coin_sound: AudioStreamPlayer2D = $CoinSound
@onready var power_up_sound: AudioStreamPlayer2D = $PowerUpSound
@onready var enemy_death_sound: AudioStreamPlayer2D = $EnemyDeathSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var warp_sound: AudioStreamPlayer2D = $WarpSound
@onready var fireball_sound: AudioStreamPlayer2D = $FireballSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound

const SPEED = 175
const gravity: int = 980
var mario_level :int = 0
var can_warp: bool = false
var first_warp:bool = false
var fireball_scene = preload("res://scenes and scripts/fireball.tscn")
var can_recieve_input: bool = true
var last_safe_position: Vector2

func _physics_process(delta: float) -> void:
	if can_recieve_input:
		if not is_on_floor():
			if mario_level < 2:
				sprite.play("jump")
			else:
				sprite.play("super_jump")
			velocity.y += gravity * delta
		else:
			if velocity.x != 0:
				if mario_level < 2:
					sprite.play("walk")
				else:
					sprite.play("super_walk")
			else:
				if mario_level < 2:
					sprite.play("default")
				else:
					sprite.play("super_default")
			
		if Input.is_action_pressed("jump") and is_on_floor():
			bounce()

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if velocity.x < 0:
				sprite.flip_h = true
				fireball_marker.position.x = -16
			elif velocity.x > 0:
				sprite.flip_h = false
				fireball_marker.position.x = 16
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if can_warp:
			if Input.is_action_just_pressed("down") and first_warp:
				await pre_warp()
				warp(Vector2(2404,2660), Vector2(624,6864), Vector2(2428,821))
			elif Input.is_action_pressed("right") and not first_warp:
				await pre_warp()
				warp(Vector2(5,3408), Vector2(192,432), Vector2(2645,357))
				
		if mario_level == 2 and Input.is_action_just_pressed("shoot"):
			fireball_sound.play()
			var fireball = fireball_scene.instantiate()
			get_tree().current_scene.add_child(fireball)
			fireball.global_position = fireball_marker.global_position
			if sprite.flip_h == true:
				fireball.direction = -1
	if global_position.x <= camera.left_edge_position + 5:
			global_position.x = camera.left_edge_position + 5
	move_and_slide()
	if ground_detector.is_colliding():
		last_safe_position = global_position

func take_damage(fell:bool=false):
	get_tree().set_pause(true)
	hit_sound.play()
	
	if fell:
		set_physics_process(false)
		await get_tree().create_timer(0.5).timeout
		global_position = last_safe_position
		set_physics_process(true)

func bounce(jump_velocity= -350):
	velocity.y = jump_velocity
	jump_sound.play()

func pre_warp():
	sprite.visible = false
	set_physics_process(false)
	warp_sound.play()
	await get_tree().create_timer(1).timeout
	sprite.visible = true
	set_physics_process(true)
	
func warp(LeftRight:Vector2, TopBottom:Vector2, NewPos:Vector2):
	camera.limit_left = LeftRight.x
	camera.limit_right = LeftRight.y
	camera.limit_top = TopBottom.x
	camera.limit_bottom = TopBottom.y
	global_position = NewPos
	sprite.flip_h = false

func mushroom_collected():
	Info.Score += 100
	if mario_level+1 < 3:
		mario_level +=1
	set_mario_level()
	get_tree().set_pause(true)
	power_up_sound.play()
	
func set_mario_level():
	if mario_level == 0:
		sprite.scale = Vector2(1,1)
		collision_shape.scale = Vector2(1,1)
	elif mario_level == 1:
		sprite.scale = Vector2(1.25, 1.25)
		collision_shape.scale = Vector2(1.25, 1.25)


func _on_hit_sound_finished() -> void:
	if mario_level-1 >= 0:
		mario_level -= 1
		set_mario_level()
	else:
		get_tree().call_deferred("reload_current_scene")
		Info.reset()
	get_tree().set_pause(false)


func _on_power_up_sound_finished() -> void:
	get_tree().set_pause(false)
