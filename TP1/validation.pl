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
%valid_move(Row, Column, Piece, Current_Board, Player):-
 %   valid_move_to_line(Row, Column, Piece, Current_Board, Player).
