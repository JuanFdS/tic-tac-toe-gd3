extends Node2D

func no_se_pudo_conectar():
	$Errores.set_text("Hubo un problema al conectarse :(")

func cargando():
	$Errores.set_text("Cargando...")

func ocurrio_un_error(error):
	$Errores.set_text(error)
