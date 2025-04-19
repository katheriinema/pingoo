# res://assets/scripts/Main.gd
extends Node2D

@onready var chat               = $UI/ChatPanel
@onready var label              = chat.get_node("ChatLabel")
@onready var input              = chat.get_node("NameInput")
@onready var btn                = chat.get_node("OkButton")
@onready var spawn_points       = [
	$PlotSpawns/SpawnPoint0,
	$PlotSpawns/SpawnPoint1,
	$PlotSpawns/SpawnPoint2,
	$PlotSpawns/SpawnPoint3,
]
@onready var plot_panel_scene   = preload("res://assets/scenes/PlotPanel.tscn")
@onready var coin_label         = $UI/CoinLabel
@onready var pond_button = $WorldLayer/PondButton
@onready var fishing_scene = preload("res://assets/scenes/Fishing.tscn")
var fishing_node: Node = null

var step            := 0
var village_name    := ""
var used_indices    := []
var plot_panel: Panel = null

func _ready():
	randomize()
	btn.connect("pressed", Callable(self, "_on_ok"))
	label.text = "Hi Chief! Name your village:"
	input.visible = true

	# Create and hide the plot panel
	plot_panel = plot_panel_scene.instantiate()
	$UI.add_child(plot_panel)
	plot_panel.hide()

	# Initialize coin label and listen for changes
	_update_coin_label(GameState.coins)
	GameState.connect("coins_changed", Callable(self, "_update_coin_label"))
	pond_button.connect("pressed", Callable(self, "start_fishing"))


func _on_ok():
	match step:
		0:
			var input_name = input.text.strip_edges()
			if input_name == "": return
			village_name = input_name
			label.text = "Welcome to %s! Here's your first egg." % village_name
			input.visible = false
			btn.text = "Continue"
			step = 1
		1:
			chat.hide()
			spawn_plot()

func spawn_plot():
	var idx = used_indices.size()
	if idx >= spawn_points.size():
		push_error("No more free plot slots!")
		return
	used_indices.append(idx)

	var PlotScene = preload("res://assets/scenes/Plot.tscn")
	var plot = PlotScene.instantiate()

	# Assign types & descriptions
	if idx == 0:
		plot.penguin_type       = "taiyaki"
		plot.panel_description  = "Your first legend at the grill!"
	else:
		var types = ["redbean", "matcha", "chocolate"]
		var choice = types[randi() % types.size()]
		plot.penguin_type = choice
		match choice:
			"redbean":
				plot.panel_description = "This sweet soul stirs joy!"
			"matcha":
				plot.panel_description = "Brewed to perfection!"
			"chocolate":
				plot.panel_description = "Indulgence in every bite!"

	# Position
	if idx == 0:
		plot.position = get_viewport_rect().size / 2
	else:
		plot.position = spawn_points[idx].position

	add_child(plot)
	plot.connect("plot_clicked", Callable(self, "open_plot_panel"))
	plot.connect("plot_hatched", Callable(self, "open_plot_panel"))

func open_plot_panel(plot):
	plot_panel.show_for_plot(plot)

func _update_coin_label(new_amount: int):
	coin_label.text = "Coins: %d" % new_amount

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if plot_panel.visible:
			var mouse_pos   = get_viewport().get_mouse_position()
			var panel_pos   = plot_panel.global_position
			var panel_size  = plot_panel.size
			var panel_rect  = Rect2(panel_pos, panel_size)
			if not panel_rect.has_point(mouse_pos):
				plot_panel.hide()


func start_fishing():
	get_tree().change_scene_to_file("res://assets/scenes/Fishing.tscn")
	
