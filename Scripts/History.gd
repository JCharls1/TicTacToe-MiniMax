extends Window

@onready var label = $ScrollContainer/Label
func _ready():
	#print(save_manager.read_save().size())
	label.text = "History: \n" 
	#print(save_manager.read_save()[2][0])
	#print(typeof(str(save_manager.read_save()[2][0]['score'])))
	
	for i in save_manager.read_save().size():
		#print(i)
		#print(save_manager.read_save()[i])
		if i == 0:
			continue
		elif i % 2 == 0:
			label.text+="moves: \n"
			for j in save_manager.read_save()[i].size():
				if j == 0 or j % 2 == 0:
					label.text+="{"+"index of player's move: "+save_manager.read_save()[i][j]['player']+"}\n"
				else:
					label.text+= "{"+"index of AI's move: "+save_manager.read_save()[i][j]['index']+" ,score: "+str(save_manager.read_save()[i][j]['score'])+"}\n"
		else:
			label.text += save_manager.read_save()[i]+"\n"
	#pass

func _on_close_requested():
	self.queue_free()
