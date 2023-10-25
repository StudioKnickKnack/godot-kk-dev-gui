extends VBoxContainer
class_name DevGUI

var _labels: Dictionary = {}
var _labels_reuse: Dictionary = {}
var _labels_next_seq_id: int = 0

static var _instance: DevGUI

static func label(text: String) -> void:
	if (_instance == null):
		return
	var id = str(_instance._labels_next_seq_id)
	_instance._labels_next_seq_id = _instance._labels_next_seq_id + 1
	var l = _instance._get_or_create_label(id)
	l.text = text

func _get_or_create_label(id: String) -> Label:
	var l = _labels_reuse.get(id) as Label
	if (l == null):
		l = Label.new()
		l.name = id
		l.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		add_child(l)
		print("Created label ", l, " with id ", id, " added at path ", get_path_to(l))
	else:
		_labels_reuse.erase(id)
	_labels[id] = l
	return l
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if (_instance != null):
		queue_free()
	_instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for l in _labels_reuse.values():
		l.queue_free()
	var ll = _labels_reuse
	_labels_reuse = _labels
	_labels = ll
	_labels.clear()
	_labels_next_seq_id = 0
