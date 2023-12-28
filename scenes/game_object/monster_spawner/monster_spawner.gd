extends Node2D

@export var monster_scene: PackedScene
@export var player_instance: CharacterBody2D
@export var tile_map: TileMap
@export var house: Node2D

@onready var timer: Timer = $Timer

var base_spawn_time = 0
# TODO: setup weighted table for different monster types -> var enemy_table = WeightedTable.new()
var number_to_spawn = 1

func _ready() -> void: 
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	print('on_timer_timeout->spawning monster')
	timer.start()
	
	var monster = monster_scene.instantiate()
	monster.source = monster
	monster.target = player_instance
	monster.tile_map = tile_map
	house.add_child(monster)
	monster.position = global_position
