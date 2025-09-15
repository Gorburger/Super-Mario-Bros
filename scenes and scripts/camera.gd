extends Camera2D

var left_edge_position: float

func _process(_delta: float) -> void:
	left_edge_position = get_screen_center_position().x - 128
