####################################################################################
##                          This file is part of GDTask.                          ##
##                  https://github.com/ProgrammerOnCoffee/GDTask                  ##
####################################################################################
## Copyright (c) 2026 ProgrammerOnCoffee.                                         ##
##                                                                                ##
## Permission is hereby granted, free of charge, to any person obtaining a copy   ##
## of this software and associated documentation files (the "Software"), to deal  ##
## in the Software without restriction, including without limitation the rights   ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      ##
## copies of the Software, and to permit persons to whom the Software is          ##
## furnished to do so, subject to the following conditions:                       ##
##                                                                                ##
## The above copyright notice and this permission notice shall be included in all ##
## copies or substantial portions of the Software.                                ##
##                                                                                ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  ##
## SOFTWARE.                                                                      ##
####################################################################################

@tool
extends EditorPlugin

enum Feature {
	## Save status indicator.
	FEATURE_STATUS_INDICATOR = 0b1,
	## Task hue editor.
	FEATURE_TASK_HUE_EDITOR = 0b10,
	## Task notes editor.
	FEATURE_TASK_NOTES = 0b100,
	## Task tag editor
	FEATURE_TASK_TAGS = 0b1000,
	## Sub-tasks.
	FEATURE_SUB_TASKS = 0b10000,
	## UI animations.
	FEATURE_UI_ANIMATIONS = 0b100000
}

## If [code]true[/code], the plugin has been loaded.
var loaded := false
## If [code]true[/code], data is up to date.
var saved := true:
	set(value):
		if autosave_timer:
			# Start/restart autosave timer
			if not value:
				if autosave_timer.time_left:
					autosave_timer.stop()
				autosave_timer.start(autosave_delay)
			
			if saved != value:
				if features & Feature.FEATURE_STATUS_INDICATOR:
					# Transition to new status icon
					var from_icon := status_btn.icon.get_image()
					var to_icon := EditorInterface.get_editor_theme().get_icon(
							&"StatusSuccess" if value else &"StatusError"
					, &"EditorIcons").get_image()
					var icon := from_icon.duplicate() as Image
					var size := icon.get_size()
					new_tween().tween_method(func(weight: float) -> void:
						for x in size.x:
							for y in size.y:
								icon.set_pixel(x, y, from_icon.get_pixel(x, y).lerp(to_icon.get_pixel(x, y), weight))
						status_btn.icon = ImageTexture.create_from_image(icon)
					, 0.0, 1.0, 0.25)
				else:
					# Set status indicator icon in case feature is enabled
					status_btn.icon = EditorInterface.get_editor_theme().get_icon(
							&"StatusSuccess" if value else &"StatusError"
					, &"EditorIcons")
				
				status_btn.tooltip_text = (
						"Data is saved." if value
						else "Autosave queued.\nClick to save data immediately."
				)
				saved = value
## The tasks that have been deleted in this session.
var deleted_tasks: Array[Dictionary] = []
## The array of loaded [TaskContainer]s.
var containers: Array[TaskContainer] = [TaskContainer.new()]

#region Settings & Features

## Where to add new tasks.
var add_new_at := 0
## When new tasks will be automatically opened.
var open_new := 0
## What happens after sending a task.
var post_send := 1
## The number of colors that tasks can be tagged with.
var colors := 6:
	set(value):
		# Redraw snap lines
		hue_cr.get_node(^"Lines").queue_redraw()
		for container in containers:
			for task in container.get_tasks():
				task.stylebox.border_color.h = round3(snappedf(task.stylebox.border_color.h, 1.0 / value))
		dock.get_node(^"Control/Settings/ScrollContainer/VBoxContainer/DefaultColor/SpinBox").max_value = value
		colors = value
## The default color new tasks are tagged with.
var default_color := 1
## The maximum number of tasks to store for recovery.
var task_recovery_limit := 8
## Delay (in seconds) before data is saved when [member autosaving] is enabled.
var autosave_delay := 30
## When enabled, the window will smoothly scroll through tasks instead of snapping.
var smooth_scrolling := true

## Whether or not to snap tasks' hue to the nearest
## [code]1.0 / colors[/code] when using the hue selector.
var snap_hue := true:
	set(value):
		# Redraw snap lines
		hue_cr.get_node(^"Lines").queue_redraw()
		snap_hue = value
## The bitmap of enabled features.
var features: Feature = 0b111111:
	set(value):
		status_btn.visible = value & Feature.FEATURE_STATUS_INDICATOR
		edit_vbox.get_node(^"Hue").visible = value & Feature.FEATURE_TASK_HUE_EDITOR
		edit_vbox.get_node(^"HSeparator").visible = value & Feature.FEATURE_TASK_HUE_EDITOR
		notes_edit.visible = value & Feature.FEATURE_TASK_NOTES
		edit_vbox.get_node(^"HSeparator2").visible = value & Feature.FEATURE_TASK_NOTES
		tags_hflow.visible = value & Feature.FEATURE_TASK_TAGS and tags_hflow.get_child_count()
		add_tag_le.visible = value & Feature.FEATURE_TASK_TAGS
		edit_vbox.get_node(^"HSeparator3").visible = value & Feature.FEATURE_TASK_TAGS
		edit_vbox.anchor_bottom = 0.5 if value & Feature.FEATURE_SUB_TASKS else 1.0
		if containers.size() > 1:
			containers[-1].visible = value & Feature.FEATURE_SUB_TASKS
		features = value

#endregion Settings & Features

#region Nodes

## The plugin dock.
var dock: Control
## The autosave [Timer].
var autosave_timer: Timer
## The task [VBoxContainer].
var task_vbox: VBoxContainer
## The edit task [VBoxContainer].
var edit_vbox: VBoxContainer
## The [ColorRect] in the task hue editor.
var hue_cr: ColorRect
## The task [TextEdit].
var task_edit: TextEdit
## The task notes [TextEdit].
var notes_edit: TextEdit
## The task tags [HFlowContainer].
var tags_hflow: HFlowContainer
## The add tag [LineEdit].
var add_tag_le: LineEdit
## The popup [Panel].
var popup_panel: PanelContainer

## The sort tasks [Button].
var sort_btn: Button
## The sort tasks by color [Button].
var sort_color_btn: Button
## The sort tasks by creation time [Button].
var sort_creation_btn: Button
## The sort tasks alphabetically [Button].
var sort_content_btn: Button
## The sort tasks by length [Button].
var sort_length_btn: Button
## The search tasks [LineEdit].
var search_le: LineEdit
## The [Button] that toggles the settings menu when pressed.
var settings_btn: Button
## The status [Button].
var status_btn: Button

## The back [Button].
var back_btn: Button
## The more actions [Button].
var more_btn: Button
## The new task [Button].
var new_btn: Button
## The undo delete [Button].
var undo_btn: Button
## The delete task [Button].
var delete_btn: Button
## The [Button] that duplicates the current task when pressed.
var duplicate_btn: Button
## The [Button] that shows the [member send_dialog] when pressed.
var send_btn: Button

## The send task dialog.
var send_dialog: ConfirmationDialog
## The project search [LineEdit].
var project_search_le: LineEdit
## The send dialog path [LineEdit].
var send_path_le: LineEdit
## The [Button] in the [member send_dialog] that shows
## the [member select_send_path_dialog] when pressed.
var select_send_path_btn: Button
## The select send path [EditorFileDialog].
var select_send_path_dialog: EditorFileDialog

#endregion Nodes

## Stores the result of [method EditorInterface.get_editor_theme].
var theme: Theme
## The cache of projects in the autoscan directory.
## Updated whenever the [member send_dialog] is shown.[br]
## Format: [code]Array[Project name, Result button][/code]
var _project_cache: Array[Array]
## The time that a task was last created or deleted.[br]
## Used to prevent [member TaskContainer.sort_mode] from being set to
## [enum TaskContainer.SortMode.ENABLED] while a tween is still running.
var _task_last_created_or_deleted: int
## Stores how many times each tag been used.
var _tag_count: Dictionary


func _enter_tree() -> void:
	Task.plugin = self
	TaskContainer.plugin = self
	
	# Load and instantiate the dock scene
	dock = load("res://addons/GDTask/dock.tscn").instantiate() as Control
	
	#region Store nodes
	
	# Main nodes
	task_vbox = dock.get_node(^"Control/Tasks")
	edit_vbox = task_vbox.get_node(^"Control/Edit") as VBoxContainer
	hue_cr = edit_vbox.get_node(^"Hue/ColorRect") as ColorRect
	task_edit = edit_vbox.get_node(^"Task") as TextEdit
	notes_edit = edit_vbox.get_node(^"Notes") as TextEdit
	tags_hflow = edit_vbox.get_node(^"Tags") as HFlowContainer
	add_tag_le = edit_vbox.get_node(^"AddTag") as LineEdit
	popup_panel = dock.get_node(^"Control/Popup") as PanelContainer
	
	# Header
	sort_btn = dock.get_node(^"Header/Sort") as Button
	sort_color_btn = task_vbox.get_node(^"Sort/PanelContainer/GridContainer/Color") as Button
	sort_creation_btn = task_vbox.get_node(^"Sort/PanelContainer/GridContainer/Creation") as Button
	sort_content_btn = task_vbox.get_node(^"Sort/PanelContainer/GridContainer/Content") as Button
	sort_length_btn = task_vbox.get_node(^"Sort/PanelContainer/GridContainer/Length") as Button
	search_le = dock.get_node(^"Header/Search") as LineEdit
	settings_btn = dock.get_node(^"Header/Settings") as Button
	status_btn = dock.get_node(^"Header/Status") as Button
	
	# Footer
	back_btn = dock.get_node(^"Footer/Back") as Button
	more_btn = dock.get_node(^"Footer/More") as Button
	new_btn = dock.get_node(^"Footer/New") as Button
	undo_btn = dock.get_node(^"Footer/Undo") as Button
	delete_btn = dock.get_node(^"Footer/Delete") as Button
	duplicate_btn = dock.get_node(^"Footer/More/PanelContainer/GridContainer/Duplicate") as Button
	send_btn = dock.get_node(^"Footer/More/PanelContainer/GridContainer/Send") as Button
	
	# Send
	send_dialog = send_btn.get_child(0) as ConfirmationDialog
	project_search_le = send_dialog.get_node(^"VBoxContainer/Search") as LineEdit
	send_path_le = send_dialog.get_node(^"VBoxContainer/Path/LineEdit") as LineEdit
	select_send_path_btn = send_dialog.get_node(^"VBoxContainer/Path/Select") as Button
	
	#endregion Store nodes
	
	select_send_path_dialog = EditorFileDialog.new()
	select_send_path_dialog.show_hidden_files = true
	select_send_path_dialog.size = Vector2i(1050, 700)
	select_send_path_dialog.min_size = Vector2i(492, 301)
	select_send_path_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	select_send_path_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	select_send_path_dialog.filters = PackedStringArray(["project.godot; Godot Engine Project"])
	select_send_path_dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS
	
	var control := Control.new()
	control.clip_contents = true
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	control.add_child(containers[0])
	task_vbox.get_node(^"Control").add_child(control, false, INTERNAL_MODE_BACK)
	
	autosave_timer = Timer.new()
	autosave_timer.timeout.connect(save_data)
	dock.add_child(autosave_timer)
	
	connect_signals_to_callbacks()
	update_theme()
	load_data()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)
	dock.theme_changed.connect(update_theme)
	loaded = true


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	save_data()
	dock.free()


func _unhandled_key_input(event: InputEvent) -> void:
	var event_key := event as InputEventKey
	if event_key and event_key.pressed and event_key.keycode == KEY_ESCAPE:
		var viewport := get_viewport()
		var focus_owner := viewport.gui_get_focus_owner()
		if (
				(focus_owner and dock.is_ancestor_of(focus_owner))
				or dock.is_ancestor_of(viewport.gui_get_hovered_control())
		):
			close_task()


## Connects the plugin UI's signals to callbacks.
func connect_signals_to_callbacks() -> void:
	settings_btn.toggled.connect(_on_settings_btn_toggled)
	sort_btn.toggled.connect(_on_sort_btn_toggled)
	sort_color_btn.pressed.connect(sort_tasks.bind(func(a: Task, b: Task) -> bool:
		return a.stylebox.border_color.h < b.stylebox.border_color.h)
	)
	sort_creation_btn.pressed.connect(sort_tasks.bind(func(a: Task, b: Task) -> bool:
		return a.created < b.created)
	)
	sort_content_btn.pressed.connect(sort_tasks.bind(func(a: Task, b: Task) -> bool:
		return a.text.naturalnocasecmp_to(b.text) == -1)
	)
	sort_length_btn.pressed.connect(sort_tasks.bind(func(a: Task, b: Task) -> bool:
		return a.text.length() < b.text.length())
	)
	search_le.text_changed.connect(search)
	status_btn.pressed.connect(save_data)
	
	hue_cr.gui_input.connect(_on_hue_cr_gui_input)
	hue_cr.get_node(^"Lines").draw.connect(_on_hue_cr_lines_draw)
	add_tag_le.text_submitted.connect(_on_add_tag_le_text_submitted)
	
	back_btn.pressed.connect(close_task)
	more_btn.toggled.connect(_on_more_btn_pressed)
	new_btn.pressed.connect(_on_new_btn_pressed)
	undo_btn.pressed.connect(_on_undo_btn_pressed)
	delete_btn.pressed.connect(_on_delete_btn_pressed)
	duplicate_btn.pressed.connect(_on_duplicate_btn_pressed)
	send_btn.pressed.connect(_on_send_btn_pressed)
	
	send_dialog.add_child(select_send_path_dialog)
	project_search_le.text_changed.connect(_on_project_search_le_text_changed)
	send_path_le.text_changed.connect(validate_send_path)
	select_send_path_btn.pressed.connect(_on_select_send_path_btn_pressed)
	select_send_path_dialog.file_selected.connect(_on_select_send_path_dialog_file_selected)
	send_dialog.confirmed.connect(_on_send_dialog_confirmed)
	send_dialog.visibility_changed.connect(_on_send_dialog_visiblity_changed)


## Updates the plugin dock to match the editor's theme.
func update_theme() -> void:
	theme = EditorInterface.get_editor_theme()
	Task.base_stylebox.bg_color = theme.get_color(&"background", &"Editor")
	TaskContainer.task_margin = theme.get_constant(&"separation", &"VBoxContainer")
	
	# Update stylebox bg_color of existing tasks
	for container in containers:
		for task in container.get_tasks():
			task.stylebox.bg_color = Task.base_stylebox.bg_color
	
	var panel_stylebox := theme.get_stylebox(&"panel", &"Panel").duplicate() as StyleBoxFlat
	panel_stylebox.bg_color = theme.get_color(&"dark_color_1", &"Editor")
	panel_stylebox.set_content_margin_all(TaskContainer.task_margin)
	more_btn.get_child(0).add_theme_stylebox_override(&"panel", panel_stylebox)
	task_vbox.get_node(^"Sort/PanelContainer").add_theme_stylebox_override(&"panel", panel_stylebox)
	var popup_stylebox := panel_stylebox.duplicate() as StyleBoxFlat
	var accent_color := theme.get_color(&"accent_color", &"Editor")
	popup_stylebox.border_color = accent_color
	popup_stylebox.set_border_width_all(2)
	popup_panel.add_theme_stylebox_override(&"panel", popup_stylebox)
	TaskContainer.stylebox.border_color = accent_color
	accent_color.a = 0.25
	TaskContainer.stylebox.bg_color = accent_color
	
	# Header
	sort_btn.icon = theme.get_icon(&"Sort", &"EditorIcons")
	sort_color_btn.icon = theme.get_icon(&"Theme", &"EditorIcons")
	sort_creation_btn.icon = theme.get_icon(&"Timer", &"EditorIcons")
	sort_content_btn.icon = theme.get_icon(&"FontFile", &"EditorIcons")
	sort_length_btn.icon = theme.get_icon(&"Ruler", &"EditorIcons")
	search_le.right_icon = theme.get_icon(&"Search", &"EditorIcons")
	settings_btn.icon = theme.get_icon(&"GDScript", &"EditorIcons")
	status_btn.icon = theme.get_icon(&"StatusSuccess", &"EditorIcons")
	
	edit_vbox.get_node(^"Hue/Snap").icon = theme.get_icon(&"Snap", &"EditorIcons")
	
	# Footer
	back_btn.icon = theme.get_icon(&"Back", &"EditorIcons")
	more_btn.icon = theme.get_icon(&"GuiTabMenuHl", &"EditorIcons")
	new_btn.icon = theme.get_icon(&"Add", &"EditorIcons")
	undo_btn.icon = theme.get_icon(&"UndoRedo", &"EditorIcons")
	delete_btn.icon = theme.get_icon(&"Remove", &"EditorIcons")
	duplicate_btn.icon = theme.get_icon(&"Duplicate", &"EditorIcons")
	send_btn.icon = theme.get_icon(&"Signals", &"EditorIcons")
	select_send_path_btn.icon = theme.get_icon(&"Folder", &"EditorIcons")
	
	# Tags
	var tag_theme := Theme.new()
	tag_theme.add_type(&"Button")
	tag_theme.set_icon(&"icon", &"Button", theme.get_icon(&"GuiClose", &"EditorIcons"))
	var stylebox := theme.get_stylebox(&"normal", &"Button").duplicate() as StyleBoxFlat
	stylebox.bg_color = theme.get_color(&"box_selection_fill_color", &"Editor")
	tag_theme.set_stylebox(&"hover", &"Button", stylebox)
	tag_theme.set_stylebox(&"normal", &"Button", stylebox)
	tags_hflow.theme = tag_theme
	
	update_dock_tab_icon()


## Sets the plugin dock tab icon after coloring it to match the editor's theme.
func update_dock_tab_icon() -> void:
	# set_dock_tab_icon was introduced in 4.3
	# Check engine version for compatibility with earlier versions
	if Engine.get_version_info().hex >= 0x040300:
		var icon := (load("res://addons/GDTask/icon.png") as CompressedTexture2D).get_image()
		# Color icon to match editor theme
		var settings := EditorInterface.get_editor_settings()
		var color_scheme := settings.get_setting("interface/theme/icon_and_font_color")
		var v := (
				224 if color_scheme == 2
				or (color_scheme == 0 and settings.get_setting("interface/theme/base_color").get_luminance() < 0.5)
				else 90
		) / 255.0
		for x in icon.get_width():
			for y in icon.get_height():
				var p := icon.get_pixel(x, y)
				p.v = v
				icon.set_pixel(x, y, p)
		call_deferred(&"set_dock_tab_icon", dock, ImageTexture.create_from_image(icon))


## Loads saved data and settings.
func load_data() -> void:
	var settings_panel := dock.get_node(^"Control/Settings") as Panel
	var settings_container := settings_panel.get_node(^"ScrollContainer/VBoxContainer") as VBoxContainer
	var add_new_at_btn := settings_container.get_node(^"AddNewAt/OptionButton") as OptionButton
	var open_new_btn := settings_container.get_node(^"OpenNew/OptionButton") as OptionButton
	var post_send_btn := settings_container.get_node(^"PostSend/OptionButton") as OptionButton
	var colors_sb := settings_container.get_node(^"Colors/SpinBox") as SpinBox
	var default_color_sb := settings_container.get_node(^"DefaultColor/SpinBox") as SpinBox
	var task_recovery_limit_sb := settings_container.get_node(^"TaskRecoveryLimit/SpinBox") as SpinBox
	var autosave_delay_sb := settings_container.get_node(^"AutosaveDelay/SpinBox") as SpinBox
	var smooth_scrolling_btn := settings_container.get_node(^"SmoothScrolling") as CheckButton
	var feature_status_indicator_btn := settings_container.get_node(^"FeatureStatusIndicator") as CheckButton
	var feature_hue_editor_btn := settings_container.get_node(^"FeatureHueEditor") as CheckButton
	var feature_notes_btn := settings_container.get_node(^"FeatureNotes") as CheckButton
	var feature_tags_btn := settings_container.get_node(^"FeatureTags") as CheckButton
	var feature_sub_tasks_btn := settings_container.get_node(^"FeatureSubTasks") as CheckButton
	var feature_animations_btn := settings_container.get_node(^"FeatureAnimations") as CheckButton
	var snap_hue_btn := edit_vbox.get_node(^"Hue/Snap") as Button
	
	# Load settings
	if FileAccess.file_exists("res://addons/GDTask/data.cfg"):
		var config := ConfigFile.new()
		if config.load("res://addons/GDTask/data.cfg") == OK:
			add_new_at = config.get_value("settings", "add_new_at", add_new_at)
			open_new = config.get_value("settings", "open_new", open_new)
			post_send = config.get_value("settings", "post_send", post_send)
			colors = config.get_value("settings", "colors", colors)
			default_color = config.get_value("settings", "default_color", default_color)
			task_recovery_limit = config.get_value("settings", "task_recovery_limit", task_recovery_limit)
			autosave_delay = config.get_value("settings", "autosave_delay", autosave_delay)
			smooth_scrolling = config.get_value("settings", "smooth_scrolling", smooth_scrolling)
			snap_hue = config.get_value("settings", "snap_hue", snap_hue)
			features = config.get_value("settings", "features", features)
			
			var queue: Array[Dictionary] = []
			for task in config.get_value("data", "tasks", []):
				if "hue" in task:
					task.hue = round3(task.hue)
				create_task(task)
				queue.append(task)
			
			# Search through all tasks and count how many uses each tag has
			while queue:
				var new_queue: Array[Dictionary] = []
				for task in queue:
					if "tags" in task:
						for tag in task.tags:
							if tag in _tag_count:
								_tag_count[tag] += 1
							else:
								_tag_count[tag] = 1
					if "sub_tasks" in task:
						new_queue.append_array(task.sub_tasks)
				queue = new_queue
	
	add_new_at_btn.selected = add_new_at
	open_new_btn.selected = open_new
	post_send_btn.selected = post_send
	colors_sb.value = colors
	default_color_sb.value = default_color
	task_recovery_limit_sb.value = task_recovery_limit
	autosave_delay_sb.value = autosave_delay
	smooth_scrolling_btn.button_pressed = smooth_scrolling
	snap_hue_btn.button_pressed = snap_hue
	feature_status_indicator_btn.button_pressed = features & Feature.FEATURE_STATUS_INDICATOR
	feature_hue_editor_btn.button_pressed = features & Feature.FEATURE_TASK_HUE_EDITOR
	feature_notes_btn.button_pressed = features & Feature.FEATURE_TASK_NOTES
	feature_tags_btn.button_pressed = features & Feature.FEATURE_TASK_TAGS
	feature_sub_tasks_btn.button_pressed = features & Feature.FEATURE_SUB_TASKS
	feature_animations_btn.button_pressed = features & Feature.FEATURE_UI_ANIMATIONS
	
	if loaded:
		return
	
	# Connect settings signals to callbacks
	
	## Calls [method set] with the arguments reversed and sets [member saved] to false.
	var seti := func(value, property: StringName) -> void:
		set(property, value)
		saved = false
	
	add_new_at_btn.item_selected.connect(seti.bind(&"add_new_at"))
	open_new_btn.item_selected.connect(seti.bind(&"open_new"))
	post_send_btn.item_selected.connect(seti.bind(&"post_send"))
	colors_sb.value_changed.connect(seti.bind(&"colors"))
	default_color_sb.value_changed.connect(seti.bind(&"default_color"))
	task_recovery_limit_sb.value_changed.connect(func(value: float) -> void:
		if value:
			# Delete excess tasks
			if value < task_recovery_limit:
				for i in task_recovery_limit - value:
					deleted_tasks.pop_front()
		else:
			deleted_tasks.clear()
			undo_btn.disabled = true
		task_recovery_limit = int(value)
		saved = false
	)
	autosave_delay_sb.value_changed.connect(seti.bind(&"autosave_delay"))
	smooth_scrolling_btn.toggled.connect(seti.bind(&"smooth_scrolling"))
	snap_hue_btn.toggled.connect(seti.bind(&"snap_hue"))
	
	## Sets [param feature] to [param enabled].
	var setf := func(enabled: bool, feature: Feature) -> void:
		if enabled:
			features |= feature
		elif features & feature:
			features -= feature
		saved = false
	
	feature_status_indicator_btn.toggled.connect(setf.bind(Feature.FEATURE_STATUS_INDICATOR))
	feature_hue_editor_btn.toggled.connect(setf.bind(Feature.FEATURE_TASK_HUE_EDITOR))
	feature_notes_btn.toggled.connect(setf.bind(Feature.FEATURE_TASK_NOTES))
	feature_tags_btn.toggled.connect(setf.bind(Feature.FEATURE_TASK_TAGS))
	feature_sub_tasks_btn.toggled.connect(setf.bind(Feature.FEATURE_SUB_TASKS))
	feature_animations_btn.toggled.connect(setf.bind(Feature.FEATURE_UI_ANIMATIONS))


## Save data and settings.
func save_data() -> void:
	if not saved:
		var config := ConfigFile.new()
		config.set_value("settings", "add_new_at", add_new_at)
		config.set_value("settings", "open_new", open_new)
		config.set_value("settings", "post_send", post_send)
		config.set_value("settings", "colors", colors)
		config.set_value("settings", "default_color", default_color)
		config.set_value("settings", "task_recovery_limit", task_recovery_limit)
		config.set_value("settings", "autosave_delay", autosave_delay)
		config.set_value("settings", "smooth_scrolling", smooth_scrolling)
		config.set_value("settings", "snap_hue", snap_hue)
		config.set_value("settings", "features", features)
		
		var tasks := [] as Array[Dictionary]
		for task in containers[0].get_tasks():
			tasks.append(pack_task(task))
		
		config.set_value("data", "tasks", tasks)
		config.save("res://addons/GDTask/data.cfg")
		saved = true


## Validates that the edited task can be sent to the project at [param path].
func validate_send_path(path: String) -> void:
	var notice := send_dialog.get_node(^"VBoxContainer/Notice") as Label
	var enable := send_dialog.get_node(^"VBoxContainer/Enable") as CheckBox
	if path:
		if not DirAccess.dir_exists_absolute(path.get_base_dir()):
			send_dialog.get_ok_button().disabled = true
			notice.add_theme_color_override(&"font_color",
					theme.get_color(&"error_color", &"Editor"))
			notice.text = "• Invalid path: Directory doesn't exist"
			notice.show()
		elif not FileAccess.file_exists(path):
			send_dialog.get_ok_button().disabled = true
			notice.add_theme_color_override(&"font_color",
					theme.get_color(&"error_color", &"Editor"))
			notice.text = "• Invalid path: File doesn't exist"
			notice.show()
			enable.hide()
		elif path.get_file() != "project.godot":
			send_dialog.get_ok_button().disabled = true
			notice.add_theme_color_override(&"font_color",
					theme.get_color(&"error_color", &"Editor"))
			notice.text = "• Invalid path: File is not a project.godot file"
			notice.show()
			enable.hide()
		elif not DirAccess.dir_exists_absolute(path.get_base_dir() + "/addons/GDTask"):
			send_dialog.get_ok_button().disabled = false
			notice.add_theme_color_override(&"font_color",
					theme.get_color(&"warning_color", &"Editor"))
			notice.text = ("• GDTask doesn't exist in the selected project"
					+"\nPlugin will be duplicated from current project")
			notice.show()
			enable.show()
		else:
			send_dialog.get_ok_button().disabled = false
			notice.hide()
			enable.hide()
	else:
		notice.hide()
		enable.hide()


## Show a popup notification to the user.
func popup(text: String) -> void:
	popup_panel.get_child(0).get_child(0).text = text
	popup_panel.show()
	var show_tween := new_tween()
	show_tween.tween_property(popup_panel, ^":offset_top", -64.0, 0.75)
	show_tween.tween_property(popup_panel, ^":offset_bottom", 0.0, 0.75)
	show_tween.finished.connect(popup_panel.show)
	# Hide popup once user clicks it
	popup_panel.focus_entered.connect(func() -> void:
		var hide_tween := new_tween()
		hide_tween.tween_property(popup_panel, ^":offset_top", 0.0, 0.75)
		hide_tween.tween_property(popup_panel, ^":offset_bottom", 64.0, 0.75)
		hide_tween.finished.connect(popup_panel.hide, CONNECT_ONE_SHOT))


## Shorthand method to create a [Tween].
func new_tween() -> Tween:
	return create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_speed_scale(
			1.0 if features & Feature.FEATURE_UI_ANIMATIONS else INF).set_parallel()


## Shorthand method to round a float to three decimal places.
func round3(x: float) -> float:
	return roundf(x * 1000) * 0.001


## Implementation of [method String.containsn] to retain
## compatability with engine versions prior to 4.3.
func containsn(s: String, what: String) -> bool:
	return s.findn(what) != -1


## Shorthand method to tween a control to one side.[br]
## An existing [param tween] can be provided instead of creating a new one.
func tween_to_side(control: Control, anchor_left: int, tween: Tween = new_tween()) -> Tween:
	more_btn.button_pressed = false
	tween.tween_property(control, ^":anchor_left", anchor_left, 0.75)
	tween.tween_property(control, ^":anchor_right", anchor_left + 1.0, 0.75)
	tween.tween_property(control, ^":modulate:a", 0.5 if anchor_left else 1.0, 0.75)
	return tween


## Hides all [Task]s that don't contain [param query].
func search(query: String) -> void:
	update_dock_tab_icon()
	if query:
		# Hide sort and filters
		sort_btn.button_pressed = false
		sort_btn.disabled = true
	else:
		sort_btn.disabled = false
	
	for task in containers[-1].get_tasks():
		task.visible = (
				# No search query, show all tasks
				not query
				# Query is in task
				or containsn(task.text, query)
				# Query is in task notes
				or (features & Feature.FEATURE_TASK_NOTES and containsn(task.notes, query))
		)
		
		# If hidden, search tags
		if not task.visible and features & Feature.FEATURE_TASK_TAGS:
			for tag in task.tags:
				if containsn(tag, query):
					task.visible = true
					break
		
		# If still hidden, search sub-tasks
		if not task.visible and features & Feature.FEATURE_SUB_TASKS:
			var queue := task.sub_tasks
			while queue and not task.visible:
				var new_queue: Array[Dictionary] = []
				for sub_task in queue:
					if (
						# Query is in sub-task
						containsn(sub_task.text, query)
						# Query is in sub-task notes
						or (
							features & Feature.FEATURE_TASK_NOTES
							and "notes" in sub_task and containsn(sub_task.notes, query)
						)
					):
						task.visible = true
						new_queue.clear()
						break
					elif features & Feature.FEATURE_TASK_TAGS and "tags" in sub_task:
						# Search sub-task tags
						for tag in sub_task.tags:
							if containsn(tag, query):
								task.visible = true
								new_queue.clear()
								break
					
					# Search sub-sub-tasks if match still not found
					if not task.visible and "sub_tasks" in sub_task:
						new_queue.append_array(sub_task.sub_tasks)
				queue = new_queue
	containers[-1].queue_sort()


## Add a tag button to the tags [HFlowContainer].
func add_tag_button(tag: String) -> void:
	var button := Button.new()
	button.icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	button.button_down.connect(remove_tag_button.bind(button))
	button.text = tag
	
	tags_hflow.add_child(button)
	tags_hflow.visible = true
	for other_btn in tags_hflow.get_children() as Array[Button]:
		if other_btn.text.nocasecmp_to(button.text) == -1:
			tags_hflow.move_child(button, other_btn.get_index() + 1)
			break


## Remove a tag button from the tags [HFlowContainer].
func remove_tag_button(button: Button) -> void:
	tags_hflow.visible = tags_hflow.get_child_count() > 1
	button.queue_free()
	var edited_task_tags := containers[-2].edited_task.tags
	edited_task_tags.remove_at(edited_task_tags.rfind(button.text))
	# Decrement tag use counter
	_tag_count[button.text] -= 1
	if not _tag_count[button.text]:
		_tag_count.erase(button.text)
	saved = false


#region Tasks


## Create a new task.
func create_task(data: Dictionary = {
	"text": "New Task",
	# Multiply result by 10 before casting to int for sub-second precision
	"created": int(Time.get_unix_time_from_system() * 10),
	# Default color
	"hue": round3(1.0 / colors * (default_color - 1)),
}) -> Task:
	var task := Task.new()
	task.text = data.text
	task.size.x = containers[-1].size.x
	task.created = data.created
	if "hue" in data:
		task.stylebox.border_color.h = round3(data.hue)
	if "notes" in data:
		task.notes = data.notes
	if "tags" in data:
		data.tags.sort()
		task.tags = data.tags
	if "sub_tasks" in data:
		task.sub_tasks = data.sub_tasks
	containers[-1].add_child(task)
	return task


## Smoothly fade in a [Task].
func add_task(task: Task) -> void:
	saved = false
	var time := Time.get_ticks_msec()
	_task_last_created_or_deleted = time
	
	var container := task.get_parent() as TaskContainer
	container.sort_mode = TaskContainer.SortMode.DISABLED
	
	task.self_modulate.a = 0.0
	var tween := new_tween()
	tween.tween_property(task, ^":self_modulate:a", 1.0, 0.5)
	
	if add_new_at == 1:
		# Top - Add above all other tasks
		if container.get_child_count() > 1:
			# This isn't the only task
			container.move_child(task, 0)
			
			# Move all other tasks down
			for other_task in container.get_tasks():
				if other_task != task:
					other_task.target += task.size.y + TaskContainer.task_margin
					tween.tween_property(other_task, ^":position:y", other_task.target, 0.5)
		
		task.position.y = -task.size.y - TaskContainer.task_margin
		tween.tween_property(task, ^":position:y", 0.0, 0.5)
	elif add_new_at == 2 or add_new_at == 3:
		if container.get_child_count() > 1:
			var tasks := container.get_tasks()
			# This isn't the only task
			if add_new_at == 2:
				# Below Color - Add below the last task that
				# has a hue lesser than or equal to task's hue
				## The first task with a hue <= to that of the new task.
				var upper_task: Task
				# Reverse searching in order to search from bottom to top
				tasks.reverse()
				for other_task in tasks:
					if other_task != task and (
							other_task.stylebox.border_color.h
							<= task.stylebox.border_color.h
					):
						upper_task = other_task
						# Since searching is reversed, all other tasks will be higher up, so break
						break
				
				if upper_task:
					task.target = upper_task.target + upper_task.size.y + TaskContainer.task_margin
					container.move_child(task, upper_task.get_index() + 1)
					for other_task in tasks:
						# Move all tasks that are lower than this task down
						if other_task != task and other_task.get_index() > task.get_index():
							other_task.target += task.size.y + TaskContainer.task_margin
							tween.tween_property(other_task, ^":position:y", other_task.target, 0.5)
				else:
					# No upper task, add to top
					container.move_child(task, 0)
					# Move all other tasks down
					for other_task in tasks:
						if other_task != task:
							other_task.target += task.size.y + TaskContainer.task_margin
							tween.tween_property(other_task, ^":position:y", other_task.target, 0.5)
			elif add_new_at == 3:
				# Above Color - Add above the first task that
				# has a hue greater than or equal to task's hue
				## The first task with a hue >= to that of the new task.
				var lower_task: Task
				for other_task in tasks:
					if other_task == task:
						continue
					
					@warning_ignore("unassigned_variable")
					if not lower_task:
						if (
								other_task.stylebox.border_color.h
								>= task.stylebox.border_color.h
								or is_equal_approx(
										other_task.stylebox.border_color.h,
										task.stylebox.border_color.h
								)
						):
							lower_task = other_task
						else:
							task.target += other_task.size.y + TaskContainer.task_margin
					
					if lower_task:
						other_task.target += task.size.y + TaskContainer.task_margin
						tween.tween_property(other_task, ^":position:y", other_task.target, 0.5)
				
				if lower_task:
					container.move_child(task, lower_task.get_index())
		
		task.position = Vector2(-task.size.x, task.target)
		tween.tween_property(task, ^":position:x", 0.0, 0.5)
	else:
		# Bottom - Add below all other tasks
		if container.get_child_count() > 1:
			# This isn't the only task
			var last_task := container.get_child(-2) as Task
			task.target = last_task.target + last_task.size.y + TaskContainer.task_margin
		
		task.position.y = task.target + task.size.y + TaskContainer.task_margin
		tween.tween_property(task, ^":position:y", task.target, 0.5)
	
	await tween.finished
	# Enable sorting if no other creations or deletions have occurred
	if container and time == _task_last_created_or_deleted:
		container.sort_mode = TaskContainer.SortMode.ENABLED


## Edit the task or sub-task at the given [param index].
func edit_task(task: Task) -> void:
	containers[-1].sort_mode = TaskContainer.SortMode.DISABLED
	containers[-1].process_mode = PROCESS_MODE_DISABLED
	containers[-1].edited_task = task
	
	var control := Control.new()
	control.clip_contents = true
	control.modulate.a = 0.5
	control.anchor_left = 1.0
	control.anchor_top = 0.5
	control.anchor_right = 2.0
	control.anchor_bottom = 1.0
	control.offset_top = TaskContainer.task_margin
	
	var container := TaskContainer.new()
	if not features & Feature.FEATURE_SUB_TASKS:
		container.hide()
	containers.append(container)
	for sub_task in task.sub_tasks:
		create_task(sub_task)
	control.add_child(container)
	task_vbox.get_node(^"Control").add_child(control, false, INTERNAL_MODE_BACK)
	
	# Set sorting to once so that container won't sort every frame while being tweened
	container.set_deferred(&"sort_mode", TaskContainer.SortMode.ONCE)
	var tween := tween_to_side(control, 0)
	tween.finished.connect(container.set.bind(&"sort_mode", TaskContainer.SortMode.ENABLED))
	tween_to_side(containers[-2].get_parent(), -1, tween)
	
	var indicator := hue_cr.get_node(^"Indicator") as ColorRect
	var hue := round3(task.stylebox.border_color.h)
	
	if containers.size() == 2:
		tween_to_side(edit_vbox, 0, tween)
	else:
		# Save currently edited task hue, text, and notes
		containers[-3].edited_task.text = task_edit.text
		containers[-3].edited_task.notes = notes_edit.text
		containers[-3].edited_task.stylebox.border_color.h = round3(indicator.anchor_left)
		
		# Duplicate edit_vbox and transition from old data to new
		var duplicate_vbox := edit_vbox.duplicate(0) as VBoxContainer
		edit_vbox.anchor_left = 1.0
		edit_vbox.anchor_right = 2.0
		edit_vbox.add_sibling(duplicate_vbox)
		tween_to_side(duplicate_vbox, -1, tween)
		tween.finished.connect(duplicate_vbox.free)
		tween_to_side(edit_vbox, 0, tween)
	
	search(search_le.text)
	
	task_edit.text = task.text
	# Select text if the task is new for faster editing
	if task.text == "New Task":
		task_edit.select_all()
	notes_edit.text = task.notes
	indicator.anchor_left = hue
	indicator.anchor_right = hue
	for tag in tags_hflow.get_children():
		tag.queue_free()
	if task.tags:
		for tag in task.tags:
			add_tag_button(tag)
	else:
		tags_hflow.hide()
	
	task_edit.grab_focus.call_deferred()
	var line := task_edit.get_line_count() - 1
	task_edit.set_caret_line(line)
	task_edit.set_caret_column(task_edit.get_line(line).length())
	
	back_btn.disabled = false
	more_btn.disabled = false
	delete_btn.disabled = false


## Stop editing the edited task or sub-task and move up in the task tree.
func close_task() -> void:
	if containers.size() > 1:
		var container := containers.pop_back() as TaskContainer
		container.process_mode = PROCESS_MODE_DISABLED
		container.sort_mode = TaskContainer.SortMode.DISABLED
		containers[-1].sort_mode = TaskContainer.SortMode.ENABLED
		containers[-1].process_mode = PROCESS_MODE_ALWAYS
		
		search(search_le.text)
		var tween := tween_to_side(containers[-1].get_parent(), 0)
		tween_to_side(container.get_parent(), 1, tween)
		tween.finished.connect(container.get_parent().queue_free)
		
		var edited_task := containers[-1].edited_task
		containers[-1].edited_task = null
		
		#region Save changed data
		# Hue
		var indicator := hue_cr.get_node(^"Indicator") as ColorRect
		var new_hue := indicator.anchor_left
		if not is_equal_approx(new_hue, edited_task.stylebox.border_color.h):
			edited_task.stylebox.border_color.h = round3(new_hue)
			saved = false
		# Text
		var new_text := task_edit.text
		if edited_task.text != new_text:
			edited_task.text = new_text
			saved = false
		# Notes
		var new_notes := notes_edit.text
		if edited_task.notes != new_notes:
			edited_task.notes = new_notes
			saved = false
		# Sub-tasks
		var new_sub_tasks: Array[Dictionary]
		for task in container.get_tasks():
			new_sub_tasks.append(pack_task(task))
		if edited_task.sub_tasks != new_sub_tasks:
			edited_task.sub_tasks = new_sub_tasks
			saved = false
		#endregion Save changed data
		
		# If going back to the root of all tasks
		if containers.size() == 1:
			tween_to_side(edit_vbox, 1, tween)
			back_btn.disabled = true
			more_btn.disabled = true
			delete_btn.disabled = true
		else:
			# Duplicate edit_vbox and transition from old data to new
			var duplicate_vbox := edit_vbox.duplicate(0) as VBoxContainer
			edit_vbox.anchor_left = -1.0
			edit_vbox.anchor_right = 0.0
			edit_vbox.add_sibling(duplicate_vbox)
			tween_to_side(duplicate_vbox, 1, tween)
			tween.finished.connect(duplicate_vbox.free)
			tween_to_side(edit_vbox, 0, tween)
			
			task_edit.text = containers[-2].edited_task.text
			notes_edit.text = containers[-2].edited_task.notes
			var hue := round3(containers[-2].edited_task.stylebox.border_color.h)
			indicator.anchor_left = hue
			indicator.anchor_right = hue
			
			task_edit.grab_focus.call_deferred()
			var line := task_edit.get_line_count() - 1
			task_edit.set_caret_line(line)
			task_edit.set_caret_column(task_edit.get_line(line).length())
			
			for tag in tags_hflow.get_children():
				tag.queue_free()
			for tag in containers[-2].edited_task.tags:
				add_tag_button(tag)


## Delete a task.
func delete_task(task: Task) -> void:
	if task_recovery_limit:
		# Store task data
		if deleted_tasks.size() < task_recovery_limit:
			undo_btn.disabled = false
		else:
			deleted_tasks.pop_front()
		deleted_tasks.append(pack_task(task))
	
	var time := Time.get_ticks_msec()
	_task_last_created_or_deleted = time
	
	saved = false
	var container := task.get_parent() as TaskContainer
	container.sort_mode = TaskContainer.SortMode.DISABLED
	var tween := new_tween()
	# Smoothly make task disappear
	tween.tween_property(task, ^":self_modulate:a", 0.0, 0.5)
	tween.tween_property(task, ^":position:x", task.size.x, 0.5)
	# Smoothly move lower tasks up to fill gap
	for i in range(task.get_index() + 1, container.get_child_count()):
		var other_task := container.get_child(i) as Task
		var target := other_task.target - task.size.y - TaskContainer.task_margin
		other_task.target = target
		tween.tween_property(other_task, ^":position:y", target, 0.5)
	await tween.finished
	task.free()
	
	if time == _task_last_created_or_deleted:
		container.sort_mode = TaskContainer.SortMode.ENABLED


## Packs a [Task] into a [Dictionary].
func pack_task(task: Task) -> Dictionary:
	var data := {
		"text": task.text,
		"created": task.created,
	}
	if task.stylebox.border_color.h:
		data.hue = round3(task.stylebox.border_color.h)
	if task.notes:
		data.notes = task.notes
	if task.sub_tasks:
		data.sub_tasks = task.sub_tasks
	if task.tags:
		data.tags = task.tags
	return data


## Sort tasks with a custom sorter method.
func sort_tasks(method: Callable) -> void:
	sort_btn.button_pressed = false
	if containers[-1].get_child_count():
		var tasks := containers[-1].get_tasks()
		tasks.sort_custom(method)
		# If sorting didn't rearrange any tasks
		if tasks == containers[-1].get_tasks():
			return
		
		var cumulative_y := 0.0
		var tween := new_tween()
		containers[-1].sort_mode = TaskContainer.SortMode.DISABLED
		for task in tasks:
			task.target = cumulative_y
			tween.tween_property(task, ^":position:y", cumulative_y, 0.5)
			cumulative_y += task.size.y + TaskContainer.task_margin
		for i in tasks.size():
			containers[-1].move_child(tasks[i], i)
		await tween.finished
		containers[-1].sort_mode = TaskContainer.SortMode.ENABLED
		saved = false


#endregion Tasks


#region Callbacks


## Toggles the sort menu's visibility.
func _on_sort_btn_toggled(toggled_on: bool) -> void:
	var sort_control := task_vbox.get_node(^"Sort") as Control
	var tween := new_tween()
	tween.tween_property(sort_control, ^":custom_minimum_size:y",
			sort_control.get_child(0).size.y if toggled_on else 0.0, 0.5)
	tween.tween_property(sort_control, ^":modulate:a", 1.0 if toggled_on else 0.5, 0.5)


## Toggles the settings menu's visiblity.
func _on_settings_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		sort_btn.button_pressed = false
		sort_btn.disabled = true
		search_le.editable = false
		back_btn.disabled = true
		more_btn.disabled = true
		new_btn.disabled = true
		undo_btn.disabled = true
		delete_btn.disabled = true
		containers[-1].sort_mode = TaskContainer.SortMode.DISABLED
	else:
		sort_btn.disabled = false
		search_le.editable = true
		back_btn.disabled = containers.size() == 1
		more_btn.disabled = containers.size() == 1
		new_btn.disabled = false
		undo_btn.disabled = not deleted_tasks.size()
		delete_btn.disabled = containers.size() == 1
		containers[-1].sort_mode = TaskContainer.SortMode.ENABLED
	
	var tween := tween_to_side(task_vbox, 1 if toggled_on else 0)
	tween_to_side(dock.get_node(^"Control/Settings"), 0 if toggled_on else -1, tween)


## Updates the edited task's hue.
func _on_hue_cr_gui_input(event: InputEvent) -> void:
	if containers.size() > 1:
		var event_mouse := event as InputEventMouse
		if event_mouse and event_mouse.button_mask & MOUSE_BUTTON_LEFT:
			var hue := clampf(event_mouse.position.x / hue_cr.size.x, 0.0, 1.0)
			if snap_hue:
				hue = snappedf(hue, 1.0 / colors)
			hue = round3(hue)
			var indicator := hue_cr.get_node(^"Indicator") as ColorRect
			indicator.anchor_left = hue
			indicator.anchor_right = hue


## Draws snapping lines on the task hue editor.
func _on_hue_cr_lines_draw() -> void:
	if snap_hue:
		var lines := hue_cr.get_node(^"Lines") as Control
		for i in colors + 1:
			var x := lines.size.x / colors * i
			lines.draw_line(Vector2(x, 0.0), Vector2(x, lines.size.y),
					Color(1.0, 1.0, 1.0, 0.4), 2.0)


## Adds a tag to the edited task.
func _on_add_tag_le_text_submitted(new_text: String) -> void:
	if new_text:
		new_text = new_text.to_snake_case()
		if not new_text in containers[-2].edited_task.tags:
			add_tag_le.clear()
			containers[-2].edited_task.tags.append(new_text)
			# Increment tag use counter
			if new_text in _tag_count:
				_tag_count[new_text] += 1
			else:
				_tag_count[new_text] = 1
			saved = false
			add_tag_button(new_text)


## Toggles the extra task actions menu's visiblity.
func _on_more_btn_pressed(toggled_on: bool) -> void:
	var more_panel := more_btn.get_child(0) as PanelContainer
	if toggled_on:
		more_panel.show()
	var tween := new_tween()
	tween.tween_property(more_panel, ^":offset_bottom", -8.0 if toggled_on else 0.0, 0.25)
	tween.tween_property(more_panel, ^":modulate:a", 1.0 if toggled_on else 0.0, 0.25)
	if not toggled_on:
		tween.finished.connect(func() -> void:
			if more_panel.modulate.a == 0.0:
				more_panel.hide(), CONNECT_DEFERRED)


## Adds a new task.
func _on_new_btn_pressed() -> void:
	if open_new == 0 or (open_new == 1 and containers.size() == 1):
		# Edit new task
		# Disable container sorting so that task isn't immediately visible
		containers[-1].sort_mode = TaskContainer.SortMode.DISABLED
		var task := create_task()
		task.self_modulate.a = 0.0
		
		edit_task(task)
		# Wait for new container to be closed
		await containers[-1].tree_exiting
		# If task hasn't been deleted yet
		if is_instance_valid(task):
			add_task(task)
	else:
		add_task(create_task())


## Recovers the most recently deleted task.
func _on_undo_btn_pressed() -> void:
	var task_data := deleted_tasks.pop_back() as Dictionary
	# Disable undo button if there are no more deleted tasks to recover.
	undo_btn.disabled = not deleted_tasks.size()
	add_task(create_task(task_data))


## Deletes the edited task.
func _on_delete_btn_pressed() -> void:
	var task := containers[-2].edited_task
	if task.self_modulate.a:
		# Wait before deleting to give the edit_vbox time to close
		get_tree().create_timer(0.5).timeout.connect(delete_task.bind(task))
		close_task()
	else:
		# If task was just created and hasn't been shown yet,
		# close before deleting to store data in deleted_tasks
		close_task()
		delete_task(task)


## Duplicates the edited task.
func _on_duplicate_btn_pressed() -> void:
	saved = false
	var time := Time.get_ticks_msec()
	_task_last_created_or_deleted = time
	var edited_task := containers[-2].edited_task
	close_task()
	
	var task := create_task(pack_task(edited_task))
	var container := task.get_parent() as TaskContainer
	container.sort_mode = TaskContainer.SortMode.DISABLED
	container.move_child(task, edited_task.get_index() + 1)
	task.target = edited_task.target + edited_task.size.y + TaskContainer.task_margin
	# Wait before fading in to give the editor time to close
	await get_tree().create_timer(0.5).timeout
	
	# Smoothly make task appear.
	task.show_behind_parent = true
	task.position.y = task.target - task.size.y - TaskContainer.task_margin
	var tween := new_tween()
	tween.tween_property(task, ^":position:y", task.target, 0.5)
	# Move lower tasks down
	for other_task in container.get_tasks():
		if other_task != task and other_task.get_index() > task.get_index():
			other_task.target += task.size.y + TaskContainer.task_margin
			tween.tween_property(other_task, ^":position:y", other_task.target, 0.5)
	await tween.finished
	task.show_behind_parent = false
	
	if time == _task_last_created_or_deleted:
		container.sort_mode = TaskContainer.SortMode.ENABLED


## Shows the [member send_dialog].
func _on_send_btn_pressed() -> void:
	more_btn.button_pressed = false
	send_dialog.show()
	if not project_search_le.text:
		_on_project_search_le_text_changed("")


## Shows each project in [member _project_cache] that matches [param new_text].
func _on_project_search_le_text_changed(new_text: String) -> void:
	for array in _project_cache:
		# Show button if query is in project name
		array[1].visible = not new_text or (new_text and containsn(array[0], new_text))


## Shows the [member select_send_path_dialog].
func _on_select_send_path_btn_pressed() -> void:
	var current_path := send_path_le.text
	select_send_path_dialog.current_path = (
			current_path if current_path
			and DirAccess.dir_exists_absolute(current_path.get_base_dir())
			else EditorInterface.get_editor_settings().get_setting(
					"filesystem/directories/autoscan_project_path") + "/")
	select_send_path_dialog.show()


## Sets the send path to the selected [param path].
func _on_select_send_path_dialog_file_selected(path: String) -> void:
	send_path_le.text = path
	validate_send_path(path)


## Closes the [member send_dialog] and sends the edited task to the selected project.
func _on_send_dialog_confirmed() -> void:
	# Close task after storing it to save changes
	var task := containers[-2].edited_task
	if post_send:
		close_task()
	
	# Get the data for the task being sent
	var data := pack_task(task)
	var path := send_path_le.text.get_base_dir().path_join("addons/GDTask/")
	var config := ConfigFile.new()
	if DirAccess.dir_exists_absolute(path):
		if FileAccess.file_exists(path + "data.cfg"):
			config.load(path + "data.cfg")
			var tasks := config.get_value("data", "tasks", [] as Array[Dictionary]) as Array[Dictionary]
			tasks.append(data)
			config.set_value("data", "tasks", tasks)
		else:
			# Load current settings to transfer them to new project
			config.load("res://addons/GDTask/data.cfg")
			config.set_value("data", "tasks", [data] as Array[Dictionary])
	else:
		DirAccess.make_dir_recursive_absolute(path)
		
		# Copy all needed plugin files
		for file in DirAccess.get_files_at("res://addons/GDTask"):
			if file != "data.cfg":
				DirAccess.copy_absolute("res://addons/GDTask/" + file, path + file)
		
		config.load("res://addons/GDTask/data.cfg")
		config.set_value("data", "tasks", [data] as Array[Dictionary])
		
		# Enable plugin if Enable is pressed
		if (send_dialog.get_node(^"VBoxContainer/Enable") as CheckBox).button_pressed:
			var enabled_plugins := config.get_value(
					"editor_plugins", "enabled", PackedStringArray()) as PackedStringArray
			enabled_plugins.append("res://addons/GDTask/plugin.cfg")
			config.set_value("editor_plugins", "enabled", enabled_plugins)
	config.save(path + "data.cfg")
	
	popup("Successfully sent task")
	if post_send == 2:
		delete_task(task)


## Updates the [member _project_cache] when the [member send_dialog] is shown.
func _on_send_dialog_visiblity_changed() -> void:
	var results_vbox := send_dialog.get_node(^"VBoxContainer/Panel/ScrollContainer/VBoxContainer")
	if send_dialog.visible:
		var autoscan_path := EditorInterface.get_editor_settings().get_setting(
				"filesystem/directories/autoscan_project_path") as String
		
		## The current project's directory.
		var project_dir := ProjectSettings.globalize_path("res://")
		## The queue of directories to search in
		var queue := DirAccess.get_directories_at(autoscan_path)
		while queue:
			var new_queue: PackedStringArray
			for dir in queue:
				var dir_path := autoscan_path.path_join(dir)
				# If directory isn't current project's directory
				# and directory has a project.godot file
				var path := dir_path + "/project.godot"
				if dir_path != project_dir and FileAccess.file_exists(path):
					var config := ConfigFile.new()
					config.load(path)
					var project_name := config.get_value(
							"application", "config/name", "Untitled Project") as String
					var project_desc := config.get_value(
							"application", "config/description", "") as String
					
					var short_path := dir_path.substr(autoscan_path.length())
					var button := Button.new()
					button.text = project_name + " (%s)" % (
							("godot:/" if short_path.begins_with("/") else "godot://")
							+ short_path.replacen(autoscan_path, ""))
					button.tooltip_text = (project_desc + "\n" + dir_path) if project_desc else dir_path
					button.alignment = HORIZONTAL_ALIGNMENT_LEFT
					button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
					button.pressed.connect(send_path_le.set.bind(&"text", path))
					button.pressed.connect(validate_send_path.bind(path))
					
					if not project_search_le.text or not containsn(project_name, project_search_le.text):
						button.hide()
					results_vbox.add_child(button)
					_project_cache.append([project_name, button])
				else:
					# Add all subdirectories to the search queue
					for subdir in DirAccess.get_directories_at(dir_path):
						new_queue.append(dir.path_join(subdir))
			queue = new_queue
		
		# Grab focus of search bar if it is empty
		if not project_search_le.text:
			project_search_le.grab_focus()
	else:
		_project_cache.clear()
		for child in results_vbox.get_children():
			child.free()


#endregion Callbacks


## A [Label] representing a task.
##
## A [Label] representing a task.
class Task:
	extends Label
	## Stores a reference to the [b]GDTask[/b] plugin.
	static var plugin: EditorPlugin
	## Base [StyleBoxFlat] that all tasks will use.
	static var base_stylebox := StyleBoxFlat.new()
	## The offset from the grabbed task's origin
	## to the position that it was grabbed at.[br]
	## This is set when a task is grabbed.
	static var grab_offset: Vector2
	## The current global position of the mouse.[br]
	## Only updated when [member grabbed_task] is not [code]null[/code].
	static var mouse_position: Vector2
	
	## The time that the task was created.
	var created: int
	## The task's additional notes.
	var notes: String
	## The task's sub-tasks.
	var sub_tasks: Array[Dictionary]
	## The task's tags.
	var tags: PackedStringArray
	## The y position that the task is currently at or being tweened to.
	var target: float
	
	## The task's [StyleBoxFlat].
	var stylebox := base_stylebox.duplicate() as StyleBoxFlat
	## The [Tween] that is currently tweening the task.
	var tween: Tween
	
	## Stores a reference to the [TaskContainer] that this task is a child of.
	@onready var container := get_parent() as TaskContainer
	
	
	static func _static_init() -> void:
		# Initialize base_stylebox
		base_stylebox.border_blend = true
		base_stylebox.border_color = Color.from_hsv(0.0, 0.75, 1.0)
		base_stylebox.border_width_left = 8
		base_stylebox.content_margin_left = 12.0
		base_stylebox.content_margin_top = 8.0
		base_stylebox.content_margin_right = 12.0
		base_stylebox.content_margin_bottom = 8.0
	
	
	func _init() -> void:
		mouse_filter = MOUSE_FILTER_PASS
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_theme_stylebox_override(&"normal", stylebox)
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
		gui_input.connect(_on_gui_input)
	
	
	func _on_mouse_entered() -> void:
		if not container.grabbed_task and plugin.features & plugin.Feature.FEATURE_UI_ANIMATIONS:
			var stylebox_tween: Tween = plugin.new_tween()
			stylebox_tween.tween_property(stylebox, ^":border_width_left", 14, 0.3)
			stylebox_tween.tween_property(stylebox, ^":content_margin_left", 18.0, 0.3)
			stylebox_tween.tween_property(stylebox, ^":content_margin_right", 6.0, 0.3)
	
	
	func _on_mouse_exited() -> void:
		if not container.grabbed_task and plugin.features & plugin.Feature.FEATURE_UI_ANIMATIONS:
			var stylebox_tween: Tween = plugin.new_tween()
			stylebox_tween.tween_property(stylebox, ^":border_width_left", 8.0, 0.3)
			stylebox_tween.tween_property(stylebox, ^":content_margin_left", 12.0, 0.3)
			stylebox_tween.tween_property(stylebox, ^":content_margin_right", 12.0, 0.3)
	
	
	func _on_gui_input(event: InputEvent) -> void:
		var event_mouse_button := event as InputEventMouseButton
		if event_mouse_button:
			var button_index := event_mouse_button.button_index
			if button_index == MOUSE_BUTTON_LEFT or button_index == MOUSE_BUTTON_RIGHT:
				if not container.grabbed_task:
					if not event_mouse_button.pressed:
						return
					# If click was inside left border
					var x := event_mouse_button.position.x
					if x >= 0 and x <= stylebox.border_width_left:
						# Tween border color
						var old_hue := stylebox.border_color.h
						var new_hue: float = plugin.round3(
								snappedf(stylebox.border_color.h, 1.0 / plugin.colors)
								+ (+1.0 if button_index == MOUSE_BUTTON_LEFT else -1.0) / plugin.colors
						)
						if new_hue < 0.0:
							old_hue += 1.0
							new_hue += 1.0
						plugin.new_tween().tween_method(func(h: float) -> void:
							stylebox.border_color.h = h, old_hue, new_hue, 0.25)
						plugin.saved = false
					elif button_index == MOUSE_BUTTON_RIGHT:
						# Delete task
						if event_mouse_button.shift_pressed:
							plugin.delete_task(self)
						# Edit task
						else:
							plugin.edit_task(self)
					# Only allow tasks to be grabbed if there are
					# more than one and there isn't a search query
					elif container.get_child_count() > 1 and not plugin.search_le.text:
						# Grab task
						mouse_position = event_mouse_button.global_position
						grab_offset = mouse_position - global_position
						set_deferred(&"global_position", global_position)
						container.grabbed_task = self
				elif not event_mouse_button.pressed and button_index == MOUSE_BUTTON_LEFT:
					# Shrink border if mouse is outside where task is being dropped at
					if not Rect2(
							container.global_position + Vector2(0, container._drop_indicator_target),
							container.drop_indicator.size
					).has_point(mouse_position):
						container.grabbed_task._on_mouse_exited.call_deferred()
					container.grabbed_task = null
			elif event_mouse_button.pressed and self == container.grabbed_task:
				if button_index == MOUSE_BUTTON_WHEEL_UP:
					container.scroll += 128.0
				elif button_index == MOUSE_BUTTON_WHEEL_DOWN:
					container.scroll -= 128.0
			else:
				# Return so input is not set as handled
				return
			get_viewport().set_input_as_handled()
		elif self == container.grabbed_task:
			var event_mouse_motion := event as InputEventMouseMotion
			if event_mouse_motion and not is_equal_approx(event_mouse_motion.global_position.y, mouse_position.y):
				get_viewport().set_input_as_handled()
				mouse_position = event_mouse_motion.global_position
				container.queue_sort()


## A [Container] to sort [Task]s.
##
## A [Container] to sort [Task]s.
class TaskContainer:
	extends Container
	enum SortMode {
		## Sort requests will be ignored.
		DISABLED,
		## Sort requests will be accepted.
		ENABLED,
		## The next sort request will be accepted.
		ONCE,
	}
	
	## Stores a reference to the [b]GDTask[/b] plugin.
	static var plugin: EditorPlugin
	## The [StyleBoxFlat] applied to all containers' [member drop_indicator].
	static var stylebox := StyleBoxFlat.new()
	## The margin between sorted tasks.
	static var task_margin: int
	
	## The [Label] that shows where [member grabbed_task] will be placed if dropped.
	var drop_indicator := Label.new()
	## The currently grabbed task.
	var grabbed_task: Task:
		set(value):
			var time := Time.get_ticks_msec()
			_grabbed_task_last_changed = time
			var tween: Tween = plugin.new_tween()
			if value:
				_grabbed_task_index = value.get_index()
				drop_indicator.size = value.size
				drop_indicator.position.y = value.target + scroll
				_drop_indicator_target = value.target
				drop_indicator.show()
				
				if value.tween:
					value.tween.kill()
				value.tween = tween
				tween.tween_property(drop_indicator, ^":self_modulate:a", 1.0, 0.25)
				tween.tween_method(func(__: float) -> void:
					update_task_position(value), 0.0, 1.0, 0.25)
				value.top_level = true
				tween.tween_property(value, ^":scale", Vector2.ONE * 0.875, 0.25)
				tween.tween_property(value, ^":self_modulate:a", 0.75, 0.25)
				grabbed_task = value
			else:
				## The index that the task will be placed at.
				var index := 0
				for task in get_tasks():
					if task != grabbed_task and (
							not task.visible
							or _drop_indicator_target >= task.target
					):
						index += 1
				move_child(grabbed_task, index)
				# Mark as unsaved if task was moved.
				if index != _grabbed_task_index:
					plugin.saved = false
				
				if grabbed_task.tween:
					grabbed_task.tween.kill()
				grabbed_task.tween = tween
				
				grabbed_task.target = _drop_indicator_target
				tween.tween_property(drop_indicator, ^":self_modulate:a", 0.0, 0.25)
				tween.tween_property(grabbed_task, ^":scale", Vector2.ONE, 0.25)
				tween.tween_property(grabbed_task, ^":self_modulate:a", 1.0, 0.25)
				# Use set_position instead of tweening position
				# since setting top_level will reset x position
				tween.tween_method(grabbed_task.set_position,
						grabbed_task.global_position - global_position,
						Vector2(0.0, _drop_indicator_target), 0.25
				)
				
				grabbed_task.top_level = false
				grabbed_task = value
				await tween.finished
				if _grabbed_task_last_changed == time:
					drop_indicator.hide()
	## The currently edited task.
	var edited_task: Task
	
	## The container's [enum SortMode].
	var sort_mode := SortMode.ENABLED:
		set(value):
			if not sort_mode and value:
				queue_sort()
			sort_mode = value
	## The target vertical scroll.[br]
	## position.y will slowly be moved toward this if Smooth Scrolling is enabled.
	var scroll: float:
		set(value):
			if not get_child_count():
				return
			
			## The last visible task.
			var last_task := get_child(-1) as Task
			var index := -2
			while not last_task.visible and -index < get_child_count():
				last_task = get_child(index) as Task
				index -= 1
			var last_task_target := last_task.target
			
			## The maximum (actually minimum, since it is negative)
			## value that [member scroll] can be set to.[br]
			var max_scroll := (
					# Container y size since that many pixels won't need to be scrolled
					+ size.y
					# Last task target y
					- last_task_target
					# Make room for last task
					- last_task.size.y
			)
			
			if grabbed_task and (
					# Grabbed task is below all other tasks
					last_task_target + global_position.y
					< grabbed_task.global_position.y
			):
				# Make additional room for [member grabbed_task]
				max_scroll -= grabbed_task.size.y + task_margin
			
			scroll = clampf(value, minf(0.0, max_scroll), 0.0)
	
	## The index of [member grabbed_task] before it was grabbed.[br]
	## Used to tell whether or not the task was actually moved when it is released.
	var _grabbed_task_index: int
	## The time that [member grabbed_task] was last changed.[br]
	## Used to prevent [member drop_indicator] from being hidden if a label was quickly regrabbed.
	var _grabbed_task_last_changed: int
	## The y position that [member drop_indicator] is currently at or being tweened to.
	var _drop_indicator_target: float
	
	
	static func _static_init() -> void:
		stylebox.set_border_width_all(4)
		stylebox.border_blend = true
		stylebox.bg_color.a = 0.25
	
	
	func _init() -> void:
		drop_indicator.hide()
		drop_indicator.text = "Drop Here"
		drop_indicator.self_modulate.a = 0.0
		drop_indicator.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		drop_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		drop_indicator.add_theme_stylebox_override(&"normal", stylebox)
		
		set_anchors_and_offsets_preset(PRESET_FULL_RECT)
		sort_children.connect(sort)
		gui_input.connect(_on_gui_input)
	
	
	func _ready() -> void:
		get_parent().add_child.call_deferred(drop_indicator, false, INTERNAL_MODE_FRONT)
	
	
	func _process(delta: float) -> void:
		var target: float = scroll + get_parent().size.y - size.y
		if not is_equal_approx(position.y, target):
			position.y = move_toward(
					position.y, target, 1024.0 * delta
			) if plugin.smooth_scrolling else target
	
	
	## A type-safe version of [method Node.get_children], returning an [Array] of [Task]s.
	func get_tasks() -> Array[Task]:
		var arr: Array[Task]
		for child in get_children():
			if child is Task:
				arr.append(child)
		return arr
	
	
	## Updates the position of a grabbed [Task], scaling it towards the mouse grab point
	## and clamping its y position within the boundaries of the [TaskContainer].
	func update_task_position(task: Task) -> void:
		task.global_position = Vector2(
			# Scale task towards mouse grab position
			global_position.x + (
					# Maximum x size
					size.x
					# Percentage of size lost due to scale
					* (1.0 - task.scale.x)
					# Percentage of the way across the task grab_offset.x is
					* (Task.grab_offset.x / task.size.x)
			),
			clampf(
					Task.mouse_position.y - Task.grab_offset.y * task.scale.y,
					# Prevent task from being moved above...
					global_position.y - scroll,
					# ...or below container.
					global_position.y - scroll + size.y - task.size.y - task_margin
			)
		)
	
	
	## Sort child tasks.
	func sort() -> void:
		if sort_mode == SortMode.ONCE:
			sort_mode = SortMode.DISABLED
		elif not sort_mode or not is_visible_in_tree():
			return
		
		# Shrink container when plugin.edit_vbox fills more than half of the plugin's height
		var c := get_parent_control()
		if c.anchor_top == 0.5:
			## The height of the main control that holds [member plugin.edit_vbox] and [member c].
			var main_control_height: float = plugin.edit_vbox.get_parent_control().size.y
			## The maxmimum height that [member c] can fill.
			var max_height := main_control_height / 2 - task_margin
			c.offset_top = plugin.edit_vbox.size.y - max_height
		
		## The total height + margin of all tasks before this task.
		var cumulative_y := 0.0
		if grabbed_task:
			## The index that [member drop_indicator] will be placed at.[br]
			## Set to -1 by default so that it will be dropped
			## below all other tasks if it isn't above any of them
			var drop_index := -1
			
			# Get the last task.
			var last_task := get_child(-1) as Task
			# Get the second to last task if the last is being grabbed.
			if last_task == grabbed_task:
				last_task = get_child(-2) as Task
			
			## The y position of [member grabbed_task] relative to the container.[br]
			## [member position] cannot be used since [member top_level] is [code]true[/code].
			var relative_y := grabbed_task.global_position.y - global_position.y
			if relative_y < last_task.target + last_task.size.y * 0.5:
				drop_index = 0
				for task in get_tasks():
					if task != grabbed_task:
						if task.visible:
							if relative_y >= cumulative_y + task.size.y * 0.5:
								drop_index += 1
								cumulative_y += task.size.y + task_margin
							else:
								break
						else:
							drop_index += 1
			
			cumulative_y = 0.0
			var tween: Tween
			## The index of the current non-grabbed task.
			var current_index := 0
			for task in get_tasks():
				# Fill width of container
				task.size.x = size.x
				if task != grabbed_task:
					# If this is the index of the task that the grabbed_task will be dropped at
					if current_index == drop_index:
						# Move drop_indicator if its target isn't already cumulative_y
						if not is_equal_approx(_drop_indicator_target, cumulative_y):
							# Create tween if it doesn't exist already
							@warning_ignore("unassigned_variable")
							if not tween:
								tween = plugin.new_tween()
							
							_drop_indicator_target = cumulative_y
							tween.tween_property(drop_indicator, ^":position:y",
									cumulative_y + scroll, 0.25)
						cumulative_y += drop_indicator.size.y + task_margin
						drop_index = -1
					
					if task.visible:
						# Move task if its target isn't already cumluative_y
						if not is_equal_approx(task.target, cumulative_y):
							# Create tween if it doesn't exist already
							@warning_ignore("unassigned_variable")
							if not tween:
								tween = plugin.new_tween()
							
							task.target = cumulative_y
							tween.tween_property(task, ^":position:y", cumulative_y, 0.25)
						
						cumulative_y += task.size.y + task_margin
					current_index += 1
			
			# Move drop_indicator if its target isn't already cumulative_y
			if drop_index != -1 and not is_equal_approx(_drop_indicator_target, cumulative_y):
				# Create tween if it doesn't exist already
				@warning_ignore("unassigned_variable")
				if not tween:
					tween = plugin.new_tween()
				
				_drop_indicator_target = cumulative_y
				tween.tween_property(drop_indicator, ^":position:y",
						cumulative_y + scroll, 0.25)
			
			update_task_position(grabbed_task)
		else:
			for task in get_tasks():
				if task.visible:
					task.size = Vector2(size.x, 0.0)
					task.position = Vector2(0.0, cumulative_y)
					task.target = cumulative_y
					cumulative_y += task.size.y + task_margin
	
	
	func _on_gui_input(event: InputEvent) -> void:
		var event_mouse_button := event as InputEventMouseButton
		if event_mouse_button and event_mouse_button.pressed:
			if event_mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
				scroll += 128.0
			elif event_mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				scroll -= 128.0
