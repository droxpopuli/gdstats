# gdstats

gdstats currently provides a small set of common distributions all implemented in fast forms usually via inversion techniques:

![Image of Example Project](https://i.imgur.com/39pPFmh.png)

Discrete
--------

- `randi_bernoulli(p)`, return 1 or 0 based on probability p

	`example: Whether a specific die value was rolled or not`

- `randi_binomial(p, n)`, return the number of 1s on n many Bernoulli Trials probability p.

	`example: Number of times a specific value is rolled on a die in n many trials`

- `randi_geometric(p)`, return the number of Bernoulli Trials with probability p until a result of 1.

	`example: The number of rolls on a die until a specific value shows.`

- `randi_poisson(lambda)`, a binomial where p->0 and n->inf but n*p = lambda.

	`example: Number of phone calls in a given amount of time. p is very low and n is very large.`

- `randv_histogram(values, probabilities)`, provide a list of return values and probabilities and return a value fitting the distribution.

	`example: Use for distributions of own choosing such as marbles in a bag.`

- `randi_pseudo(c)`, mimics the Warcraft3/Dota style of "fair" number generators. Gives the number of actions until an event occurs where upon a failure, the probability increases by c.

	`example: Use to determine the number of attacks until the next critical occurs.`
	
**Table of Nominal Probabilities to c Values**

The following table gives values of c to approximate a given event's probability of occuring.

| Nominal Probability |    c    | Nominal Probability |    c    |
|---------------------|:-------:|---------------------|:-------:|
|          5%         | 0.00380 |         45%         | 0.20155 |
|         10%         | 0.01475 |         50%         | 0.24931 |
|         15%         | 0.03222 |         55%         | 0.36040 |
|         20%         | 0.05570 |         60%         | 0.42265 |
|         25%         | 0.08474 |         65%         | 0.48113 |
|         30%         | 0.11895 |         70%         | 0.57143 |
|         40%         | 0.15798 |                     |         |


Continuous
----------

- `randf_uniform(a, b)`, return a uniformly random value in range a to b

	`example: Same as rand_range`

- `randf_exponential(lambda)`, return a value fitting the exponential distribution

	`example: Time between independant events which occur at a constant average rate. Memoryless`

- `randf_erlang(k, lambda)`, Sum of k many exponentials of 1/lambda.

	`example: The distribution of time between k many incoming telephone calls modelled by a poisson process. k = 1 is the exponential.`

- `randf_gaussian()/randf_normal()`, return a value from the normal distribution.

	`example: Useful in modeling realistic scenarious which use the distribution, i.e. Harmonic Oscilator ground state, position of a diffused particle.`
