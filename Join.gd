extends Button

func _on_Join_pressed():
	Cliente.join($LineEdit.text)
