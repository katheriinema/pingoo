# res://assets/scripts/GameState.gd
extends Node

signal coins_changed(new_amount)
signal fish_changed(new_amount)    # <— new signal

var fish_inventory : int = 10       # start at zero or whatever
var coins          : int = 0

func spend_fish() -> bool:
	if fish_inventory > 0:
		fish_inventory -= 1
		emit_signal("fish_changed", fish_inventory)
		return true
	return false

func add_fish(amount: int = 1):
	fish_inventory += amount
	emit_signal("fish_changed", fish_inventory)

func add_coins(amount: int):
	coins += amount
	emit_signal("coins_changed", coins)
