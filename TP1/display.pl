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

cell_symbol(empty,'    ').
cell_symbol(cube_w, wCub).
cell_symbol(cil_w, wCyl).
cell_symbol(cone_w, wCon).
cell_symbol(sph_w, wSph).
cell_symbol(cube_b, bCub).
cell_symbol(cil_b, bCyl).
cell_symbol(cone_b, bCon).
cell_symbol(sph_b, bSph).
cell_symbol(_, _):- fail.

write_symbol(Cell):-
    cell_symbol(Cell, Symb),
    write(Symb).

player('1 - White Pieces', 1).
player('2 - Black Pieces', 2).

display_row([]):- !.

display_row([Cell | RestRow]):-
    write_symbol(Cell),
    write(' | '),
    display_row(RestRow).

display_rows([],_):- !.

display_rows([Row | OtherRows],RowNumber):-
    format('\t|  ~d  | ',RowNumber),
    NewRowNumber is RowNumber + 1,
    display_row(Row), 
    format(' ~d  |',RowNumber), nl,
    write('\t ----- ------ ------ ------ ------ ------ \n'),
    display_rows(OtherRows, NewRowNumber).
    
display_meanings:-
    write('Meanings:\n'),
    write('wCyl -> White cylinder\t\t'),
    write('bCyl -> Black cylinder\n'),

    write('wCub -> White cube\t\t'),
    write('bCub -> Black cube\n'),

    write('wCon -> White cone\t\t'),
    write('bCon -> Black cone\n'),

    write('wSph -> White sphere\t\t'),
    write('bSph -> Black sphere\n\n').

display_board(Board):-
    write('\n\n\n\t       ---------------------------\n'),
    write('\t       ---------- Board ----------\n'),
    write('\t       ---------------------------\n\n'),
    write('\t       ------ ------ ------ ------\n'),
    write('\t      |  A.  |  B.  |  C.  |  D.  |\n'),
    write('\t ----- ------ ------ ------ ------ -----\n'),
    display_rows(Board,1),
    write('\t      |  A.  |  B.  |  C.  |  D.  |\n'),
    write('\t       ------ ------ ------ ------\n'),
    display_meanings.

display_game(Board, Player):-
    %write('\33\[2J'),
    display_board(Board),
    write('Next player: '),
    player(PlayerDisplay, Player),
    write(PlayerDisplay),
    nl, nl, nl.

final_display_game(Board, Player):-
    write('\33\[2J'),
    display_board(Board),
    write('**Winner: Player '),
    player(PlayerDisplay, Player),
    write(PlayerDisplay),
    write('**\n').

display_menu:-
    write('\t       ---------------------------\n'),
    write('\t      |          QUANTIK          |\n'),
    write('\t      |        1:New Game         |\n'),
    write('\t      |        2:Exit Game        |\n'),
    write('\t       ---------------------------\n').
