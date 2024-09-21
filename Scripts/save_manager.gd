extends Node

var json = JSON.new()
var path = "res://misc/data.json"

var data = {}

func write_save(content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(content))
	file.close()
	file = null

func read_save():
	var file = FileAccess.open(path, FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	file.close()
	file = null
	return content

func create_new_save_file():
	var file = FileAccess.open("res://game_data.json", FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	data = content;
	write_save(content)

#func _ready():
	#print(read_save())
	#create_new_save_file()
	#var test_data = {
		#"ai_moves": {
			#"move_1": {"index": "0", "score": "0"},
			#"move_2": {"index": "0", "score": "0"}
		#},
		#"win_counter": {
			#"human": "0",
			#"ai": "0"
		#}
	#}
	#
	#write_save(test_data)
	
