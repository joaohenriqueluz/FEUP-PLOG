# Symmetry

## Authors

* Liliana Almeida, up201706908@fe.up.pt, [GitHub](https://github.com/lilianalmeida)

* João Henrique Luz, up201703782@fe.up.pt, [GitHub](https://github.com/joaohenriqueluz)

------

## Instructions

1. In  *SICStus Prolog*, consult the file symmetry.pl.

    * To generate a puzzle write the following instruction, where N is the number of lines/columns of the board and the Board is the matrix of the created puzzle:

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _?- symmetry(+N, -Board)._
    
    * To solve a puzzle execute write the following instruction, where Board is the matrix of the puzzle to be solved (you can use a puzzle received with the previous action):

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _?- symmetry(+Board)._
 
