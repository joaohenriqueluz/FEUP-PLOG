diagonal(1,1,2,2).
diagonal(2,1,1,2).

diagonal(1,3,2,4).
diagonal(2,3,1,4).

diagonal(3,1,4,2).
diagonal(4,1,3,2).

diagonal(3,3,4,4).
diagonal(4,3,3,4).

%%%%%% INPUT %%%%%%
check_column('A', 1).
check_column('B', 2).
check_column('C', 3).
check_column('D', 4).

symb_of_player(cube_w, 1).
symb_of_player(cil_w, 1).
symb_of_player(cone_w, 1).
symb_of_player(sph_w, 1).
symb_of_player(cube_b, 2).
symb_of_player(cil_b, 2).
symb_of_player(cone_b, 2).
symb_of_player(sph_b, 2).

symb_solid(cube_w, cube).
symb_solid(cil_w, cylinder).
symb_solid(cone_w, cone).
symb_solid(sph_w, sphere).
symb_solid(cube_b, cube).
symb_solid(cil_b, cylinder).
symb_solid(cone_b, cone).
symb_solid(sph_b, sphere).

list_empty([]).

append_lists([],L,L).
append_lists([X|L1],L2,[X|L3]):- append_lists(L1,L2,L3).