extends Node2D

var roll_button : Button

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
	die1 = find_child("Die1")
	die2 = find_child("Die2")
	die3 = find_child("Die3")
	die4 = find_child("Die4")
	die5 = find_child("Die5")
	die1_i = 1
	die2_i = 1
	die3_i = 1
	die4_i = 1
	die5_i = 1

func _on_roll_button_pressed():
	var i = 1
	while i < 6:
		if get("die" + str(i)).find_child("Select").button_pressed == false:
			set("die" + str(i) + "_i", randi_range(1, 6))
			get("die" + str(i)).find_child("Sprite2D").texture = get("die" + str(get("die" + str(i) + "_i")) + "_sprite")
		i += 1
