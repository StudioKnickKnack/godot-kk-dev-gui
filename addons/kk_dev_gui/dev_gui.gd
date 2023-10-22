extends VBoxContainer
class_name DevGUI

var _controls: Dictionary = {}

static var _instance: DevGUI

static func label(text: String) -> void:
	if (_instance == null):
		return
	var l = _instance._get_or_create_control(text, Label.new) as Label
	l.text = text
	
func _get_or_create_control(id: String, ctor: Callable) -> Control:
	var c = _controls.get(id) as Control
	if (c == null):
		c = ctor.call() as Control
		c.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		_controls[id] = c
		add_child(c)
		print("Created control ", c, "added at path ", get_path_to(c))
	return c
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if (_instance != null):
		queue_free()
	_instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for c in _controls.values():
		c.queue_free()
	_controls.clear()
