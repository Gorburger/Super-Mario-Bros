extends CharacterBody2D

@onready var wall_checker: RayCast2D = $WallChecker
@onready var sprite: Sprite2D = $Sprite2D

var direction: int = 1
var speed: int = 30
var gravity: int = 300
var turn_raycast_on: bool = false

func _physics_process(delta: float) -> void:
	if turn_raycast_on and wall_checker.is_colliding():
		wall_checker.target_position.x *= -1
		wall_checker.position.x *= -1
		direction = -direction
	velocity.x = direction * speed
	if !is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_timer_timeout() -> void:
	turn_raycast_on = true


func _on_hit_detector_body_entered(body: Node2D) -> void:
	body.mushroom_collected()
	queue_free()
