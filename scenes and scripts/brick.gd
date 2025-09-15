extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $Sprite2D

func _on_area_2d_body_entered(_body: Node2D) -> void:
	sprite.play("picked")
