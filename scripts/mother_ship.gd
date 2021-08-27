extends Area2D

var score = 150

signal emit_dead(ob)

func _ready():
	$anim.play("move")
	yield($anim, "animation_finished")
	queue_free()

func destroy():
	emit_signal("emit_dead", self)
	queue_free()
