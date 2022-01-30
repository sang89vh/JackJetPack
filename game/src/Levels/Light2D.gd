extends Light2D

func _on_Timer_timeout():
	if self.enabled:
		self.enabled = false
	else:
		self.enabled = true
