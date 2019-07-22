extends "res://Scripts/player.gd"

func _physics_process(delta):
	if Input.is_action_pressed("attack"):
		jab()

func _on_hitbox_body_entered(body):
	if get_parent().get_node(body.name).has_method("take_damage"):
		get_parent().get_node(body.name).take_damage()
	else : pass
	
func take_damage():
	print("aaa")

func jab():
	animation_play("jab")