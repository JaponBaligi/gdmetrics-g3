# Corpus smoke: analyze a few external roots if present.
# Run: godot3 --path . --no-window -s tests/corpus_regression.gd
extends SceneTree

func _init():
	var roots = [
		"D:/test-3/portal2d",
		"D:/test-3/meteorite",
		"D:/test-3/Thrive"
	]
	var adapter = load("res://addons/gdscript_complexity/version_adapter.gd").new()
	var cm = load("res://addons/gdscript_complexity/src/config_manager.gd").new()
	cm.load_config("res://complexity_config.json")
	var cfg = cm.get_config()
	var ba = load("res://addons/gdscript_complexity/src/batch_analyzer.gd").new()
	ba.version_adapter = adapter

	var checked = 0
	var failed = 0
	for root in roots:
		var d = Directory.new()
		if d.open(root) != OK:
			print("SKIP missing ", root)
			continue
		checked += 1
		var res = ba.analyze_project(root, cfg, adapter)
		var unknown_backslash = 0
		for fr in res.file_results:
			for e in fr.errors:
				var s = str(e)
				if s.find("Unknown character '\\'") >= 0 or s.find("Unknown character '\\\\'") >= 0:
					unknown_backslash += 1
		var fail_rate = 0.0
		if res.total_files > 0:
			fail_rate = float(res.failed_files) / float(res.total_files)
		print("CORPUS %s files=%d fail=%d fail_rate=%.3f backslash_unknown=%d cc=%d" % [
			root, res.total_files, res.failed_files, fail_rate, unknown_backslash, res.total_cc
		])
		if unknown_backslash > 0:
			print("FAIL backslash unknowns still present")
			failed += 1
		if fail_rate > 0.005 and res.failed_files > 1:
			print("FAIL fail_rate too high")
			failed += 1
	if checked == 0:
		print("CORPUS: no external roots available (ok)")
		quit(0)
		return
	print("CORPUS Results: checked=%d failed=%d" % [checked, failed])
	quit(0 if failed == 0 else 1)
