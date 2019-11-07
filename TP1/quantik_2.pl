:-use_module(library(random)).

symbol(empty,'    ').
symbol(cube_w, wCub).
symbol(cil_w, wCyl).
symbol(cone_w, wCon).
symbol(sph_w, wSph).
symbol(cube_b, bCub).
symbol(cil_b, bCyl).
symbol(cone_b, bCon).
symbol(sph_b, bSph).
symbol(_, _):- fail.

sym(Ce):-
    symbol(Ce,S),
    write(S).

sym_rev(Ce,S):-
    symbol(Ce,S).

initial_board([
    [empty, empty, empty, empty],
    [empty, empty, empty, empty],
    [empty, empty, empty, empty],
    [empty, empty, empty, empty]
]).

mid_board([
    [empty, cube_w, empty,  cil_b],
    [cil_w, sph_b,  empty,  empty],
    [empty, cone_b, cone_b, sph_w],
    [empty, empty,  cil_w,  empty]
]).

final_board([
    [empty, cube_w, empty,  cil_b],
    [cil_w, sph_b,  empty,  empty],
    [empty, cone_b, cone_b, sph_w],
    [empty, empty,  cil_w,  cube_w]
]).

display_row([]):- !.

display_row([Cell| RestRow]) :-
    sym(Cell),
    write(' | '),
    display_row(RestRow).

display_rows([]):- !.

display_rows([Row | Others]) :-
    write(' | '),
    display_row(Row),
    nl,
    write('  ------ ------ ------ ------ '),nl,
    display_rows(Others).

display_board(Board):-
    nl,
    write('\n\n ---------------------------'),
    nl,
    write(' ---------- Board ----------'),
    nl,
    write(' ---------------------------'),
    nl, nl,
    write('     A      B      C      D  '),
    nl,
    write('  ------ ------ ------ ------ '),
    nl,
    display_rows(Board),
    nl,
    display_meanings.
    
display_meanings :-
    write('Meanings:'),nl,
    write('wCyl -> White cylinder\t\t'),
    write('bCyl -> Black cylinder'),nl,

    write('wCub -> White cube\t\t'),
    write('bCub -> Black cube'),nl,

    write('wCon -> White cone\t\t'),
    write('bCon -> Black cone'),nl,

    write('wSph -> White sphere\t\t'),
    write('bSph -> Black sphere'),nl.




display_game(Board, Player):-
    %write('\33\[2J'),
    display_board(Board),
    nl,
    write('Next player: '),
    write(Player),
    nl,nl.
    
    
switch_player('1','2').
switch_player('2','1').

check_column('A').
check_column('B').
check_column('C').
check_column('D').
check_column(_):- 
    write('Invalid Column!'),
    fail.



validate_column(Column):-
    write('Column'),
    read(Column),
    check_column(Column).

validate_row(Row):-
    write('Row'),
    read(Row),
    (Row >= 1, 
    Row =< 4
    ;
    write('Invalid Row!'),
    fail
    ).

validate_solid(Piece):-
    write('Solid'),
    read(Solid),
    (    
    % Change input to symbol
    sym_rev(Piece,Solid)
    ;
    write('Invalid Solid!'),
    fail
    ).

loop(Player, Board):-
    nl,
    repeat,
    once(validate_column(Column)),
    once(validate_row(Row)),
    once(validate_solid(Piece)),

    % Move Piece 
    set_piece(Column, Row, Piece,Board,NewBoard),
    display_board(NewBoard, Player).

    %TODO: check end of game (faz fail se nao for GameOver),
    %TODO: Fim de jogo menu (quem ganha, quem perde...)
    

start :-
    write('Inicio do jogo!'),
    %TODO: menu
    write('Pressione qualquer tecla..'),
    get_char(_),
    initial_board(Board),
    random_select(Player,[0,1],_),
    display_game(Board, Player),
    loop(Player, Board).

set_piece(Row, Column, Piece, Current_board, New_board):-
    %TODO: verify free space
    %TODO: verificar se pode colocar tendo em conta a linha, coluna ou quadrante
    set_in_line(Row, Column, Piece, Current_board, New_board).

set_in_line(1, Column, Piece, [Row|Rest], [New_row|Rest]):-
    set_in_column(Column,Piece, Row, New_row).

set_in_line(N, Column, Piece, [Row|Rest], [Row|New_rest]):-
    N>1,
    Next is N - 1,
    set_in_line(Next, Column, Piece , Rest, New_rest).


set_in_column(1, Piece, [_|Rest], [Piece|Rest]).

set_in_column(N, Piece, [X|Rest], [X|New_rest]):-
    N>1,
    Next is N - 1,
    set_in_column(Next, Piece , Rest, New_rest).
