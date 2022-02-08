extends CSGCombiner

onready var ring_timer = $RingTimer

const WAIT_TIME =  [10, 90, 60, 60, 30, 30] # [10, 10, 10, 10, 10, 10]
const MIN_RADIUS = [500, 350, 250, 150, 100, 50]
const MAX_RADIUS = [1000, 500, 350, 250, 150, 100]
const RING_SPEED = [12, 10, 8, 6, 5, 4, 3]
const RING_WIDTH = 2

var time
var stage
var is_ring_moving = false

func _ready():
	time = 0
	stage = 0
	is_ring_moving = false
	ring_timer.wait_time = WAIT_TIME[stage]
	ring_timer.start()

func _process(delta):
	if is_ring_moving:
		time += delta*RING_SPEED[stage]
		var r = clamp(MAX_RADIUS[stage] - time, MIN_RADIUS[stage], MAX_RADIUS[stage])
		GlobalVariables.ring_rad = r
		GlobalVariables.ring_time_left = 0
		#$CSGCylinder2.radius = r 
		$CSGCylinder3/CSGCylinder.radius = r
		$CSGCylinder3.radius = r + RING_WIDTH
		if r == MIN_RADIUS[stage]:
			stage += 1
			is_ring_moving = false
			if stage < 6:
				GlobalVariables.next_rad = MIN_RADIUS[stage]
				ring_timer.wait_time = WAIT_TIME[stage]
				ring_timer.start()
	else:
		GlobalVariables.ring_time_left = ring_timer.time_left

func _on_RingTimer_timeout():
	if stage < 6:
		time = 0
		is_ring_moving = true
