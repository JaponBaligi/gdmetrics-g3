# Unit tests for AnnotationManager
# Run with: godot --headless --script tests/test_annotation_manager.gd

extends SceneTree

var tests_passed = 0
var tests_failed = 0

class DummyEditor:
	var add_error_calls = 0
	var set_error_calls = 0
	var clear_annotations_calls = 0
	var clear_errors_calls = 0
	
	func add_error_annotation(script_path, line, severity, message):
		add_error_calls += 1
	
	func set_error(script_path, line, message):
		set_error_calls += 1
	
	func clear_annotations(script_path):
		clear_annotations_calls += 1
	
	func clear_errors(script_path):
		clear_errors_calls += 1

func _init():
	run_all_tests()
	quit(tests_failed)

func run_all_tests():
	print("========================================")
	print("AnnotationManager Unit Tests")
	print("========================================\n")
	test_add_error_annotation_path()
	test_set_error_path()
	test_clear_annotations_fallback()
	
	print("\n========================================")
	print("Results: %d passed, %d failed" % [tests_passed, tests_failed])
	print("========================================")

func assert_true(condition: bool, message: String):
	if condition:
		tests_passed += 1
		print("PASS: %s" % message)
	else:
		tests_failed += 1
		print("FAIL: %s" % message)

func _load_manager():
	return load("res://addons/gdscript_complexity/gd3/annotation_manager.gd").new()

func test_add_error_annotation_path():
	# G4 API is not used in this repo; unknown API falls back to console log
	print("Testing unknown annotation API falls back...")
	var manager = _load_manager()
	var editor = DummyEditor.new()
	manager.script_editor = editor
	manager.has_annotation_support = true
	manager.annotation_api = "add_error_annotation"
	manager.add_complexity_annotation("res://test.gd", 1, "Test", "warning")
	assert_true(editor.add_error_calls == 0, "add_error_annotation not used on Godot 3")
	assert_true(editor.set_error_calls == 0, "set_error not called for unknown API")

func test_set_error_path():
	print("Testing set_error path...")
	var manager = _load_manager()
	var editor = DummyEditor.new()
	manager.script_editor = editor
	manager.has_annotation_support = true
	manager.annotation_api = "set_error"
	manager.add_complexity_annotation("res://test.gd", 1, "Test", "warning")
	assert_true(editor.set_error_calls == 1, "set_error called once")

func test_clear_annotations_fallback():
	print("Testing clear_annotations fallback...")
	var manager = _load_manager()
	manager.script_editor = null
	manager.has_annotation_support = false
	manager.clear_annotations("res://test.gd")
	assert_true(true, "clear_annotations handled without crash")
