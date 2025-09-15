extends Node2D

@onready var coin_label: Label = $CanvasLayer/CoinLabel
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var time_label: Label = $CanvasLayer/timeLabel
@onready var timer: Timer = $CanvasLayer/timeLabel/Timer
@onready var win_label: Label = $CanvasLayer/win_label
@onready var restart_button: Button = $CanvasLayer/restartButton
@onready var quit_button: Button = $CanvasLayer/quitButton

func _process(_delta: float) -> void:
	time_label.text = "TIME\n" + str("%03d" %int(timer.time_left))
	score_label.text = "GORBINO\n" + str("%06d" %Info.Score)
	coin_label.text = "x " + str("%02d" %Info.Coins)
	
	
func _on_warp_enabler_body_entered(body: Node2D) -> void:
	body.can_warp = true
	body.first_warp = true

func _on_warp_enabler_body_exited(body: Node2D) -> void:
	body.can_warp = false
	body.first_warp = false


func _on_fallzone_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if body == player:
		body.take_damage(true)
	else:
		body.queue_free()


func _on_warp_back_body_entered(body: Node2D) -> void:
	body.can_warp = true
	

func _on_warp_back_body_exited(body: Node2D) -> void:
	body.can_warp = false

func _on_timer_timeout() -> void:
	set_process(false)
	get_tree().reload_current_scene()
	Info.reset()

func game_won():
	timer.paused = true
	win_label.show()
	restart_button.show()
	quit_button.show()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	Info.reset()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
