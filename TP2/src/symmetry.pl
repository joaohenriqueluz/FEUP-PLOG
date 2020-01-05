:-use_module(library(clpfd)).
:-use_module(library(random)).
:-include('display.pl').

%%% GENERATOR %%%
symmetry(N, FinalBoard):-
    set_prolog_flag(double_quotes, codes),
    length(Board, N), 
    maplist(same_length(Board), Board),
    solve_symmetry(Board, N),
    create_puzzle(Board, N, FinalBoard),
    write('\nA new puzzle is: '),
    write(FinalBoard),
    display(FinalBoard, N), !.

% Removes random pieces from chosen board
create_puzzle(Board, N, FinalBoard):-
    N2 is N*N,
    Min is round(N2/4.0),
    Max is round(N2/1.5), 
    random(Min, Max, NumPieces),
    removePieces(NumPieces, N, Board, FinalBoard).

% Removes NumPieces pieces from board
removePieces(0, _, Board,  Board).
removePieces(NumPieces, N, Board,  FinalBoard):-
    random(1, N, Line),
    random(1, N, Column),
    replace(Line, Column, Board, NewBoard),
    NPieces is NumPieces -1,
    removePieces(NPieces, N, NewBoard, FinalBoard).

% Replaces board element in a specific line and column with a variable
replace(Line, Column, Board, NewBoard):-
    replace_in_line(Line, Column, Board, NewBoard).

replace_in_line(1, Column, [Row | Rest], [NewRow | Rest]):-
    replace_in_column(Column, Row, NewRow).
replace_in_line(N, Column, [Row | Rest], [Row | NewRest]):-
    N > 1,
    Next is N - 1,
    replace_in_line(Next, Column, Rest, NewRest).

replace_in_column(1, [_ | Rest], [0 | Rest]).
replace_in_column(N, [X | Rest], [X | NewRest]):-
    N > 1,
    Next is N - 1,
    replace_in_column(Next , Rest, NewRest).

% Chooses random board
selRandom(Var, _, BB0, BB1):-                   
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value, List),
    (first_bound(BB0, BB1), Var #= Value ;
    later_bound(BB0, BB1), Var #\= Value ).

%%% SOLVER %%%
symmetry(Board):-
    set_prolog_flag(double_quotes, codes),
    length(Board, N),
    maplist(replace_zeros, Board, VarBoard),
    (solve_symmetry(VarBoard, N),
    write('\nSolution is: '),
    display(VarBoard,N), !;
    write('\nNo solution found!\n'), !).

% Replaces zeros with decision variables
replace_zeros([], []).
replace_zeros([0|Tail], [_|Rest]) :- replace_zeros(Tail, Rest).
replace_zeros([H|Tail], [H|Rest]):- replace_zeros(Tail, Rest).

solve_symmetry(Lines, N):-
    reset_timer,
    N2 is N * N,
    N4 is N2 + 2*N,
    N8 is N2 + 4*N,
    length(Columns, N), 
    maplist(same_length(Columns), Columns),
    length(LinesUni, N2), 
    length(AlmostFinal, N4),
    length(Final, N8), 

    line_constraints(N, Lines, N, [], CountersL),
    transpose(Lines, Columns),
    line_constraints(N, Columns, N, [], CountersC),
    append(Lines, LinesUni),
    append(LinesUni, CountersL, AlmostFinal),
    append(AlmostFinal, CountersC, Final),
    labeling([value(selRandom)], Final),
    %labeling([], Final),
    %labeling([middle, max_regret], Final),
    %labeling([value(selRandom), occurrance], Final),
    %labeling([median, ff], Final),
    %labeling([bisect,min], Final),
    print_time,
	fd_statistics.

% Checks if List is a palindrome
check_palindrome(List, Counter1, Counter2):-
    reverse(List, ReversedList),
    palind_automaton(List, Counter1),
    palind_automaton(ReversedList, Counter2),
    Counter1 #= Counter2.

% Automaton to remove zeros from List
palind_automaton(List, Counter):-
    palind_signature(List, Sign),
    automaton(Sign, _, Sign,
        [source(i), sink(i)],
        [arc(i,0,i),
         arc(i,1,i, [C*10 + 1]),
         arc(i,2,i, [C*10 + 2]),
         arc(i,3,i, [C*10 + 3])],
        [C], [0], [Counter]).    

palind_signature([],[]).
palind_signature([X|Xs], [S|Ss]) :-
    S in 0..3,
    X#=0 #=> S#=0,
    X#=1 #=> S#=1,
    X#=2 #=> S#=2,
    X#=3 #=> S#=3,
    palind_signature(Xs,Ss).

% Constraints for all lines
line_constraints(0, _, _, Counters, Counters).
line_constraints(Index, Board, N, Counters, FinalCounters):-
    nth1(Index, Board, Line),
    domain(Line, 0, 3),
    check_palindrome(Line, Counter1, Counter2),
    append(Counters, [Counter1], NC),
    append(NC, [Counter2], NNC),
    NewIndex is Index-1,
    line_constraints(NewIndex, Board, N, NNC, FinalCounters).

%% Statistics %%
reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.
