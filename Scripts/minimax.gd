extends Node

const ai_mark = "O"
const human_mark = "X"

# minimax algorithm for ai
# add explanatin later
# tinatamad pa
func minimax(board_state, current_player):
	var available_cells_indexes = getAllEmptyCellsIndexes(board_state)
	
	if check_if_winner_is_found(board_state, human_mark):
		return {"score": -1}
	elif check_if_winner_is_found(board_state, ai_mark):
		#print(board_state)
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

func getAllEmptyCellsIndexes(current_board):
	var filtered_arr = current_board.filter(func(i): return i != "O" and i != "X")
	return filtered_arr

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
