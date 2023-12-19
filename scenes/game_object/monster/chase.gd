extends Node2D

@export var source = CharacterBody2D.new()
@export var target = Node2D.new()
@export var show_grid = true
@export var show_path = true
@export var speed = 10
@export var tile_map = TileMap.new()

@onready var path = $Path

var astar_grid = AStarGrid2D.new()
var cell_size
var grid_size
var point_path

var start = Vector2i.ZERO
var end = Vector2i(5, 5)

func _ready():
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	path.visible = show_path
	initialize_grid()
	
## Converts a Vector2 into a set of coordinates that fall into the grid
func to_cell_ids(coords):
	var float_ids = Vector2i(coords) / Vector2i(cell_size)
	return Vector2i(round(float_ids.x), round(float_ids.y))

## Fits the astar grid to the tilemap
func initialize_grid():
	cell_size = tile_map.tile_set.tile_size
	grid_size = tile_map.get_used_rect().size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()
	
	# Sync solid points from the tilemap
	for c in tile_map.get_used_cells(0):
		var tile_data = tile_map.get_cell_tile_data(0, c)
		if tile_data.get_collision_polygons_count(0) > 0:
			astar_grid.set_point_solid(c, true)

## Renders the walls for debugging
func fill_walls():
	for x in grid_size.x:
		for y in grid_size.y:
			if astar_grid.is_point_solid(Vector2i(x, y)):
				draw_rect(Rect2(
					x * cell_size.x - global_position.x, # convert to local
					y * cell_size.y - global_position.y, 
					cell_size.x, cell_size.y), Color.DARK_GRAY)

## Calculates where the character should go using the astar grid.
## Will set the point_path variable with all the points in global pos.
func update_path():
	point_path = PackedVector2Array(astar_grid.get_point_path(start, end))

	# The point path will be in GLOBAL coordinates. Convert them to local.
	var local_point_path = []
	for p in point_path:
		local_point_path.append(to_local(p))
	
	path.points = local_point_path
	
## Renders the grid. Useful for debugging.
func draw_grid():
	for x in grid_size.x + 1:
		var from = to_local(Vector2i(x * cell_size.x, 0))
		var to = to_local(Vector2i(x * cell_size.x, grid_size.y * cell_size.y))
		draw_line(from, to, Color.DARK_GRAY, 2.0)
	for y in grid_size.y + 1:
		var from = to_local(Vector2i(0, y * cell_size.y))
		var to = to_local(Vector2i(grid_size.x * cell_size.x, y * cell_size.y))
		draw_line(from, to, Color.DARK_GRAY, 2.0)


func move_character():
	var next_point = point_path[0]
	
	# If player is close to point_path 0, then move to next point
	if source.global_position.distance_to(point_path[0]) < 10:
		if (point_path.size() > 1):
			next_point = point_path[1];
		else:
			print("no next point, monster is probably overlapping with player")
		
	var direction = (next_point - source.global_position).normalized()
	source.velocity = direction * speed
	source.move_and_slide()

func _process(delta):
	start = to_cell_ids(source.global_position)
	end = to_cell_ids(target.global_position)
	update_path()
	move_character()
	queue_redraw()

func _draw():
	if show_grid:
		draw_grid()
		fill_walls()

	# Show the start and end on the grid	
	if show_path:
		draw_rect(Rect2(to_local(start * cell_size), cell_size), Color.GREEN_YELLOW)
		draw_rect(Rect2(to_local(end * cell_size), cell_size), Color.ORANGE_RED)

