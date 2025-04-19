# res://assets/scripts/FishingGame.gd
extends Node2D

@onready var GameState         = get_node("/root/GameState")
@onready var power_meter          = $UI/PowerMeter
@onready var fish_counter_label   = $UI/FishCounter
@onready var feedback_label       = $UI/FeedbackLabel
@onready var energy_label         = $UI/EnergyLabel
@onready var energy_timer_label   = $UI/EnergyTimerLabel

@onready var energy_regen_timer   = $EnergyRegenTimer
@onready var countdown_timer      = $CountdownTimer

var increasing = true
var fishing_enabled = true
var fish_count = 0
var max_energy := 10
var current_energy := max_energy
var regen_interval := 60
var seconds_until_next_energy := regen_interval

@onready var fish_scene = preload("res://assets/scenes/Fish.tscn")

func _ready():
	update_energy_display()
	update_timer_label()
	energy_regen_timer.wait_time = 1
	energy_regen_timer.start()
	countdown_timer.wait_time = 1
	countdown_timer.start()

func _process(delta):
	if not fishing_enabled:
		return
	if increasing:
		power_meter.value += 100 * delta
		if power_meter.value >= 100:
			increasing = false
	else:
		power_meter.value -= 100 * delta
		if power_meter.value <= 0:
			increasing = true

func _on_CountdownTimer_timeout():
	seconds_until_next_energy -= 1
	if seconds_until_next_energy <= 0:
		if current_energy < max_energy:
			current_energy += 1
			update_energy_display()
		seconds_until_next_energy = regen_interval
	update_timer_label()

func update_timer_label():
	energy_timer_label.text = "Next Energy In: %ds" % seconds_until_next_energy

func update_energy_display():
	energy_label.text = "Energy: %d / %d" % [current_energy, max_energy]

func _on_FishButton_pressed():
	if not fishing_enabled:
		return
	if current_energy <= 0:
		show_feedback("Too tired!")
		return
	current_energy -= 1
	update_energy_display()
	check_catch()

func check_catch():
	fishing_enabled = false
	var current = power_meter.value
	if current > 48 and current < 52:
		show_feedback("Perfect!")
		_award_fish()
	elif current > 40 and current < 60:
		show_feedback("Good!")
		_award_fish()
	else:
		show_feedback("Miss!")
	await get_tree().create_timer(1.5).timeout
	fishing_enabled = true

func _award_fish():
	# give 1 fish to the global GameState
	GameState.add_fish(1)
	# spawn a little fish animation
	spawn_fish()

func spawn_fish():
	fish_count += 1
	fish_counter_label.text = "Fish: %d" % fish_count
	var fish = fish_scene.instantiate()
	fish.position = Vector2(200, 150) + Vector2(randi()%100-50, randi()%50-25)
	add_child(fish)

func show_feedback(text:String):
	feedback_label.text = text
	feedback_label.modulate.a = 1.0
	feedback_label.create_tween().tween_property(feedback_label, "modulate:a", 0.0, 1.2)
