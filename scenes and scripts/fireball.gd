extends CharacterBody2D

var direction = 1
var speed = 250
var gravity = 1600
func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y -= 225
	if move_and_slide() and !is_on_floor():
		queue_free()
