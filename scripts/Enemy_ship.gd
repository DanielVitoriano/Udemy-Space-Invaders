tool
extends Area2D

export(int, "Enemy A", "Enemy B", "Enemy C") var type = 0  setget set_atributes
var frame = 0

signal emit_dead(obj)

var atributes = [
	{
		"texture": preload("res://Assets/sprites/InvaderA_sheet.png"),
		"score": 10
	},
	{
		"texture": preload("res://Assets/sprites/InvaderB_sheet.png"),
		"score": 15
	},
	{
		"texture": preload("res://Assets/sprites/InvaderC_sheet.png"),
		"score": 20
	}
]

var score = 0

func _draw():
	var atribute = atributes[type]
	$Sprite.texture = atribute.texture
	score = atribute.score

func _ready():
	pass

func set_atributes(val):
	type = val
	if Engine.editor_hint:
		update()

func destroy():
	emit_signal("emit_dead", self)
	queue_free()

func next_frame():
	if frame == 0:
		frame = 1
	else:
		frame = 0
	$Sprite.frame = frame


func _on_Enemy_ship_area_entered(area):
	if area.has_method("damage"):
		area.damage()
