:- consult('display.pl').
:- consult('logic.pl').
:- consult('validation.pl').
:- use_module(library(random)).
   
start:-
    %TODO: menu
    %human x human
    write('Inicio do jogo!'),
    write('Pressione qualquer tecla..'),
    get_char(_),
    initial_board(Board),
    random_select(Player, [1, 2], _),
    display_game(Board, Player),
    gameLoop(Player, Board).
