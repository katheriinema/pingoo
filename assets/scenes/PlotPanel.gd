# res://assets/scripts/PlotPanel.gd
extends Panel

@onready var plot_image  = $PlotImage
@onready var description = $VBoxContainer/Description
@onready var action_btn  = $VBoxContainer/ActionButton

var current_plot

func show_for_plot(plot):
	current_plot = plot
	# Always show whatever the Plot hands us (egg or penguin)
	plot_image.texture = plot.get_display_texture()

	# Prepare callables
	var feed_cb = Callable(self, "_on_feed")
	var sell_cb = Callable(self, "_on_sell")

	# Clear old connections
	if action_btn.is_connected("pressed", feed_cb):
		action_btn.disconnect("pressed", feed_cb)
	if action_btn.is_connected("pressed", sell_cb):
		action_btn.disconnect("pressed", sell_cb)

	if plot.is_egg():
		# While it’s still an egg, show fish‑progress and feed button
		description.text = plot.get_description()  # "Fish fed: X / 3"
		action_btn.text = "Feed me"
		action_btn.disabled = false
		action_btn.connect("pressed", feed_cb)
	else:
		# Once hatched, get_description() will say "Griller Penguin – Ready to Sell"
		description.text = plot.get_description()
		action_btn.text = "Sell"
		action_btn.disabled = false
		action_btn.connect("pressed", sell_cb)
	show()

func _on_feed():
	if GameState.spend_fish():
		current_plot.feed()
		# refresh the panel (progress text and possibly switch to Sell)
		show_for_plot(current_plot)
	else:
		action_btn.disabled = true
		description.text += "\n(Out of fish!)"

func _on_sell():
	current_plot.sell()
	hide()
