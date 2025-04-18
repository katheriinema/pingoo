extends Node2D

@onready var chat  = $UI/ChatPanel
@onready var label = chat.get_node("ChatLabel")
@onready var input = chat.get_node("NameInput")
@onready var btn   = chat.get_node("OkButton")

var step = 0
var village_name = ""

func _ready():
	# connect the pressed signal
	btn.connect("pressed", Callable(self, "_on_ok"))
	# initialize your prompt
	input.visible = true

func _on_ok():
	match step:
		0:
			var name = input.text.strip_edges()
			if name == "":
				return  # don’t proceed on empty
			village_name = name
			label.text = "Welcome to %s!" % village_name
			input.visible = false
			btn.text = "Continue"
			step = 1
		1:
			chat.hide()
			spawn_egg()

func spawn_egg():
	var Egg = preload("res://assets/scenes/Egg.tscn")
	var egg = Egg.instantiate()
	egg.position = Vector2(600, 360)  # center of your plot
	add_child(egg)
