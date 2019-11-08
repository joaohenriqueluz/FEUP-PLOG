%%%%%% INPUT %%%%%%
check_column('A', 1).
check_column('B', 2).
check_column('C', 3).
check_column('D', 4).
%check_column(_, _):- 
%    write('Invalid Column! Try again..\n\n'),
%    fail.

symb_of_player(cube_w, 1).
symb_of_player(cil_w, 1).
symb_of_player(cone_w, 1).
symb_of_player(sph_w, 1).
symb_of_player(cube_b, 2).
symb_of_player(cil_b, 2).
symb_of_player(cone_b, 2).
symb_of_player(sph_b, 2).
%symb_of_player(_, _):-
   % write('That's not a piece of yours! Try again.\n\n'),
   % fail.

symb_solid(cube_w, cube).
symb_solid(cil_w, cylinder).
symb_solid(cone_w, cone).
symb_solid(sph_w, sphere).
symb_solid(cube_b, cube).
symb_solid(cil_b, cylinder).
symb_solid(cone_b, cone).
symb_solid(sph_b, sphere).

validate_column(ColumnNumb):-
    write('Column: '),
    read(ColumnLetter),
    (\+ (var(ColumnLetter)), check_column(ColumnLetter, ColumnNumb)
    ;
    write('Invalid Column! Try again..\n\n'),
    fail).

validate_row(Row):-
    write('Row: '),
    read(Row),
    (\+ (var(Row)), number(Row), Row >= 1, Row =< 4 
    ;
    write('Invalid Row! Try again..\n\n'),
    fail).

validate_solid(Piece, Player):-
    write('Solid: '),
    read(Solid),
    (\+ (var(Solid)), cell_symbol(Piece, Solid), symb_of_player(Piece, Player)
    ;
    write('Invalid Solid! Try again..\n\n'),
    fail).

%%%%%% MOVEMENT %%%%%%
%%% Free Space %%%
check_free_space(Row, Column, Current_board):-
    check_free_space_line(Row, Column, Current_board).

check_free_space_line(1, Column, [Row | _]):-
    check_free_space_column(Column, Row).

check_free_space_line(N, Column, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    check_free_space_line(Next, Column , Rest).

check_free_space_column(1, [X | _]):-
    (X == empty
    ;
    write('\nThat cell already has a piece! Choose another one:\n'),
    fail).

check_free_space_column(N, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    check_free_space_column(Next, Rest).

%%% Valid Move %%%
valid_move(Row, Column, Piece, Current_Board):-
    once(valid_line_move(Row, 4, Piece, Current_Board)),
   once(valid_column_move(4, Column, Piece, Current_Board)).

%% Valid Line Move %%
valid_line_move(Row, Column, Piece, Current_Board):-
    valid_line_move_to_line(Row, Column, Piece, Current_Board).

valid_line_move_to_line(1, Column, Piece, [Row | _]):-
    valid_line_move_to_column(Column, Piece, Row).

valid_line_move_to_line(N, Column, Piece, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    valid_line_move_to_line(Next, Column, Piece, Rest).

valid_line_move_to_column(0, _, []).

valid_line_move_to_column(N, Piece, [X | Rest]):-
    once(valid_piece_move(X, Piece)),
    N > 0,
    Next is N - 1,
    valid_line_move_to_column(Next, Piece, Rest).

valid_piece_move(Cell, Piece):-
    (Cell == empty
    ;
        (symb_solid(Cell, CellSolid),
        symb_solid(Piece, PieceSolid),
        symb_of_player(Cell, CellPlayer),
        symb_of_player(Piece, PiecePlayer),
        \+ (CellSolid == PieceSolid,
        CellPlayer \== PiecePlayer))
    ;
    write('\nYou\'re opponent has already put the same solid in that line, column or quadrant! Choose another cell:\n'),
    fail
        ).

%% Valid Column Move %%
 valid_column_move(Row, Column, Piece, Current_Board):-
     valid_column_move_to_line(Row, Column, Piece, Current_Board).

 valid_column_move_to_line(0, _, _, []).

 valid_column_move_to_line(N, Column, Piece, [Row | Rest]):-
    once(valid_column_move_to_column(Column, Piece, Row)),
     N > 0,
     Next is N - 1,
     valid_column_move_to_line(Next, Column, Piece, Rest).

 valid_column_move_to_column(1, Piece, [X|_]):-
    valid_piece_move(X, Piece).

 valid_column_move_to_column(N, Piece, [_ | Rest]):-
     N > 1,
     Next is N - 1,
     valid_column_move_to_column(Next, Piece, Rest).

%% Valid Quadrant Move %%
%valid_quadrant_move(Row, Column, Piece, Current_Board, Player):-
 %  .
