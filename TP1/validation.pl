get_column(Column):-
    write('Column: '),
    read(Column).

get_row(Row):-
    write('Row: '),
    read(Row).

get_solid(Solid):-
    write('Solid: '),
    read(Solid).

validate_column(ColumnLetter, ColumnNumb):-
    (\+ (var(ColumnLetter)), check_column(ColumnLetter, ColumnNumb)
    ;
    write('Invalid Column! Try again..\n\n'),
    fail).

validate_row(Row):-
    (\+ (var(Row)), number(Row), Row >= 1, Row =< 4 
    ;
    write('Invalid Row! Try again..\n\n'),
    fail).

validate_solid(Solid, Piece, Player):-
    (\+ (var(Solid)), cell_symbol(Piece, Solid), symb_of_player(Piece, Player)
    ;
    write('Invalid Solid! Try again..\n\n'),
    fail
    ).

validate_move_input(Row, Column, Piece, Player):-
    get_column(ColumnLetter),
    once(validate_column(ColumnLetter, Column)),
    get_row(Row),
    once(validate_row(Row)),
    get_solid(Solid),
    validate_solid(Solid, Piece, Player).

%%%%%% MOVEMENT %%%%%%
%%% Free Space %%%
check_free_space(Row, Column, Board):-
    check_free_space_line(Row, Column, Board).

check_free_space_line(1, Column, [Row | _]):-
    check_free_space_column(Column, Row).

check_free_space_line(N, Column, [_ | Rest]):-
    N > 1,
    Next is N - 1,
    check_free_space_line(Next, Column , Rest).

check_free_space_column(1, [empty | _]):- !.

check_free_space_column(1, [_ | _]):-
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
is_move_valid(Row, Column, Piece, Board):-
    once(valid_line_move(Row, 4, Piece, Board)),
    once(valid_column_move(4, Column, Piece, Board)),
    valid_diagonal_move(Row,Column,Piece,Board).


%% Valid Line Move %%
valid_line_move(Row, Column, Piece, Board):-
    valid_line_move_to_line(Row, Column, Piece, Board).

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
    fail.

%% Valid Column Move %%
 valid_column_move(Row, Column, Piece, Board):-
     valid_column_move_to_line(Row, Column, Piece, Board).

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
valid_diagonal_move(Row, Column, Piece, Board):-
    (
        diagonal(Row,Column,DRow,DColumn)
        ;
        diagonal(DRow,DColumn,Row,Column)
    ),
    valid_diagonal_move_to_line(DRow, DColumn, Piece, Board).

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


