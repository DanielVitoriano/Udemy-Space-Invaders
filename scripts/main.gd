extends Node2D

var PRE_NAME_SELECTOR = preload("res://scenes/prefab/name_selector.tscn")
var PRE_GAME = preload("res://scenes/phases/Game.tscn")
var game
var hiscore

const HISCORE_FILE = "user://hiscore"
const CONFIG_FILE = "user://config"

var config = ConfigFile.new()
var config_ok = false

var hi_score = [
	{name = "NA", score = 0},
	{name = "NA", score = 0},
	{name = "NA", score = 0},
	{name = "NA", score = 0},
	{name = "NA", score = 0}
]

var data = {
	 extra_life_index = 0,
	 score = 0,
	 lifes = 0
}

func _ready():
	load_score()
	load_config()
	$hiscore.show_hiscore(hi_score)

func new_game():
	if game != null:
		game.queue_free()
	
	game = PRE_GAME.instance()
	call_deferred("add_child", game)
	game.connect("game_over", self, "on_game_over")
	game.connect("victory", self, "on_game_victory")

func _on_Button_pressed():
	$Button.hide()
	$hiscore.hide()
	$title.hide()
	$opt.hide()
	new_game()
	#$controls.show()

func on_game_over():
	hiscore = null
	for hs in hi_score:
		if  game.data.score > hs.score:
			hiscore = hs
			break
		
	if hiscore != null:
		var name_selector = PRE_NAME_SELECTOR.instance()
		$".".add_child(name_selector)
		name_selector.connect("finished", self, "on_name_selector_finished")
		yield(name_selector, "finished")
		name_selector.queue_free()
		
		save_hiscore()
		
	$Button.show()
	$hiscore.show()
	$hiscore.show_hiscore(hi_score)
	#$controls.hide()

func on_game_victory():
	data = game.data
	
	new_game()
	
	game.data = data
	
func on_name_selector_finished(val):
	var index = hi_score.find(hiscore)
	hi_score.insert(index, {name = val, score = game.data.score})
	hi_score.resize(5)
	

func save_hiscore():
	var file = File.new()
	var result = file.open(HISCORE_FILE, file.READ)
	if result == OK:
		var store_hiscore = {
			hiscore = hi_score
		}
		file.store_string(to_json(store_hiscore))
		file.close()

func load_score():
	var file = File.new()
	var result = file.open(HISCORE_FILE, file.READ)
	if result == OK:
		var text = file.get_as_text()
		var store_hiscore = {}
		store_hiscore = parse_json(text)
		hi_score = store_hiscore.hiscore
		file.close()


func _on_opt_pressed():
	interpolate(Vector2(0,0), Vector2(-180, 0))

func _on_ok_pressed():
	save_config()
	interpolate(Vector2(-180,0), Vector2(0, 0))

func interpolate(init, end):
	$Tween_camera.interpolate_property($Camera2D, "position", init, end, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0)
	$Tween_camera.start()


func _on_volume_control_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	if config_ok: 
		$options/sample_text.play()


func _on_music_control_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUSIC"), value)

func save_config():
	config.set_value("audio", "fx", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	config.set_value("audio", "music", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUSIC")))
	config.save(CONFIG_FILE)

func load_config():
	if config.load(CONFIG_FILE) == OK:
		config.load(CONFIG_FILE)
		$options/volume_control.value = config.get_value("audio","fx")
		$options/music_control.value = config.get_value("audio","music")
		config_ok = true
