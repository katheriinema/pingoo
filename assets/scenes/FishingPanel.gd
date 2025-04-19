# res://assets/scripts/FishingPanel.gd
extends Panel

@onready var GameState         = get_node("/root/GameState")
@onready var close_btn    = $CloseButton
@onready var fishing_game = $FishingGame

func _ready():
	GameState.connect("fish_changed", Callable(self, "_on_fish_changed"))
	_on_fish_changed(GameState.fish_inventory)

func _on_fish_changed(amount:int):
	$FishingGame/UI/FishCounter.text = "Fish: %d" % amount

func _on_close_pressed():
	hide()
	get_tree().call_group("main_game", "show_game")
