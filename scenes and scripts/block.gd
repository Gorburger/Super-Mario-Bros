extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var CoinAnimations: AnimatedSprite2D = $AnimatedSprite2D

var picked: bool = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not picked:
		picked = true
		sprite.play("picked")
		CoinAnimations.show()
		CoinAnimations.play("spin")
		body.coin_sound.play()
func _on_spin_animation_finished() -> void:
	CoinAnimations.hide()
	Info.Coins+=1
	Info.Score += 20
	
