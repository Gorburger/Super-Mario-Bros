extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.coin_sound.play()
	Info.Score += 20
	Info.Coins += 1
	queue_free()
