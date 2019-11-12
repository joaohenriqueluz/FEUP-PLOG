show_records([]):- write('vazio'),nl.
show_records([A|B]) :-
    %cell_symbol(X,A),
    write('**'),
  display_game(A, 1),write('**'),nl,
  show_records(B). 

list_empty([], true).
list_empty([_|_], false).


append_lists([],L,L).
append_lists([X|L1],L2,[X|L3]):- append_lists(L1,L2,L3). 
