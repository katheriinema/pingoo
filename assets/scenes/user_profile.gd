extends Control

@export var penguin_card_scene: PackedScene
@onready var penguin_grid = $RightPanel/PenguinScroll/PenguinGrid

# Mock user data (can replace with real player data later)
var user_data = {
	"username": "kakakakak",
	"date_started": "2025-04-17",
	"owned_penguins": [
		{"name": "Waddles", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Icy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Fluffy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Zippy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Pebbles", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Frosty", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Waddles", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Icy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Fluffy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Zippy", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Pebbles", "image": "res://assets/art/placeholders/penguin.png"},
		{"name": "Frosty", "image": "res://assets/art/placeholders/penguin.png"}
	],
	"total_revenue": 1240
}

func _ready():
	display_user_info()
	populate_penguins()

func display_user_info():
	$LeftPanel/Username.text = user_data.username + "'s Village"
	$LeftPanel/DateStarted.text = "Date Started: " + user_data.date_started
	$LeftPanel/OwnedPenguins.text = "Owned Penguins: " + str(user_data.owned_penguins.size())
	$LeftPanel/TotalRevenue.text = "Total Revenue: $" + str(user_data.total_revenue)

func populate_penguins():
	for penguin in user_data.owned_penguins:
		var card = penguin_card_scene.instantiate()
		card.get_node("PenguinImage").texture = load(penguin.image)
		card.get_node("PenguinName").text = penguin.name
		penguin_grid.add_child(card)
