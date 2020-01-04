:-use_module(library(lists)).
cell_symbol(0):- write(' ').
cell_symbol(1):-
    %%write('\x2b1b\').
    put_code(11035).
cell_symbol(2):-
    %%write( '\x25B2\').
    put_code(9650).
cell_symbol(3):-
    %%write('\x25CF\')
    put_code(9679).
cell_symbol(_):- fail.

display_column_number(N,N):-
    C is 64 + N,
    write('  '),
    put_code(C),
    write(' '),
    nl.
display_column_number(I,N):-
    C is 64 + I,
    write('  '),
    put_code(C),
    write(' '),
    NewI is I + 1,
    display_column_number(NewI,N).

display_line(N,N):-
    write('--- '),
    nl.
display_line(I,N):-
    write('--- '),
    NewI is I + 1,
    display_line(NewI,N).

display_board([],_, _,_):-!.

display_board([Head|Tail], 1, N, Line):-
    write(' | '),
    cell_symbol(Head),
    write(' | '),
    write('\n   '),
    display_line(1,N),
    NewLine is Line + 1,
    display_board(Tail, N, N, NewLine).

display_board([Head|Tail], N, N, Line):-
    write(Line),
    write(' | '),
    cell_symbol(Head),
    New is N -1,
    display_board(Tail, New, N, Line).

display_board([Head|Tail], Index, N, Line):-
    write(' | '),
    cell_symbol(Head),
    New is Index -1,
    display_board(Tail, New, N, Line).

display_every(Board, N):-
    append(Board, BoardFlat),
    write('\n\n  '),
    display_column_number(1,N),
    write('   '),
    display_line(1,N),
    display_board(BoardFlat, N, N, 1),nl.


    