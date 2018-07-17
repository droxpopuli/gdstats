extends Node

onready var results = get_node("Main/container/results")

var thread = Thread.new()
var result_values = {}

var ready = false
var result_children = []
var trials
const MAX_BARS = 100

func _ready():
	set_process(true)

func _process(delta):
	if result_values.size() == 0:
		return
		
	var max_val = 0
	var max_result = 0
	
	var working_results = result_values.duplicate()
	
	for result in working_results.keys():
		if result > max_result:
			max_result = result
		if working_results[result] > max_val:
			max_val = working_results[result]
	if max_result + 1 > result_children.size():
		for i in range(max_result + 1 - result_children.size()):
			add_new_bar()
	
	for result in working_results.keys():
		result_children[result].set_observed(float(working_results[result]) / float(trials), working_results[result], float(max_val))

func add_new_bar():
	var bar = preload("probability_bar.tscn").instance()
	bar.set_title(result_children.size())
	print(String(result_children.size()))
	result_children.append(bar)
	results.add_child(bar)
	bar.normalizing = get_node("Main/Control/CheckButton").pressed
	return bar

func cancel():
	for i in results.get_children():
		results.remove_child(i)
	result_values = {}
	result_children = []

func start_rand():
	cancel()
	var arg_1 = float(get_node("Main/Control/arg_1").text)
	var arg_2 = float(get_node("Main/Control/arg_2").text)
	var trial_count = int(get_node("Main/Control/trial_count").text)
	var dist = get_node("Main/Control/dist_menu").selected
	
	trials = trial_count
	
	ready = true
	if thread.is_active():
		thread.wait_to_finish()
	ready = false
	
	if trial_count == 0:
		return
	
	add_new_bar()
		
	thread.start(self, "rand_thread", [dist, arg_1, arg_2, trial_count])

func rand_thread(userdata):
	print(to_json(userdata))
	var dist = userdata[0]
	var arg_1 = userdata[1]
	var arg_2 = userdata[2]
	var trial_count = userdata[3]

	for i in range(trial_count):
		if ready:
			ready = false
			break
		var val
		match dist:
			0:
				val = ProbabilityServer.randi_bernoulli(arg_1)
			1:
				val = ProbabilityServer.randi_binomial(arg_1, arg_2)
			2:
				val = ProbabilityServer.randi_geometric(arg_1)
			3:
				val = ProbabilityServer.randi_poisson(arg_1)
			4:
				val = int(floor(ProbabilityServer.randf_uniform(arg_1, arg_2)))
			5:
				val = int(round(ProbabilityServer.randf_exponential(arg_1)))
			6:
				val = int(round(ProbabilityServer.randf_erlang(arg_1, arg_2)))
			7:
				val = int(round(ProbabilityServer.randf_gaussian())) + 25
			8:
				val = ProbabilityServer.randi_pseudo(arg_1)
		
		var value = clamp(val, 0, MAX_BARS-1)
		if !result_values.has(value):
			result_values[value] = 0
		result_values[value] += 1
		
func _on_CheckButton_toggled(value):
	for i in get_tree().get_nodes_in_group("bar"):
		i.normalizing = value