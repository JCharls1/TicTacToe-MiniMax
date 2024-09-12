extends Control

const Cell = preload("res://cell.tscn")

@export_enum("Human", "AI") var play_with : String = "Human"

var cells : Array = []
var turn : int = 0
const ai_mark = "O"
const human_mark = "X"


var is_game_end : bool = false

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
	
	elif play_with == "AI" and turn == 1:
		use_minimax_for_AI(board_state)

# minimax algorithm for ai
# add explanatin later
# tinatamad pa
func minimax(board_state, current_player):
	
	var available_cells_indexes = getAllEmptyCellsIndexes(board_state)
	
	if check_if_winner_is_found(board_state, human_mark):
		return {"score": -1}
	elif check_if_winner_is_found(board_state, ai_mark):
		return {"score": 1}
	elif available_cells_indexes.size() == 0:
		return {"score": 0}
	
	var all_test_play_info : Array = []
	for n in available_cells_indexes.size():
		var current_test_play_info = {}
		current_test_play_info["index"] = board_state[int(available_cells_indexes[n])]
		board_state[int(available_cells_indexes[n])] = current_player

		if current_player == ai_mark:
			var result = minimax(board_state, human_mark)
			current_test_play_info["score"] = result["score"]
		else:
			var result = minimax(board_state, ai_mark)
			current_test_play_info["score"] = result["score"]
		board_state[int(available_cells_indexes[n])] = current_test_play_info["index"]
		all_test_play_info.append(current_test_play_info)
	var best_test_play = null
	if current_player == ai_mark:
		var best_score = -INF
		for n in all_test_play_info.size():
			if all_test_play_info[n].score > best_score:
				best_score = all_test_play_info[n].score
				best_test_play = n
	else:
		var best_score = INF
		for n in all_test_play_info.size():
			if all_test_play_info[n].score < best_score:
				best_score = all_test_play_info[n].score
				best_test_play = n
	return all_test_play_info[best_test_play]

func use_minimax_for_AI(board_state):
	cells[int(minimax(board_state, ai_mark)["index"])].draw_cell()

func setup_board():
	var cell = Cell.instantiate()
	cell.main = self
	$Cells.add_child(cell)
	cells.append(cell)
	cell.cell_updated.connect(_on_cell_updated)

func check_if_winner_is_found(board_state, current_player): 
	if ((board_state[0] == current_player and board_state[1] == current_player and board_state[2] == current_player) or 
	 (board_state[3] == current_player and board_state[4] == current_player and board_state[5] == current_player) or 
	 (board_state[6] == current_player and board_state[7] == current_player and board_state[8] == current_player) or 
	 (board_state[0] == current_player and board_state[3] == current_player and board_state[6] == current_player) or 
	 (board_state[1] == current_player and board_state[4] == current_player and board_state[7] == current_player) or 
	 (board_state[2] == current_player and board_state[5] == current_player and board_state[8] == current_player) or
	 (board_state[0] == current_player and board_state[4] == current_player and board_state[8] == current_player) or
	 (board_state[2] == current_player and board_state[4] == current_player and board_state[6] == current_player)):
		return true
	else:
		return false

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

func getAllEmptyCellsIndexes(current_board):
	var filtered_arr = current_board.filter(func(i): return i != "O" and i != "X")
	return filtered_arr

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

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

func start_win_animation(match_result: Array):
	var color: Color
	
	if match_result[0] == "X":
		color = Color.BLUE
	elif match_result[0] == "O":
		color = Color.RED
	
	for c in range(3):
		cells[match_result[c+1]-1].glow(color)
