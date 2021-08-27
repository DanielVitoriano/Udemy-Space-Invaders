extends Node2D



func _ready():
	$music.play()

func _on_Timer_timeout():
	$labels/Label.visible_characters += 1
	if $labels/Label.visible_characters == 143 and ProjectSettings.get("locale/test") == "pt_BR" or $labels/Label.visible_characters == 139 and ProjectSettings.get("locale/test") == "en":
		$Timer.stop()
		$anim.play("label_up")
		yield($anim,"animation_finished")
		$Timer.start()
	
	if $labels/Label.visible_characters >= 270:
		$anim.set("playback_speed", .2)
		#$labels/Label.hide()
		$labels/Label.queue_free()
		$button.show()
		$Timer.stop()
		$Timer.queue_free()


func _on_button_pressed():
	if $Sprite.visible != true:
		$anim2.play("tuts")
		$hearts.emitting = true
		$button.hide()
		yield(get_tree().create_timer(5), "timeout")
		$exit.show()

func _on_exit_pressed():
	get_tree().change_scene("res://scenes/phases/main.tscn")
