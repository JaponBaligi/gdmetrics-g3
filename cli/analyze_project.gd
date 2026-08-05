# Project complexity analysis CLI (consumer entrypoint)
# Run with:
#   godot --no-window -s cli/analyze_project.gd -- \
#     --project-path . --output report.json --csv-output report.csv --html-output report.html
#     [--history-path PATH] [--diff] [--baseline PATH] [--fail-on-diff-regression]
#
# Exit codes (Godot 3.2+):
#   0 - analysis ok, no threshold_fail breaches
#   1 - threshold_fail breach, no successful file analysis, or diff regression
#   2 - tool/config/path error
#
# Godot 3.0/3.1: SceneTree.quit() takes no arguments (parse error if quit(code)).
# Prefer OS.set_exit_code when available, then quit().

extends SceneTree

func _initialize():
	var logic = load("res://cli/analyze_project_logic.gd").new()
	var exit_code = 2
	if logic != null and logic.has_method("run_from_cmdline"):
		var result = logic.run_from_cmdline()
		if typeof(result) == TYPE_INT:
			exit_code = result
		elif result != null:
			exit_code = int(result)
	_quit_with(exit_code)

func _quit_with(code):
	if OS.has_method("set_exit_code"):
		OS.set_exit_code(int(code))
	quit()
