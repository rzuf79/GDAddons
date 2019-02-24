tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("RexSprite", "Sprite", preload("rex_sprite.gd"), preload("icon.png"))
	pass

func _exit_tree():
	remove_custom_type("RexSprite")
	pass