
generator_move(Row, Column, Piece, Player):-
    member(Row, [1,2,3,4]),
    member(Column, [1,2,3,4]),
    symb_of_player(Piece, Player).

random_move(Board, Player, NewBoard):-
    generator_move(Row, Column, Piece, Player),
    is_move_valid(Row, Column, Piece, Board),
    move([Row,Column,Piece], Board, NewBoard).

computer_move(Board, Player, Level, FinalBoard):-
    valid_moves(Board, Player, PossibleBoards),
    choose_move(PossibleBoards, Level, FinalBoard).

evaluate_moves(AllBoards, WinningBoards) :-
    evaluate(AllBoards, _, WinningBoards).

evaluate([],NewWinningBoards,NewWinningBoards):- !.

evaluate([Board| Rest], WinningBoards, NewNewWinningBoards):-
    once(value(Board, Value)),
    once(add_board_by_value(Board, Value, WinningBoards, NewWinningBoards)),
    evaluate(Rest, NewWinningBoards, NewNewWinningBoards)
    .

value(Board, Value):-
    check_game_over(Board),
    good_move(_, Value)
    ;
    bad_move(_, Value).

good_move(_, 1).
bad_move(_, 0).

add_board_by_value(_, 0, WinningBoards, NewWinningBoards):- 
    append_lists(WinningBoards, [], NewWinningBoards).

add_board_by_value(Board, 1, WinningBoards, NewWinningBoards):- 
    append_lists(WinningBoards, [Board], NewWinningBoards).

valid_moves(Board, Player, AllBoards):-
    findall(NewBoard, random_move(Board, Player, NewBoard), AllBoards).

choose_random_move(AllBoards, FinalBoard) :- 
    random_select(FinalBoard, AllBoards, _).

choose_one_board(1, PossibleBoards, _, FinalBoard):-
    choose_random_move(PossibleBoards, FinalBoard).

choose_one_board(2, PossibleBoards, WinningBoards, FinalBoard):-
    list_empty(WinningBoards),
    choose_random_move(PossibleBoards, FinalBoard)
    ;
    choose_random_move(WinningBoards, FinalBoard).

choose_move(PossibleBoards, Level, FinalBoard):-
    evaluate_moves(PossibleBoards, WinningBoards),
    choose_one_board(Level, PossibleBoards, WinningBoards, FinalBoard).
    