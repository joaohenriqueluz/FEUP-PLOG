% [Row, Column, Piece]
move(Move, Board, NewBoard):-
    append_lists(_,[Row,Column, Piece|_], Move),
    move_piece(Row, Column, Piece, Board, NewBoard).

move_piece(Row, Column, Piece, CurrentBoard, NewBoard):-
    once(check_free_space(Row, Column, CurrentBoard)),
    valid_move(Row, Column, Piece, CurrentBoard),
    move_to_line(Row, Column, Piece, CurrentBoard, NewBoard).

move_to_line(1, Column, Piece, [Row | Rest], [New_row | Rest]):-
    move_to_column(Column, Piece, Row, New_row).

move_to_line(N, Column, Piece, [Row | Rest], [Row | New_rest]):-
    N > 1,
    Next is N - 1,
    move_to_line(Next, Column, Piece , Rest, New_rest).

move_to_column(1, Piece, [_ | Rest], [Piece | Rest]).

move_to_column(N, Piece, [X | Rest], [X | New_rest]):-
    N > 1,
    Next is N - 1,
    move_to_column(Next, Piece , Rest, New_rest).

switch_player(1, 2).
switch_player(2, 1).

next_player(Player, NewPlayer):-
    switch_player(Player, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check Game Over %%
checkGameOver(Row, Column, Board, _Result):-
    (check_full_row(Row,4,Board)
    ;
    check_full_column(4, Column, Board)
    ;
    check_full_quadrant(Row,Column,Board)
    
    %check_full_board(2,2,Board),
    %Result = 1,
    %write(Result)
    )
    .


check_repeated_solids(Piece, SolidList):-
    list_empty(SolidList, F),
    F == true
    ;
    once(is_solid_in_list(Piece, SolidList, Value)),
    Value == 1
    ;
    fail.
    
 is_solid_in_list(_, [], 1):- !. % All different solids
 is_solid_in_list(Piece, [X | Y], Value):-
    X == empty  % Empty cell
    %!, fail
    ;  
    Piece == empty  %Empty piece
    ;
    % Found the same solid
    symb_solid(Piece, PieceSolid),
    symb_solid(X, XSolid),
    XSolid == PieceSolid
    ;
    is_solid_in_list(Piece, Y, Value).

%% Check Full Row %%
check_full_row(Row, Column, Board):-
    check_full_row_in_line(Row, Column, Board).

check_full_row_in_line(1, Column, [Row | _]):-
    check_full_row_in_column(Column, Row).

check_full_row_in_line(N, Column, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    check_full_row_in_line(Next, Column, Rest).

check_full_row_in_column(0, []):- !.

check_full_row_in_column(N, [X | Rest]):-
    once(check_repeated_solids(X, Rest)),
    N > 0,
    Next is N - 1,
    check_full_row_in_column(Next, Rest).

%% Check full collumn %%
check_full_column(Row, Column, Board):-
    check_full_column_in_line(Row, Column, Board, _).

check_full_column_in_line(0, _, [], _):- !.

check_full_column_in_line(N, Column, [Row | Rest], SolidList):-
    once(check_full_column_in_column(Column, Row, SolidList, B)),
    once(append_lists(SolidList, B, NewSolidList)),
    %show_records(NewSolidList),
    N > 0,
    Next is N - 1,
    check_full_column_in_line(Next, Column, Rest, NewSolidList).

check_full_column_in_column(1, [X |_], SolidList, [X|_]):-
    check_repeated_solids(X, SolidList), !. 
    %add para lista

check_full_column_in_column(N, [_ | Rest], SolidList, [A|B]):-
    once(N > 1),
    once(Next is N - 1),
    %once(show_records([A|B])),
    check_full_column_in_column(Next, Rest, SolidList, [A|B]).

%% Check full quadrant %%
check_full_quadrant(Row, Column, Board):-
    (
    diagonal(Row,Column,DRow,DColumn)
    ;
    diagonal(DRow,DColumn,Row,Column)
    ),
    once(check_full_quadrant_in_line(Row, Column, Board,_, NewSolidList)),
    once(check_full_quadrant_in_line(DRow, DColumn, Board, NewSolidList, NewSolidList2)),
    once(check_full_quadrant_in_line(Row, DColumn, Board, NewSolidList2, NewSolidList3)),
    check_full_quadrant_in_line(DRow, Column, Board, NewSolidList3, _).

check_full_quadrant_in_line(1, Column, [Row | _], SolidList, NewSolidList):-  
    once(check_full_quadrant_in_column(Column, Row, SolidList, B)),
    append_lists(SolidList, B, NewSolidList),
    !.

check_full_quadrant_in_line(N, Column, [_ | Rest], SolidList, NewSolidList):-
    %show_records(NewSolidList),
    N > 1,
    Next is N - 1,
    check_full_quadrant_in_line(Next, Column, Rest, SolidList, NewSolidList).

check_full_quadrant_in_column(1, [X |_], SolidList, [X|_]):-
    check_repeated_solids(X, SolidList), !. 
    %add para lista

check_full_quadrant_in_column(N, [_ | Rest], SolidList, [A|B]):-
    once(N > 1),
    once(Next is N - 1),
    %once(show_records([A|B])),
    check_full_quadrant_in_column(Next, Rest, SolidList, [A|B]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%check_full_board(Row, Column, CurrentBoard):-
%    check_full_board_line(Row, Column, CurrentBoard).
%
%check_full_board_line(0, _, []):- write('full_borad'), !.
%
%check_full_board_line(N, Column, [Row | Rest]):-
%    once(check_full_board_column(Column, Row)),
%    N > 0,
%    Next is N - 1,
%    check_full_board_line(Next, Column , Rest).
%
%check_full_board_column(0, []):- !.
%    
%check_full_board_column(N, [X | Rest]):-
%    once(check_whatevers(X)),
%    N > 0,
%    Next is N - 1,
%    check_full_board_column(Next, Rest).
%check_whatevers(X):-
%    (X \== empty
%        ;
%     write('\nNot a full board\n'),
%    fail
%    ).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

valid_moves(Board, Player, ListOfMoves):-
    check_valid_moves(4, 4, Board, Player , ListOfMoves).

check_valid_moves(Row, Column, Board, Player , ListOfMoves):-
    check_valid_moves_line(Row, Column, Board, Player , ListOfMoves).

check_valid_moves_line(0, _, [], _, _):- !.

check_valid_moves_line(N, Column, [Row | Rest], Player , ListOfMoves):-
    once(check_valid_moves_column(Column, N, Row, Player, ListOfMoves)),
    N > 0,
    Next is N - 1,
    check_valid_moves_line(Next, Column , Rest, Player , ListOfMoves).

check_valid_moves_column(0, _, [], _ , _):- !.
    
check_valid_moves_column(N, Nrow, [X | Rest], Player , ListOfMoves):-
    once(check_whatevers(X,Nrow, N,Player, _,  ListOfMoves, ListOfMoves)),
    N > 0,
    Next is N - 1,
    check_valid_moves_column(Next, Nrow, Rest, Player , ListOfMoves).

check_whatevers(Cell, Row, Column, _Player, _Board, ListOfMoves, NewList):-
    (Cell \== empty
    ;
    %valid_move(Row, Column, Board, Piece),
    write(Cell),
    append_lists(ListOfMoves, [Row, Column], NewList)
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generator_move(Row, Column, Piece, Player):-
    member(Row, [1,2,3,4]),
    member(Column, [1,2,3,4]),
    symb_of_player(Piece, Player).

mov(Board, Player, NewBoard):-
    generator_move(Row, Column, Piece, Player),
    write(Row),
    write(Column),
    write(Player),
    valid_move(Row, Column, Piece, Board),
    move([Row,Column,Piece], Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gameLoop(Player, Board, h, NextPlayerType):-
    repeat,
    once(validate_move(Row, Column, Piece, Player)),

    % Move Piece 
    once(move([Row,Column,Piece], Board, NewBoard)),
   (checkGameOver(Row, Column, NewBoard, _),
   %TODO: findALl , se empty acaba
       final_display_game(NewBoard, Player)
   ;

    next_player(Player, NewPlayer),
    display_game(NewBoard, NewPlayer),
    gameLoop(NewPlayer, NewBoard,  NextPlayerType, h)
   ).

gameLoop(Player, Board, c, NextPlayerType):-
    repeat,

    % Move Piece 
    findall(Board, mov(Board, Player, _), AllBoards),
    choose_one_board(AllBoards, FinalBoard),
   %(checkGameOver(Row, Column, NewBoard, _),
    %   final_display_game(NewBoard, Player)
   %;
   
    next_player(Player, NewPlayer),
    display_game(FinalBoard, NewPlayer),
    gameLoop(NewPlayer, FinalBoard, NextPlayerType, c)
   .

choose_one_board(AllBoards, FinalBoard) :- 
    random_select(FinalBoard, AllBoards, _),
    display_game(FinalBoard, 1).

