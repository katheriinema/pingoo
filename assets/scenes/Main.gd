extends Node2D

@onready var chat         = $UI/ChatPanel
@onready var label        = chat.get_node("ChatLabel")
@onready var input        = chat.get_node("NameInput")
@onready var btn          = chat.get_node("OkButton")
@onready var spawn_points = [
	$PlotSpawns/SpawnPoint0,
	$PlotSpawns/SpawnPoint1,
	$PlotSpawns/SpawnPoint2,
	$PlotSpawns/SpawnPoint3,
]
@onready var plot_panel_scene = preload("res://assets/scenes/PlotPanel.tscn")

var step = 0
var village_name = ""
var used_indices = []   # tracks which spots are taken
var plot_panel

func _ready():
	randomize()  # initialize RNG
	btn.connect("pressed", Callable(self, "_on_ok"))
	input.visible = true
	plot_panel = plot_panel_scene.instantiate()
	$UI.add_child(plot_panel)
	plot_panel.hide()

func _on_ok():
	match step:
		0:
			var input_name = input.text.strip_edges()
			if input_name == "":
				return
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

	var plot = preload("res://assets/scenes/Plot.tscn").instantiate()

	if idx == 0:
		plot.position = get_viewport_rect().size / 2
	else:
		plot.position = spawn_points[idx].position

	add_child(plot)
	# ── ADD THIS LINE ──
	plot.connect("plot_clicked", Callable(self, "open_plot_panel"))

	print("Spawned plot at", plot.position)

func open_plot_panel(plot):
	plot_panel.show_for_plot(plot)
