extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(delta)
	
	var deg_y:float = self.rotation_degrees.y
	DevGUI.label(str("y: ", deg_y))
	if (deg_y < 0):
		DevGUI.label(str("The value (", deg_y, ") is negative"))
