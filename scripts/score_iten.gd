extends HBoxContainer

var pos = "1ST" setget set_pos
var p_name = "AAA" setget set_name
var score = "0000" setget set_score
var color = Color(1, 1, 1, 1) setget set_color

func _ready():
	pass

func set_pos(val):
	pos = str(val)
	$pos.text = pos
	$pos.set_align(Label.ALIGN_LEFT)

func set_name(val):
	p_name = str(val)
	$name.text = p_name
	$name.set_align(Label.ALIGN_CENTER)

func set_score(val):
	score = str(val)
	$score.text = score
	$score.set_align(Label.ALIGN_RIGHT)

func set_color(val):
	color = val
	$pos.set("custom_colors/font_color", color)
	$name.set("custom_colors/font_color", color)
	$score.set("custom_colors/font_color", color)
