extends Node

var fish_inventory : int = 10
var coins          : int = 0

func spend_fish() -> bool:
	if fish_inventory > 0:
		fish_inventory -= 1
		return true
	return false

func add_coins(amount: int):
	coins += amount
