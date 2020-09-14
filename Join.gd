extends Button

func _on_Join_pressed():
	get_tree().get_root().get_node('Main').cargando()
	Cliente.join($LineEdit.text)
