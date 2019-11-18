rel("OED", isa, dictionary).
rel("Webster's", isa, dictionary).
rel("Johnston's", isa, dictionary).

rel("Flour Water Salt Yeast", isa, cookbook).

rel("The Guide", isa, novel).

rel(dictionary, subset, nonfiction).
rel(cookbook, subset, nonfiction).
rel("Michael Strogoff", isa, fiction).
rel(novel, subset, fiction).

rel(fiction, subset, book).
rel(nonfiction, subset, book).

rel(X, isa, Z) :-
	rel(Y, subset, Z),
	rel(X, isa, Y).

rel(X, isa, Z) :-
	rel(K, subset, Z),
	rel(Y, subset, K),
	rel(X, isa, Y).

editor(X,Y):-
	rel(X, isa, book).

author("Michael Strogoff", "Jules").
author(OED, false).
author("Johnston's", "Noah").
author("Webster's", "Samuel").
author("The Guide", "RK").

author(X, Y):-
	rel(X, isa, fiction).

volumes("OED", 20).

volumes(X, Y):-
	rel(X, isa, book).
	Y is 1.

agreesWith("Johnston's","Webster's").
agreesWith("Webster's","Johnston's").
agreesWith("Johnston's","OED").
