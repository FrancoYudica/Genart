extends CrossoverStrategy

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	
	var child = Individual.new()

	# Calculates interpolation t factor by its fitness
	var total_fitness = parent_a.fitness + parent_b.fitness
	var t: float = parent_a.fitness / total_fitness if total_fitness > 0.0 else 0.5
	child.texture = parent_a.texture if randf() < t else parent_b.texture
	
	# Lerps
	child.position = parent_a.position * t + parent_b.position * (1.0 - t)
	child.size = parent_a.size * t + parent_b.size * (1.0 - t)
	child.rotation = parent_a.rotation * t + parent_b.rotation * (1.0 - t)
	
	return child