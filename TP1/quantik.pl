:- consult('display.pl').
:- consult('logic.pl').
:- consult('validation.pl').
:- use_module(library(random)).
   
start:-
    %TODO: menu
    %human x human
    repeat,
    display_menu,
    read(Option),
    (\+ (var(Option)), number(Option), Option == 1,
    initial_board(Board),
    random_select(Player, [1, 2], _),
    display_game(Board, Player),
    gameLoop(Player, Board)
    ;
    write('\t       Invalid Option! Try again..\n\n'),
    fail).
