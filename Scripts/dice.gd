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

func _ready():
	roll_button = find_child("RollButton")
	upper_scorecard = $"../Container/UpperScores"
	lower_scorecard = $"../Container/LowerScores"
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

func _on_roll_button_pressed():
	var i = 1
	while i < 6:
		if get("die" + str(i)).find_child("Select").button_pressed == false:
			set("die" + str(i) + "_i", randi_range(1, 6))
			get("die" + str(i)).find_child("Sprite2D").texture = get("die" + str(get("die" + str(i) + "_i")) + "_sprite")
		i += 1
	update_scorecard()
	
func update_scorecard():
	var scores = [die1_i, die2_i, die3_i, die4_i, die5_i]
	var index = 0
	while index < 6:
		print(index)
		if upper_scorecard.is_item_selectable(index):
			upper_scorecard.set_item_text(index, str(scores.count((index + 1)) * (index + 1)))
		index += 1
	var straights = straight_finder(scores)
	if straights[0]:
		lower_scorecard.set_item_text(3, "30")
	else:
		lower_scorecard.set_item_text(3, "0")
	if straights[1]:
		lower_scorecard.set_item_text(4, "40")
	else:
		lower_scorecard.set_item_text(4, "0")
func straight_finder(scores):
	scores.sort()
	var index = 0
	var lrg_straight = true
	var sml_straight = true
	while index < scores.size() - 1:
		if scores[index] + 1 != scores[index + 1]:
			lrg_straight = false
			if index > 0:
				sml_straight = false
		index += 1
	return [sml_straight, lrg_straight]

func _on_upper_scores_item_selected(index):
	upper_scorecard.set_item_selectable(index, false)
	upper_scorecard.set_item_disabled(index, false)
	upper_scorecard.deselect(index)


func _on_lower_scores_item_selected(index):
	lower_scorecard.set_item_selectable(index, false)
	lower_scorecard.set_item_disabled(index, false)
	lower_scorecard.deselect(index)
