extends Node

const letters = "ABCDEFGHIJKLMNOPQRSTUVXWYZ0123456789_*# "

var letter_index = 0
var letter = 0

signal finished(name)

func _ready():
	set_process_input(true)

func _input(event):
	
	var changed = false
	
	if event.is_action_pressed("ui_right") and not event.is_echo():
		letter_index += 1
		changed = true
	
	if event.is_action_pressed("ui_left") and not event.is_echo():
		letter_index -= 1
		changed = true
	
	if changed:
		if letter_index < 0:
			letter_index = letters.length()
		elif letter_index >= letters.length():
			letter_index = 0
			
		$container.get_child(letter).set_text(letters[letter_index -1])
		
	if event.is_action_pressed("ui_shoot") and not event.is_echo():
		$container.get_child(letter).modulate.a = 255
		letter += 1
		letter_index = 1
		if letter > 2:
			$Timer.stop()
			set_process_input(false)
			var name = $container/l1.text + $container/l2.text + $container/l3.text
			emit_signal("finished", name)
	
func _on_Timer_timeout():
	if $container.get_child(letter).modulate.a > 0:
		$container.get_child(letter).modulate.a = 0
	
	else:
		$container.get_child(letter).modulate.a = 255
