extends Node2D

var roll_button : Button

var upper_scorecard : ItemList
var lower_scorecard : ItemList

var die1 : Node2D
var die2 : Node2D 
var die3 : Node2D
var die4 : Node2D
var die5 : Node2D

var die1_i : int
var die2_i : int
var die3_i : int
var die4_i : int
var die5_i : int

var die1_sprite = preload("res://Sprites/die1.png")
var die2_sprite = preload("res://Sprites/die2.png")
var die3_sprite = preload("res://Sprites/die3.png")
var die4_sprite = preload("res://Sprites/die4.png")
var die5_sprite = preload("res://Sprites/die5.png")
var die6_sprite = preload("res://Sprites/die6.png")

var rolls
var roll_counter : Label
var upper_total : Label
var lower_total : Label
var upper_sum : int
var lower_sum : int
var turn : int
var yahtzee : bool

var buttons_disabled : bool

func _ready():
	roll_button = find_child("RollButton")
	upper_scorecard = $"../Scorecard/UpperScores"
	lower_scorecard = $"../Scorecard/LowerScores"
	die1 = find_child("Die1")
	die2 = find_child("Die2")
	die3 = find_child("Die3")
	die4 = find_child("Die4")
	die5 = find_child("Die5")
	die1_i = 0
	die2_i = 0
	die3_i = 0
	die4_i = 0
	die5_i = 0
	rolls = 3
	roll_counter = $"../RollButton/HBoxContainer/RollCounter"
	upper_total = $"../HBoxContainer/UpperTotal"
	lower_total = $"../HBoxContainer2/LowerTotal"
	upper_sum = 0
	lower_sum = 0
	turn = 0
	yahtzee = false
	buttons_disabled = true
	disable_dice()

func _on_roll_button_pressed():
	if buttons_disabled:
		buttons_disabled = false
		disable_dice()
	if rolls > 0:
		rolls -= 1
		roll_counter.text = str(rolls)
		var i = 1
		while i < 6:
			if get("die" + str(i)).find_child("Select").button_pressed == false:
				set("die" + str(i) + "_i", randi_range(1, 6))
				get("die" + str(i)).find_child("Sprite2D").texture = get("die" + str(get("die" + str(i) + "_i")) + "_sprite")
			i += 1
		update_scorecard()
	
func update_scorecard():
	yahtzee = false
	var scores = [die1_i, die2_i, die3_i, die4_i, die5_i]
	var score_counts = []
	var sum = die1_i + die2_i + die3_i + die4_i + die5_i
	
#	resets scores to 0
	var index = 0
	while index < 7:
		if index < 6:
			if upper_scorecard.is_item_selectable(index):
				upper_scorecard.set_item_text(index, "0")
		if lower_scorecard.is_item_selectable(index):
			lower_scorecard.set_item_text(index, "0")
		index += 1

#	upper scorecard
	index = 0
	while index < 6:
		score_counts.append(scores.count(index + 1))
		if upper_scorecard.is_item_selectable(index):
			upper_scorecard.set_item_text(index, str(score_counts[-1] * (index + 1)))
		index += 1
	
#	3/4/5
	if score_counts.max() >= 3:
		if lower_scorecard.is_item_selectable(0):
				lower_scorecard.set_item_text(0, str(sum))
		if score_counts.max() >= 4:
			if lower_scorecard.is_item_selectable(1):
				lower_scorecard.set_item_text(1, str(sum))
			if score_counts.max() == 5:
				yahtzee_calculator(sum)
		
	if (score_counts.has(3) and score_counts.has(2)) or yahtzee:
		if lower_scorecard.is_item_selectable(2):
			lower_scorecard.set_item_text(2, "25")
	
#	straights
	var straights = straight_finder(scores, score_counts)
	if straights[0] or yahtzee:
		if lower_scorecard.is_item_selectable(3):
			lower_scorecard.set_item_text(3, "30")
	if straights[1] or yahtzee:
		if lower_scorecard.is_item_selectable(4):
			lower_scorecard.set_item_text(4, "40")
	
	if lower_scorecard.is_item_selectable(6):
		lower_scorecard.set_item_text(6, str(sum))
		
func straight_finder(scores, score_counts):
	scores.sort()
	var lrg_straight = true
	var sml_straight = true
	var index = 0
	
#	early detection of straights, and removes duplicate numbers to assist with straight calculation
	if score_counts.has(3) or score_counts.has(4) or score_counts.has(5):
		lrg_straight = false
		sml_straight = false
	elif score_counts.has(2):
		lrg_straight = false
		while score_counts.find(2) != -1:
			scores.erase(score_counts.find(2) + 1)
			score_counts[score_counts.find(2)] = 0
	
	index = 0
	if scores.size() > 3:
		while index < scores.size() - 1:
			if scores[index] + 1 != scores[index + 1]:
				lrg_straight = false
				if index > 0 or scores.size() == 4:
					sml_straight = false
			index += 1
	else:
		lrg_straight = false
		sml_straight = false
	return [sml_straight, lrg_straight]
	
func yahtzee_calculator(sum):
	if lower_scorecard.is_item_selectable(5):
		lower_scorecard.set_item_text(5, "50")
	elif lower_scorecard.get_item_text(5) == "50":
		yahtzee = true
		
	
func reset_turn():
	var dice = get_children()
	var index = 0
	while index < dice.size():
		dice[index].find_child("Select").set_pressed_no_signal(false)
		index += 1
	index = 0
	while index < 7:
		if index < 6:
			if upper_scorecard.is_item_selectable(index):
				upper_scorecard.set_item_text(index, "0")
		if lower_scorecard.is_item_selectable(index):
			lower_scorecard.set_item_text(index, "0")
		index += 1
	buttons_disabled = true
	disable_dice()
	
func endgame():
	if upper_sum >= 63:
		$"../HBoxContainer3/Bonus".text = "35"
		upper_sum += 35
	$"../HBoxContainer4/Total".text = str(upper_sum + lower_sum)

func disable_dice():
	var dice = get_children()
	var index = 0
	while index < dice.size():
		dice[index].find_child("Select").disabled = buttons_disabled
		index += 1

func _on_upper_scores_item_selected(index):
	upper_scorecard.set_item_selectable(index, false)
	upper_scorecard.set_item_disabled(index, false)
	upper_scorecard.deselect(index)
	rolls = 3
	roll_counter.text = str(rolls)
	upper_sum += int(upper_scorecard.get_item_text(index))
	upper_total.text = str(upper_sum)
	if yahtzee:
		lower_sum += 100
		lower_total.text = str(lower_sum)
	turn += 1
	if turn < 13:
		reset_turn()
	else:
		endgame()

func _on_lower_scores_item_selected(index):
	lower_scorecard.set_item_selectable(index, false)
	lower_scorecard.set_item_disabled(index, false)
	lower_scorecard.deselect(index)
	rolls = 3
	roll_counter.text = str(rolls)
	lower_sum += int(lower_scorecard.get_item_text(index))
	if yahtzee:
		lower_sum += 100
	lower_total.text = str(lower_sum)
	turn += 1
	reset_turn()
