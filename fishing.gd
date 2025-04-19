extends Node2D

@onready var power_meter = $UI/PowerMeter
var increasing = true
var fishing_enabled = true
var fish_count = 0
var regen_interval := 60  # seconds
var seconds_until_next_energy := regen_interval

func _process(delta):
	if !fishing_enabled:
		return

	if increasing:
		power_meter.value += 100 * delta
		if power_meter.value >= 100:
			increasing = false
	else:
		power_meter.value -= 100 * delta
		if power_meter.value <= 0:
			increasing = true

func _input(event):
	if event.is_action_pressed("ui_accept") and fishing_enabled:
		check_catch()

@onready var fish_scene = preload("res://assets/scenes/Fish.tscn")

func spawn_fish():
	var fish = fish_scene.instantiate()
	var center = Vector2(350, 300)  # Your central target spawn point
	var x_offset = randf_range(-50, 50)  # Small horizontal variation
	var y_offset = randf_range(-25, 25)  # Small vertical variation

	fish.position = center + Vector2(x_offset, y_offset)
	add_child(fish)

@onready var fish_counter_label = $UI/FishCounter

func update_fish_count():
	fish_count += 1
	fish_counter_label.text = "Fish: %d" % fish_count

func check_catch():
	var current = power_meter.value
	fishing_enabled = false

	var feedback = ""
	if current > 48 and current < 52:
		feedback = "Perfect!"
		spawn_fish()
		update_fish_count()
	elif current > 40 and current < 60:
		feedback = "Good!"
		spawn_fish()
		update_fish_count()
	else:
		feedback = "Miss!"

	show_feedback(feedback)

	await get_tree().create_timer(1.5).timeout
	fishing_enabled = true



func _on_fish_button_pressed() -> void:
	if !fishing_enabled:
		return
	
	if current_energy <= 0:
		show_feedback("Too tired!")
		return

	current_energy -= 1
	update_energy_display()
	check_catch()


@onready var feedback_label = $UI/FeedbackLabel

func show_feedback(text: String):
	feedback_label.text = text
	feedback_label.modulate.a = 1.0  # reset opacity

	# Fade out smoothly
	feedback_label.create_tween().tween_property(
		feedback_label, "modulate:a", 0.0, 1.2
	)

var max_energy := 10
var current_energy := 10

@onready var energy_label := $UI/EnergyLabel

func update_energy_display():
	energy_label.text = "Energy: %d / %d" % [current_energy, max_energy]


@onready var energy_timer_label := $UI/EnergyTimerLabel

func _on_countdown_timer_timeout() -> void:
	seconds_until_next_energy -= 1

	if seconds_until_next_energy <= 0:
		if current_energy < max_energy:
			current_energy += 1
			update_energy_display()
		seconds_until_next_energy = regen_interval

	update_timer_label()

func update_timer_label():
	energy_timer_label.text = "Next Energy In: %ds" % seconds_until_next_energy
	
func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/Main.tscn")
	
func _ready():
	update_energy_display()
	update_timer_label()
