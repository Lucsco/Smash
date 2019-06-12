extends Node2D

func _ready():
	print("manettes connectées : " + str(GLOBAL.manettes_connectees.size()))
	$Time.wait_time = 75
	$Time.start()
	$GUI/VBoxContainer3/TextureProgress.show()
	$GUI/VBoxContainer3/TextureProgress.value = $player.stock

func _physics_process(delta):
	match_timer()
	
func match_timer():
	var a = str(int($Time.time_left / 60))
	var b = str(int($Time.time_left) % 60)
	if  len(b) == 1:
		b = "0" + b
	var ms = a + " : " + b
	$GUI/VBoxContainer/Timer.text = ms 

func _on_player_die(stock):
	var a = $GUI/VBoxContainer3/TextureProgress
	a.value -= 1
	
