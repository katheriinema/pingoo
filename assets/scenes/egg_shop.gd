extends Node2D

var money = 500
var selected_egg_type = ""
var prices = {"common": 10, "rare": 50, "epic": 200}

func _ready():
	$MoneyLabel.text = "💰 $" + str(money)

func _on_buy_button_common_pressed():
	_on_buy_button_pressed("common")

func _on_buy_button_rare_pressed():
	_on_buy_button_pressed("rare")

func _on_buy_button_epic_pressed():
	_on_buy_button_pressed("epic")

# Shared function that updates the popup dialog
func _on_buy_button_pressed(egg_type: String):
	selected_egg_type = egg_type
	$ConfirmationPopup.dialog_text = "Do you want to buy a %s egg for $%d?" % [egg_type.capitalize(), prices[egg_type]]
	$ConfirmationPopup.popup_centered()

func _on_confirmation_popup_confirmed() -> void:
	var cost = prices[selected_egg_type]
	if money >= cost:
		money -= cost
		$MoneyLabel.text = "💰 $" + str(money)

		var msg = "You bought a %s egg!" % selected_egg_type.capitalize()
		show_success_message(msg)
	else:
		show_success_message("Not enough money!")

func show_success_message(msg: String):
	$SuccessLabel.text = msg
	$SuccessLabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$SuccessLabel.visible = false
