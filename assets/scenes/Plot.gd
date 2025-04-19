# res://assets/scripts/Plot.gd
extends Node2D

signal plot_clicked(plot)
signal plot_hatched(plot)

@export var egg_scene        : PackedScene = preload("res://assets/scenes/Egg.tscn")
@export var griller_scene    : PackedScene = preload("res://assets/scenes/GrillerPenguin.tscn")
@export var penguin_type     : String      = "taiyaki"
@export var panel_description: String      = "Your first penguin!!!"
@export var icon_folder      : String      = "res://assets/art/icons/"

const FISH_TO_HATCH = 3

var fish_fed     : int    = 0
var is_hatched   : bool   = false
var penguin_name : String = ""

var egg_node     : Node2D
var griller_node : Node2D

func _ready():
	# Spawn the egg
	egg_node = egg_scene.instantiate()
	egg_node.position = $EggSpawnPoint.position
	add_child(egg_node)

	add_to_group("plots")
	$Area2D.connect("input_event", Callable(self, "_on_area_input"))

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("plot_clicked", self)

func feed():
	if is_hatched: return
	fish_fed += 1
	if fish_fed >= FISH_TO_HATCH:
		hatch()

func hatch():
	if is_hatched: return
	is_hatched = true

	# Remove the egg
	if egg_node and egg_node.is_inside_tree():
		egg_node.queue_free()

	# Spawn the penguin
	griller_node = griller_scene.instantiate()
	griller_node.position = $EggSpawnPoint.position
	add_child(griller_node)

	emit_signal("plot_hatched", self)

func sell():
	# Don’t allow selling the last penguin
	var remaining = get_tree().get_nodes_in_group("plots").size()
	if remaining <= 1:
		return
	GameState.add_coins(100)
	queue_free()

func is_egg() -> bool:
	return not is_hatched

func needs_name() -> bool:
	return is_hatched and penguin_name == ""

func set_penguin_name(new_name:String) -> void:
	penguin_name = new_name

func get_display_texture() -> Texture2D:
	if is_egg():
		return egg_node.get_node("Sprite2D").texture
	else:
		return griller_node.get_node("Sprite2D").texture

func get_description() -> String:
	return "Fish fed: %d / %d" % [fish_fed, FISH_TO_HATCH]

func get_panel_description() -> String:
	return panel_description
