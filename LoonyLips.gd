extends Control

var playerWords = []

var current_story = {}

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText

func _ready():
	set_current_story()
	DisplayText.text = "Welcome to Looney Lips. We are going to create a fun sentence! "
	PlayerText.grab_focus()
	check_player_words_length()
	
func set_current_story():
	var stories = get_from_json("StoryBook.json")
	randomize()
	current_story = stories[randi() % stories.size()]
#	uncomment the code below to use gdscript variables
#	instead of JSON, make sure to comment out variables stories
#	and current_story above if you do this

#	var stories = $StoryBook.get_child_count()
#	var selected_story = (randi() % stories)
#	current_story.prompt = $StoryBook.get_child(selected_story).prompt
#	current_story.story = $StoryBook.get_child(selected_story).story
#	current_story = template[randi() % template.size()]

func get_from_json(filename):
	var file = File.new()
	file.open(filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data
	


func _on_PlayerText_text_entered(new_text):
	add_to_player_words()


func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()


func add_to_player_words():
	playerWords.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()
	

func is_story_done():
	return playerWords.size() == current_story.prompt.size()
	
func check_player_words_length():
	if is_story_done():
		tell_story()
	else:
		prompt_player()
		
		
func tell_story():
	DisplayText.text = current_story.story % playerWords
	$VBoxContainer/HBoxContainer/Label.text = "Again?"
	end_game()
	

func prompt_player():
	DisplayText.text += "May I have " + current_story.prompt[playerWords.size()] + " please?"
	
func end_game():
	PlayerText.queue_free()