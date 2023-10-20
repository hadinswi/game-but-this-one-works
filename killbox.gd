extends Area2D

signal player_reset_requested

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("player_reset_requested", body)
