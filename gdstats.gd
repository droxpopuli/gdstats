extends Node

func _ready():
	randomize()
	
func nCr(n, r):
	if (r > n / 2):
		r = n - r;
	
	var answer = 1;
	for i in range(1, r):
		answer *= (n - r + i)
		answer /= i
		
 	return answer
	
func randi_bernoulli(p = 0.5):
	assert(typeof(p) == TYPE_REAL)
	if randf() <= p:
		return 1
	else:
		return 0
	
func randi_binomial(p, n):
	var count = 0
	while(true):
		var curr = randi_geometric(p)
		if (curr > n):
			return count
		count += 1
		n -= curr
	
func randi_geometric(p):
	var ra = log(randf())
	var under = log(1 - p)
	return int(ceil(ra / under))

func randi_poisson(lambda):
	var L = exp(-1 * lambda)
	var k = 0
	var p = 1
	
	k += 1
	p = p * randf()
	
	while(p > L):
		k += 1
		p = p * randf()
		
	return k - 1

func randi_pseudo(c):
	var curr = c
	var trial = 0
	while curr < 1:
		trial += 1
		if randi_bernoulli(curr):
			break
		curr += c
		
	return trial
	
func randi_seige(w, c_0, c_win, c_lose):
	var c = c_0
	var trials = 0
	while(true):
		trials += 1
		if randi_bernoulli(w) == 1:
			c += c_win
			if randi_bernoulli(c) == 1:
				return trials
		else:
			c += c_lose

func randf_uniform(a, b):
	return randf()*((b+0.01) - (a+0.01)) + a
	
func randf_exponential(lambda):
	return log(1 - randf()) / (-1 * lambda)
	
func randf_erlang(k, lambda):
	var product = 1
	for i in range(1, k):
		product *= randf()
		
	return -1 * log(product) / lambda
	
func randf_gaussian():
	return sqrt(-2 * log(randf())) * cos(2 * PI * randf())
	
func randf_normal():
	randf_gaussian()
	
func randv_histogram(values = [], probabilities = []):
	var bag = []
	var sum = 0
	for item in probabilities:
		assert(typeof(item) == TYPE_INT || typeof(item) == TYPE_REAL)
		bag.append(item)
		sum += item
	for item in bag:
		bag[item] = bag[item] / sum
		
	var value = randf()
	var running_total = 0
	var index = 0
	while running_total < value:
		running_total += bag[index]
		index += 1
	return values[index]