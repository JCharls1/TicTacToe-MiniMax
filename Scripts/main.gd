extends Control

const Cell = preload("res://scenes/cell.tscn")

@export_enum("Human", "AI") var play_with : String = "Human"
const ai_mark = "O"
const human_mark = "X"
var cells : Array = []
var turn : int = 0

var ai = Minimax

var is_game_end : bool = false

var game_dict = {}
var moves = []
#set up the board when the game first run
func _ready():
	for cell_count in range(9):
		setup_board()


func _on_cell_updated(cell):
	randomize()
	var board_state = getCurrentBoardState()
	var match_result = checkIfWinnerIsFound()

	if match_result:
		is_game_end = true
		start_win_animation(match_result)
		game_dict['game'] = moves
		print(game_dict)
		save_manager.write_save(game_dict)
	elif play_with == "AI" and turn == 1:
		moves.append(ai.minimax(board_state, ai_mark))
		use_minimax_for_AI(board_state)
		print(moves)

func use_minimax_for_AI(board_state):
	print(ai.minimax(board_state, ai_mark))
	cells[int(ai.minimax(board_state, ai_mark)["index"])].draw_cell()

func setup_board():
	var cell = Cell.instantiate()
	cell.main = self
	$Cells.add_child(cell)
	cells.append(cell)
	cell.cell_updated.connect(_on_cell_updated)



func getCurrentBoardState():
	var arr : Array = []
	for n in 9:
		if cells[n].cell_value == "":
			arr.append(str(n))
		else:
			arr.append(cells[n].cell_value)
	return arr

func checkIfWinnerIsFound():
	var match_result = check_match()
	#if(match_result != null):
		#print(match_result[0])
	return match_result

func check_match():
	for h in range(3):
		if cells[0+3*h].cell_value == "X" and cells[1+3*h].cell_value == "X" and cells[2+3*h].cell_value == "X":
			return ["X", 1+3*h, 2+3*h, 3+3*h]
	for v in range(3):
		if cells[0+v].cell_value == "X" and cells[3+v].cell_value == "X" and cells[6+v].cell_value == "X":
			return ["X", 1+v, 4+v, 7+v]
	if cells[0].cell_value == "X" and cells[4].cell_value == "X" and cells[8].cell_value == "X":
		return ["X", 1, 5, 9]
	elif cells[2].cell_value == "X" and cells[4].cell_value == "X" and cells[6].cell_value == "X":
		return ["X", 3, 5, 7]
	
	for h in range(3):
		if cells[0+3*h].cell_value == "O" and cells[1+3*h].cell_value == "O" and cells[2+3*h].cell_value == "O":
			return ["O", 1+3*h, 2+3*h, 3+3*h]
	for v in range(3):
		if cells[0+v].cell_value == "O" and cells[3+v].cell_value == "O" and cells[6+v].cell_value == "O":
			return ["O", 1+v, 4+v, 7+v]
	if cells[0].cell_value == "O" and cells[4].cell_value == "O" and cells[8].cell_value == "O":
		return ["O", 1, 5, 9]
	elif cells[2].cell_value == "O" and cells[4].cell_value == "O" and cells[6].cell_value == "O":
		return ["O", 3, 5, 7]
	
	var full = true
	for cell in cells:
		if cell.cell_value == "":
			full = false
	
	if full: return["Draw", 0, 0, 0]


func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func start_win_animation(match_result: Array):
	var color: Color
	
	if match_result[0] == "X":
		color = Color.BLUE
	elif match_result[0] == "O":
		color = Color.RED
	
	for c in range(3):
		cells[match_result[c+1]-1].glow(color)
