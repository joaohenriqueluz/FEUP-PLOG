:- consult('display.pl').
:- consult('logic.pl').
:- consult('validation.pl').
:- consult('utils.pl').
:- use_module(library(random)).
   
play:-
    repeat,
    display_menu,
    read(Option),
    (\+ (var(Option)), number(Option),
    option_chosen(Option)
    ;
    write('\t       Invalid Option! Try again..\n\n'),
    fail).

    option_chosen(1):- 
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        gameLoop(Player, Board, h, h).

    option_chosen(2):- 
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        gameLoop(Player, Board, h, c).

    option_chosen(3):- 
        initial_board(Board),
        random_select(Player, [1, 2], _),
        display_game(Board, Player),
        gameLoop(Player, Board, c, c).
    
    option_chosen(4):-
        write('Exiting game...\n').
