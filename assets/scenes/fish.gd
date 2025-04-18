extends Sprite2D

func _ready():
	# Wait for 1 second, then fade out
	await get_tree().create_timer(1.0).timeout
	
	# Fade out over 1 second
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	# Wait for the tween to finish, then queue_free
	await tween.finished
	queue_free()
