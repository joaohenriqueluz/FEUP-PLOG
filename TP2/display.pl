cell_symbol(empty):- write(' ').
cell_symbol(square):-
    write('\x2b1b\').
cell_symbol(triangle):-
    write( '\x25B2\').
cell_symbol(circle):-
    write('\x26ab\').
cell_symbol(_):- fail.

display_board([],_, _):-!.

display_board([Head|Tail], 1, N):-
    cell_symbol(Head),
    write('\n'),
    display_board(Tail, N, N).

display_board([Head|Tail], Index, N):-
    cell_symbol(Head),
    write(' '),
    New is Index -1,
    display_board(Tail, New, N).

example_board(5, [empty,empty,empty,triangle, square,
empty,empty,empty,square,empty,
circle,circle,circle,empty,circle,
empty,triangle,triangle,empty,circle,
empty,empty,square,empty,empty]).

symmetry:-
    set_prolog_flag(double_quotes, codes),
    example_board(5,Board),
    display_board(Board, 5, 5).

    