extends Spatial

signal state_changed(state)

var chasing_range = null
var player = null
var model = null
var nav = null
var chasing_cooldown_timer
var attack_cooldown_timer

enum State {WALK, CHASE, ATTACK, DIE, RUN}

var state_ = null

func _ready():
	state_ = State.WALK
	chasing_cooldown_timer = $ChasingCooldown
	attack_cooldown_timer = $AttackCooldown

func _physics_process(_delta):
	if state_ == State.CHASE:
		if is_instance_valid(player) and chasing_cooldown_timer.is_stopped():
			var t_position = chasing_range.players_in_range[0].get_position()
			var p1 = CommonUtils.get_random_in_circle(t_position, 2, player.rng)
			#var p2 = nav.get_closest_point(p1)
			#print(p2)
			player.target_position = p1
			chasing_cooldown_timer.start()
	elif state_ == State.ATTACK:
		if is_instance_valid(player) and attack_cooldown_timer.is_stopped():
			var t_position = chasing_range.players_in_range[0].get_position()
			var p1 = CommonUtils.get_random_in_circle(t_position, 1, player.rng)
			#var p2 = nav.get_closest_point(p1)
			#print(p2)
			player.target_position = p1
			attack_cooldown_timer.start()
	elif state_ == State.RUN:
		#var des = player.get_destination()
		#var flag = GlobalVariables.is_in_ring(player.get_destination())
		#var test_radius = GlobalVariables.ring_rad
		if not GlobalVariables.is_in_next_ring(player.get_destination()):
			var _next_ri = GlobalVariables.next_rad
			var _ri = GlobalVariables.ring_rad
			player.random_target_location(true)

func _on_Body_animation_finished(anim_name):
	if state_ == State.WALK:
		if anim_name == "Jogging2":
			model.play("Jogging3")
		else:
			model.play("Walk")
	elif state_ == State.CHASE:
		if anim_name in ["Jogging1", "Jogging2"]:
			model.play("Jogging2")
		else:
			model.play("Jogging1")
	elif state_ == State.ATTACK:
		if anim_name == "Jogging2":
			model.play("Jogging3")
		else:
			model.play("Walk")
	elif state_ == State.RUN:
		if anim_name in ["Jogging1", "Jogging2"]:
			model.play("Jogging2")
		else:
			model.play("Jogging1")

func run():
	emit_signal("state_changed", "Run")
	state_ = State.RUN

func walk():
	emit_signal("state_changed", "Walk")
	state_ = State.WALK

func _on_ChasingRange_body_entered(body):
	if state_ == State.RUN: 
		return
	if body != player:
		emit_signal("state_changed", "Chase")
		state_ = State.CHASE

func _on_ChasingRange_everybody_exited(_body):
	if state_ == State.RUN: 
		return
	emit_signal("state_changed", "Walk")
	state_ = State.WALK

func _on_ChasingRange_ready():
	chasing_range = get_parent().get_node("ChasingRange")
	chasing_range.connect("body_entered", self, "_on_ChasingRange_body_entered")
	#chasing_range.connect("body_exited", self, "_on_ChasingRange_body_exited")

func _on_Body_ready():
	model = get_parent().get_node("Body")

func _on_Pivot_ready():
	player = get_parent()

func _on_Navigation_ready():
	nav = get_parent().get_node("Navigation") 

func _on_AttackCooldown_timeout():
	pass
	


func _on_RaycastCollection_is_attackable(being_attacked, attacker):
	if state_ == State.RUN: 
		return
	if attack_cooldown_timer.is_stopped():
		if state_ != State.ATTACK:
			emit_signal("state_changed", "Attack")
			state_ = State.ATTACK
		attacker.get_node("Body").stop()
		being_attacked.change_health_by(attacker.attack_damage, attacker)
		attacker.get_node("Body").play("Honk")
		attack_cooldown_timer.wait_time = player.rng.randf_range(0.8, 1.2)
		attack_cooldown_timer.start()

func _on_RaycastCollection_player_out_of_range():
	if state_ == State.RUN: 
		return
	if attack_cooldown_timer.is_stopped():
		if state_ != State.CHASE:
			emit_signal("state_changed", "Chase")
			state_ = State.CHASE
		attack_cooldown_timer.wait_time = player.rng.randf_range(0.8, 1.2)
		attack_cooldown_timer.start()
