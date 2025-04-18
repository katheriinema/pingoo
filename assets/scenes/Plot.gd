# res://assets/scripts/Plot.gd
extends Node2D

signal plot_clicked(plot)      # Emitted when this plot is clicked
signal plot_hatched(plot)      # Renamed signal

@export var egg_scene     : PackedScene = preload("res://assets/scenes/Egg.tscn")
@export var griller_scene : PackedScene = preload("res://assets/scenes/GrillerPenguin.tscn")
const FISH_TO_HATCH = 3

var fish_fed := 0
var is_hatched := false      # renamed variable
var egg_node  : Node2D
var grill_node: Node2D

func _ready():
	# 1) Spawn the egg on our plot
	egg_node = egg_scene.instantiate()
	egg_node.position = $EggSpawnPoint.position
	add_child(egg_node)

	# 2) Connect our Area2D so clicks emit plot_clicked(self)
	$Area2D.input_event.connect(_on_area_input)

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("plot_clicked", self)

# Called by the panel when the player clicks “Feed me”
func feed():
	if is_hatched:
		return
	fish_fed += 1
	if fish_fed >= FISH_TO_HATCH:
		hatch()

func hatch():
	if is_hatched:
		return
	is_hatched = true

	# Remove the egg
	if egg_node and egg_node.is_inside_tree():
		egg_node.queue_free()

	# Spawn the griller penguin in its place
	grill_node = griller_scene.instantiate()
	grill_node.position = $EggSpawnPoint.position
	add_child(grill_node)

	emit_signal("plot_hatched", self)  # emit renamed signal

# Helpers for the PlotPanel
func is_egg() -> bool:
	return not is_hatched

func get_display_texture() -> Texture2D:
	if is_egg():
		return egg_node.get_node("Sprite2D").texture
	else:
		return grill_node.get_node("Sprite2D").texture

func get_description() -> String:
	if is_egg():
		return "Fish fed: %d / %d" % [fish_fed, FISH_TO_HATCH]
	else:
		return "Griller Penguin – Ready to Sell"
