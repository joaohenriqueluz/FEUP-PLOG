symbol(empty,'    ').
symbol(cube_w, wCub).
symbol(cil_w, wCyl).
symbol(cone_w, wCon).
symbol(sph_w, wSph).
symbol(cube_b, bCub).
symbol(cil_b, bCyl).
symbol(cone_b, bCon).
symbol(sph_b, bSph).

sym(Ce):-
    symbol(Ce,S),
    write(S).

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
    write('| '),
    display_row(Row),
    nl,
    write(' ------ ------ ------ ------ '),nl,
    display_rows(Others).

display_board(Board):-
    nl,
    write('\n\n ---------------------------'),
    nl,
    write(' ---------- Board ----------'),
    nl,
    write(' ------ ------ ------ ------ '),
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
    display_board(Board),
    nl,
    write('Next player: '),
    write(Player),
    nl,nl.


