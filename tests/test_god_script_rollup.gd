extends SceneTree
func _init():
	print("start")
	var rollup_script = load("res://addons/gdscript_complexity/src/core/god_script_rollup.gd")
	if rollup_script == null:
		print("FAIL load rollup")
		quit(1)
		return
	var churn_script = load("res://addons/gdscript_complexity/src/core/churn_hotspots.gd")
	if churn_script == null:
		print("FAIL load churn")
		quit(1)
		return
	var rollup = rollup_script.new()
	var churn = churn_script.new()
	var cfg_mgr = load("res://addons/gdscript_complexity/src/config_manager.gd").new()
	var config = cfg_mgr.get_config()
	var batch = load("res://addons/gdscript_complexity/src/batch_analyzer.gd")
	var project = batch.ProjectResult.new()
	var fr = batch.FileResult.new()
	fr.success = true
	fr.file_path = "res://fake/god_file.gd"
	fr.cc = 40
	fr.cog = 50
	fr.loc_code = 400
	fr.functions = []
	fr.per_function_cc = {}
	fr.per_function_cog = {}
	fr.per_function_directives = {}
	project.file_results = [fr]
	var gods = rollup.build(project, config, 5)
	print("gods=", gods.size())
	var hot = churn.enrich(gods, "res://", config, 5)
	print("hot=", hot.size())
	print("PASS")
	quit(0)
