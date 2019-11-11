move_piece(Row, Column, Piece, Current_board, New_board):-
    once(check_free_space(Row, Column, Current_board)),
    valid_move(Row, Column, Piece, Current_board),
    move_to_line(Row, Column, Piece, Current_board, New_board).

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
checkGameOver(Row, Column, Board, _Player):-
    check_full_row(Row,4,Board)
    ;
    check_full_column(4, Column, Board).
    % TODO: menu com resultados utilizando o Player

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

show_records([]):- write('vazio'),nl.
show_records([A|B]) :-
    %cell_symbol(X,A),
    write('**'),
  write(A),write('**'),nl,
  show_records(B). 

list_empty([], true).
list_empty([_|_], false).


append_lists([],L,L).
append_lists([X|L1],L2,[X|L3]):- append_lists(L1,L2,L3). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



gameLoop(Player, Board):-
    repeat,
    once(validate_column(Column)),
    once(validate_row(Row)),
    once(validate_solid(Piece, Player)),

    % Move Piece 
   once(move_piece(Row, Column, Piece, Board, NewBoard)),
   (checkGameOver(Row, Column, NewBoard, Player),
       display_game(NewBoard, Player),
   write('endGame\n')
   ;
    next_player(Player, NewPlayer),
    display_game(NewBoard, NewPlayer),
    gameLoop(NewPlayer, NewBoard)
   ).
    %TODO: Fim de jogo menu (quem ganha, quem perde...)