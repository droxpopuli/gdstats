extends Control

onready var results = get_node("Main/container/results")

var thread = Thread.new()
var result_values = {}

var ready = false
var result_children = []
var trials
var MAX_BARS = 100

var grad = Gradient.new()

func _ready():
	grad.set_color(0, "FFE30D")
	grad.set_color(1, "E8720C")
	grad.add_point(2, "FF004F")
	grad.add_point(3, "570CE8")
	grad.add_point(4, "17B3FF")
	print(to_json(grad.get_offsets()))
	#grad.add_point(100, "17B3FF")
	set_process(true)

func _process(delta):
	if result_values.size() == 0:
		return
		
	var max_val = 0
	var max_result = 0
	
	var working_results = result_values.duplicate()
	
	var total_value = 0
	var total_event_thus = 0
	var mode = 0
	
	for result in working_results.keys():
		total_value += working_results[result] * result
		total_event_thus += working_results[result]
		
		if result > max_result:
			max_result = result
		if working_results[result] > max_val:
			max_val = working_results[result]
			mode = result
			
	var standard_deviation = 0
	for result in working_results.keys():
		standard_deviation += pow(result, 2) * working_results[result]/total_event_thus
			
	var average = clamp(round(total_value/total_event_thus), 0, result_children.size()-1)
	standard_deviation -= pow(average, 2)
	standard_deviation = sqrt(standard_deviation)
			
	if max_result + 1 > result_children.size():
		for i in range(max_result + 1 - result_children.size()):
			add_new_bar()
	
	for result in working_results.keys():
		result_children[result].set_observed(float(working_results[result]) / float(trials), working_results[result], float(max_val))
		if result == average:
			result_children[result].modulate = Color(1, .2, 1)
			result_children[result].hint_tooltip = "Mean\n" + result_children[result].hint_tooltip
		elif result == mode:
			result_children[result].modulate = Color(1, 1, .2)
			result_children[result].hint_tooltip = "Mode\n" + result_children[result].hint_tooltip
		else:
			var sd = round(abs(result - average)/ standard_deviation)
			result_children[result].modulate = Color(1-0.2*sd, 1-0.2*sd, 1-0.2*sd)

func add_new_bar():
	var bar = preload("probability_bar.tscn").instance()
	bar.set_title(result_children.size())
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
	MAX_BARS = round(rect_size.x/7)
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
	print(to_json(result_values))
		
func _on_CheckButton_toggled(value):
	for i in get_tree().get_nodes_in_group("bar"):
		i.normalizing = value