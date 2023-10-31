extends VBoxContainer
class_name DevGUI

var _parent_stack: Array[Control] = [self]

var _labels: Dictionary = {}
var _labels_reuse: Dictionary = {}
var _labels_next_seq_id: int = 0

var _buttons: Dictionary = {}
var _buttons_reuse: Dictionary = {}
var _buttons_clicked: Dictionary = {}
var _buttons_clicked_prev: Dictionary = {}
var _buttons_next_seq_id: int = 0

var _spacings: Dictionary = {}
var _spacings_reuse: Dictionary = {}
var _spacings_next_seq_id: int = 0

var _windows: Dictionary = {}
var _windows_reuse: Dictionary = {}
var _windows_next_seq_id: int = 0


static var _instance: DevGUI

static func label(text: String) -> void:
	if (_instance == null):
		return
	var id = str("label_", _instance._labels_next_seq_id)
	_instance._labels_next_seq_id = _instance._labels_next_seq_id + 1
	var l = _instance._get_or_create_label(id)
	l.text = text

static func button(text: String) -> bool:
	if (_instance == null):
		return false
	var id = str("button_", _instance._buttons_next_seq_id)
	_instance._buttons_next_seq_id = _instance._buttons_next_seq_id + 1
	var b = _instance._get_or_create_button(id)
	b.text = text
	return _instance._buttons_clicked_prev.has(id)

static func spacing() -> void:
	if (_instance == null):
		return
	var id = str("spacing_", _instance._spacings_next_seq_id)
	_instance._spacings_next_seq_id = _instance._spacings_next_seq_id + 1
	var s = _instance._get_or_create_spacing(id)

static func begin_window() -> bool:
	if (_instance == null):
		return false
	
	var id = str("window_", _instance._windows_next_seq_id)
	_instance._windows_next_seq_id = _instance._windows_next_seq_id + 1
	var w = _instance._get_or_create_window(id)
	_instance._parent_stack.push_front(w)

	return true

static func end_window() -> void:
	if (_instance == null):
		return
	_instance._parent_stack.pop_front()

func _get_or_create_label(id: String) -> Label:
	var l = _labels_reuse.get(id)
	if (l == null):
		l = Label.new()
		l.name = id
		l.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		_parent_stack.front().add_child(l)
		print("Created label ", l, " with id ", id, " added at path ", get_path_to(l))
	else:
		_labels_reuse.erase(id)
	_labels[id] = l
	return l

func _get_or_create_button(id: String) -> Button:
	var b = _buttons_reuse.get(id)
	if (b == null):
		b = Button.new()
		b.name = id
		b.pressed.connect(func(): _buttons_clicked[id] = true)
		b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		_parent_stack.front().add_child(b)
		print("Created button ", b, " with id ", id, " added at path ", get_path_to(b))
	else:
		_buttons_reuse.erase(id)
	_buttons[id] = b
	return b

func _get_or_create_spacing(id: String) -> Container:
	var s = _spacings_reuse.get(id)
	if (s == null):
		s = Container.new()
		s.name = id
		s.custom_minimum_size = Vector2(16, 16)
		_parent_stack.front().add_child(s)
		print("Created spacing ", s, " with id ", id, " added at path ", get_path_to(s))
	else:
		_spacings_reuse.erase(id)
	_spacings[id] = s
	return s

func _get_or_create_window(id: String) -> Container:
	var w = _windows_reuse.get(id)
	if (w == null):
		w = PanelContainer.new()
		var c = VBoxContainer.new()
		w.add_child(c)
		w.name = id
		_parent_stack.front().add_child(w)
		print("Created window ", w, " with id ", id, " added at path ", get_path_to(w))
	else:
		_windows_reuse.erase(id)
	_windows[id] = w
	return w.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	if (_instance != null):
		queue_free()
		return
	_instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_parent_stack.clear()
	_parent_stack.push_front(self)

	for l in _labels_reuse.values():
		l.queue_free()
	var ll = _labels_reuse
	_labels_reuse = _labels
	_labels = ll
	_labels.clear()
	_labels_next_seq_id = 0

	for b in _buttons_reuse.values():
		b.queue_free()
	var bb = _buttons_reuse
	_buttons_reuse = _buttons
	_buttons = bb
	_buttons.clear()
	_buttons_next_seq_id = 0
	var bc = _buttons_clicked_prev
	_buttons_clicked_prev = _buttons_clicked
	_buttons_clicked = bc
	_buttons_clicked.clear()

	for s in _spacings_reuse.values():
		s.queue_free()
	var ss = _spacings_reuse
	_spacings_reuse = _spacings
	_spacings = ss
	_spacings.clear()
	_spacings_next_seq_id = 0

	for w in _windows_reuse.values():
		w.queue_free()
	var ww = _windows_reuse
	_windows_reuse = _windows
	_windows = ww
	_windows.clear()
	_windows_next_seq_id = 0

