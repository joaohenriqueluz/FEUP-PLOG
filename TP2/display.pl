cell_symbol(empty):- write(' ').
cell_symbol(square):-
    %%write('\x2b1b\').
    put_code(11035).
cell_symbol(triangle):-
    %%write( '\x25B2\').
    put_code(9650).
cell_symbol(circle):-
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


example_board(5, [empty,empty,empty,triangle, square,
empty,empty,empty,square,empty,
circle,circle,circle,empty,circle,
empty,triangle,triangle,empty,circle,
empty,empty,square,empty,empty]).

symmetry:-
    set_prolog_flag(double_quotes, codes),
    example_board(5,Board),
    write('  '),
    display_column_number(1,5),
    write('   '),
    display_line(1,5),
    display_board(Board, 5, 5, 1).


    