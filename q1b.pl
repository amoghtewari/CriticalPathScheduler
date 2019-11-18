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


