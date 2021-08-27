extends VBoxContainer

const pre_item = preload("res://scenes/prefab/score_iten.tscn")
var colors = [Color("1786bc"), Color("29e8b2"), Color("43bc17"), Color("e4e128"), Color("e82929")]


func _ready():
	pass

func teste():
	for a in range(0, 10):
		var itens = pre_item.instance()
		add_child(itens)
		yield(get_tree().create_timer(.2),"timeout")

func show_hiscore(hi_score):
	for c in get_children():
		c.queue_free()
	
	var itens = pre_item.instance()
	itens.pos = "RANK"
	itens.p_name = "NAME"
	itens.score = "SCORE"
	add_child(itens)
	var a = 0
	for hs in hi_score:
		itens = pre_item.instance()
		itens.pos = str(a + 1) + "º"
		itens.p_name = hs.name
		itens.score = hs.score
		itens.set_color(colors[a])
		add_child(itens)
		yield(get_tree().create_timer(.3),"timeout")
		a += 1

