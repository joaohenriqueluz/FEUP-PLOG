move_piece(Row, Column, Piece, Current_board, New_board):-
    check_free_space(Row, Column, Current_board),
    %TODO: verificar se pode colocar tendo em conta a linha, coluna ou quadrante
    move_to_line(Row, Column, Piece, Current_board, New_board).

move_to_line(1, Column, Piece, [Row | Rest], [New_row | Rest]):-
    move_to_column(Column, Piece, Row, New_row).

move_to_line(N, Column, Piece, [Row | Rest], [Row | New_rest]):-
    N > 1,
    Next is N - 1,
    move_to_line(Next, Column, Piece , Rest, New_rest).

move_to_column(1, Piece, [_ | Rest], [Piece | Rest]).

move_to_column(N, Piece, [X | Rest], [X | New_rest]):-
    N > 1,
    Next is N - 1,
    move_to_column(Next, Piece , Rest, New_rest).

switch_player(1, 2).
switch_player(2, 1).

next_player(Player, NewPlayer):-
    switch_player(Player, NewPlayer).

gameLoop(Player, Board):-
    repeat,
    once(validate_column(Column)),
    once(validate_row(Row)),
    once(validate_solid(Piece, Player)),

    % Move Piece 
    move_piece(Row, Column, Piece, Board, NewBoard),
    next_player(Player, NewPlayer),
    display_game(NewBoard, NewPlayer),
    gameLoop(NewPlayer, NewBoard).

    %TODO: check end of game (faz fail se nao for GameOver),
    %TODO: Fim de jogo menu (quem ganha, quem perde...)
