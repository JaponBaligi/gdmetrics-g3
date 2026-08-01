# Host CLI: analyze an external Godot 3 project by absolute filesystem path.
# Usage: godot3 --path D:/gdmetrics-g3 --no-window -s tests/analyze_external.gd -- D:/test-3/meteorite
extends SceneTree

func _init():
	var args = OS.get_cmdline_args()
	var root = ""
	var dash = args.find("--")
	if dash >= 0 and dash + 1 < args.size():
		root = args[dash + 1].replace("\\", "/")
	if root == "":
		print("Usage: godot3 --path <gdmetrics-g3> --no-window -s tests/analyze_external.gd -- <project_dir>")
		quit(1)
		return

	var adapter = load("res://addons/gdscript_complexity/version_adapter.gd").new()
	var cm = load("res://addons/gdscript_complexity/src/config_manager.gd").new()
	cm.load_config("res://complexity_config.json")
	var cfg = cm.get_config()
	# file_discovery remaps absolute roots to res://-relative paths for matching,
	# so default include/exclude patterns still apply. Keep addon out of results.
	if not ("res://addons/gdscript_complexity/**" in cfg.exclude_patterns):
		cfg.exclude_patterns.append("res://addons/gdscript_complexity/**")
	cfg.exclude_patterns.append("res://_cli_*.gd")
	cfg.exclude_patterns.append("res://tests/analyze_external.gd")

	var ba = load("res://addons/gdscript_complexity/src/batch_analyzer.gd").new()
	ba.version_adapter = adapter
	var res = ba.analyze_project(root, cfg, adapter)

	var ok = 0
	var fail = 0
	var token_errs = 0
	var codes = {}
	for fr in res.file_results:
		if fr.success:
			ok += 1
		else:
			fail += 1
		token_errs += fr.errors.size()
		for e in fr.errors:
			var s = str(e)
			var code = s
			if s.begins_with("[") and s.find("]") > 0:
				code = s.substr(1, s.find("]") - 1)
			if not codes.has(code):
				codes[code] = 0
			codes[code] += 1

	print("CLI_RESULT root=%s files=%d ok=%d fail=%d cc=%d cog=%d errs=%d" % [
		root, res.total_files, ok, fail, res.total_cc, res.total_cog, token_errs
	])
	if codes.size() > 0:
		print("ERR_CODES ", codes)
	quit(0 if res.total_files > 0 and ok > 0 else 1)
