extends Node2D

var canInteract = false;
var Pickup = preload("res://entities/pickup.tscn");
var Milk = preload("res://assets/milk.png");
var Beer = preload("res://assets/beer.png");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && canInteract:
		var rando = randi_range(0, 1);
		var pickup = Pickup.instantiate() as RigidBody2D;
		var tex;
		match rando:
			0:
				tex = Milk;
			1:
				tex = Beer;

		var sprite = pickup.get_node("Sprite2D") as Sprite2D;
		sprite.texture = tex;
		pickup.position = global_position + Vector2(16, 16);
		# pickup.apply_force(Vector2(1, 0));
		get_parent().add_child(pickup);
		print("Fridge");

func _on_area_2d_body_entered(body):
	canInteract = true;

func _on_area_2d_body_exited(body):
	canInteract = false;
