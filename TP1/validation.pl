diagonal(1,1,2,2).
diagonal(2,1,1,2).

diagonal(1,3,2,4).
diagonal(2,3,1,4).

diagonal(3,1,4,2).
diagonal(4,1,3,2).

diagonal(3,3,4,4).
diagonal(4,3,3,4).

%%%%%% INPUT %%%%%%
check_column('A', 1).
check_column('B', 2).
check_column('C', 3).
check_column('D', 4).

symb_of_player(cube_w, 1).
symb_of_player(cil_w, 1).
symb_of_player(cone_w, 1).
symb_of_player(sph_w, 1).
symb_of_player(cube_b, 2).
symb_of_player(cil_b, 2).
symb_of_player(cone_b, 2).
symb_of_player(sph_b, 2).

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

get_solid(Solid):-
    write('Solid: '),
    read(Solid).

validate_solid(Solid, Piece, Player):-
    (\+ (var(Solid)), cell_symbol(Piece, Solid), symb_of_player(Piece, Player)
    ;
    write('Invalid Solid! Try again..\n\n'),
    fail
    ).

validate_move(Row, Column, Piece, Player):-
    once(validate_column(Column)),
    once(validate_row(Row)),
    get_solid(Solid),
    validate_solid(Solid, Piece, Player).

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

check_free_space_column(1, [empty | _]):- !.

check_free_space_column(1, [_ | _]):-
   % TODO:write('\nThat cell already has a piece! Choose another one:\n'),
    fail.

check_free_space_column(N, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    check_free_space_column(Next, Rest).

%%% Pieces Number %%%
check_pieces_number(Piece, Board):-
    pieces_number(4, 4, Piece, Board).

pieces_number(Row, Column, Piece, Board):-
    pieces_number_in_line(Row, Column, Piece, Board, 0, _).

pieces_number_in_line(0, _, _, [], _, _):- !.

pieces_number_in_line(N, Column, Piece, [Row | Rest], Counter, NewCounter):-
    once(pieces_number_in_column(Column, Piece, Row, Counter, NewCounter)),
    N > 0,
    Next is N - 1,
    pieces_number_in_line(Next, Column, Piece, Rest, NewCounter, _).

pieces_number_in_column(_, _, [], 2, _):- !, fail.

pieces_number_in_column(0, _, [], NewCounter, NewnewCounter):-  
    NewnewCounter is NewCounter, !.

pieces_number_in_column(N, Piece, [X | Rest], Counter, NewnewCounter):-
    once(same_piece(X, Piece, Counter, NewCounter)),
    N > 0,
    Next is N - 1,
    pieces_number_in_column(Next, Piece, Rest, NewCounter, NewnewCounter).

same_piece(X, X, Counter, NewCounter):-
    NewCounter is Counter + 1.

same_piece(_, _, Counter, Counter):- !.


%%% Valid Move %%%
valid_move(Row, Column, Piece, Current_Board):-
    once(valid_line_move(Row, 4, Piece, Current_Board)),
    once(valid_column_move(4, Column, Piece, Current_Board)),
    valid_diagonal_move(Row,Column,Piece,Current_Board).


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

valid_piece_move(empty, _):-!.

valid_piece_move(Cell, Piece):-
    symb_solid(Cell, CellSolid),
    symb_solid(Piece, PieceSolid),
    symb_of_player(Cell, CellPlayer),
    symb_of_player(Piece, PiecePlayer),
    \+ (CellSolid == PieceSolid,
    CellPlayer \== PiecePlayer)
    ;
    %TODO: write('\nYou\'re opponent has already put the same solid in that line, column or quadrant! Choose another cell:\n'),
    fail.

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
valid_diagonal_move(Row, Column, Piece, Current_board):-
    (
        diagonal(Row,Column,DRow,DColumn)
        ;
        diagonal(DRow,DColumn,Row,Column)
    ),
    valid_diagonal_move_to_line(DRow, DColumn, Piece, Current_board).

valid_diagonal_move_to_line(1, Column, Piece, [Row | _]):-
    valid_diagonal_move_to_column(Column, Piece, Row).

valid_diagonal_move_to_line(N, Column, Piece, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    valid_diagonal_move_to_line(Next, Column, Piece , Rest).

valid_diagonal_move_to_column(1, Piece, [X | _]):-
    valid_piece_move(X,Piece).

valid_diagonal_move_to_column(N, Piece, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    valid_diagonal_move_to_column(Next, Piece , Rest).


