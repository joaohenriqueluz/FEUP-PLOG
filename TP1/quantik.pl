:- consult('display.pl').
:- consult('logic.pl').
:- consult('validation.pl').
:- consult('utils.pl').
:- use_module(library(random)).
:- use_module(library(system)).
   
play:-
    repeat,
    display_menu,
    read(Option),
    (\+ (var(Option)), number(Option),
    option_chosen(Option)
    ;
    write('\t       Invalid Option! Try again..\n\n'),
    fail)
    .

    option_chosen(1):- 
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        game_loop(Player, Board, h, h,_).

    option_chosen(2):- 
        ask_level(Level),
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        game_loop(Player, Board, h, c, Level).

    option_chosen(3):- 
        ask_level(Level),
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        game_loop(Player, Board, c, c,Level).
    
    option_chosen(4):-
        write('Exiting game...\n').

    %TODO: nivel de dificuldade
    ask_level(Level):-
        display_level,
        read(Level),
        (\+ (var(Level)), number(Level),
        dificulty_level(Level)
        ;
        write('\t       Invalid Option! Try again..\n\n'),
        fail).
    dificulty_level(1).

    dificulty_level(2).

