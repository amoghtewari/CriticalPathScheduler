% checks and returns true/false is list is empty/nonempty
list_empty([], true).
list_empty([_|_], false).

% list_sum(X,Y,Z) binds sums of individual elements of lists X and Y to Z.
list_sum([],[],[]).
list_sum([],[Y|Ys],[Z|Zs]) :- Z is 0+Y , list_sum( [] , Ys , Zs ) .
list_sum([X|Xs],[],[Z|Zs]) :- Z is X+0 , list_sum( Xs , [] , Zs ) .
list_sum([X|Xs],[Y|Ys],[Z|Zs]) :- list_sum(X,Y,Z) , list_sum( Xs , Ys , Zs ) .
list_sum(X,Y,Z) :- Z is X + Y.


% list_sum(X,Y,Z) binds difference of individual elements of lists X and Y to Z. X-Y =Z
list_diff([],[],[]).
list_diff([],[Y|Ys],[Z|Zs]) :- Z is 0-Y , list_diff( [] , Ys , Zs ) .
list_diff([X|Xs],[],[Z|Zs]) :- Z is X-0 , list_diff( Xs , [] , Zs ) .
list_diff([X|Xs],[Y|Ys],[Z|Zs]) :- list_diff(X, Y, Z) , list_diff( Xs , Ys , Zs ) .
list_diff(X, Y, Z):- Z is X - Y.

%remove_list(A,B,C) binds the difference of the sets of elements in A and B to Z
remove_list([], _, []).
remove_list([X|Tail], L2, Result):- member(X, L2), !, remove_list(Tail, L2, Result). 
remove_list([X|Tail], L2, [X|Result]):- remove_list(Tail, L2, Result).

% max(List, A) binds max of List to A.
max([],X):-
	X = 0.
max([H|T], Y):-  
    max(T,Y),
    H < Y.
max([H|T], H):-
    max(T,Y),
    H >= Y.
max([X],X).

% list_min(List, A) binds min of List to A. In bottom case, we take latest finishing time of all tasks.
list_min([], Min):-
	findall(B, prerequisite(A, B), PrereqsR),
	findall(K, duration(K, Y), Tasks),
	remove_list(Tasks, PrereqsR, A),
	nth0(0, A, P),
	earlyFinish(P, Min).

list_min([A|[]], Min) :-
	Min is A.

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
%    Min1 is min(L, Min0),
	list_min(L, Min1),
	MINX is min(Min0, Min1),
	list_min(Ls, MINX, Min).

% bottom out cases where prerequisite is passed lists
prerequisite([A], [B]):-
	prerequisite(A, B).

prerequisite([], []).

prerequisite([H1|T1], [H2, T2]):-
	prerequisite(H1, H2).
	prerequisite(T1, T2).


% bottom out cases where duration is passed lists
durationX([A|[]], [B|[]]):-
	duration(A, B).

durationX([H1|T1], [H2, T2]):-
	durationX([H1], [H2]),
	durationX(T1, T2).

durationX([], []).

% earlyStart(Task, Time) binds earliest starting time of Task to Time.
earlyStart([A], [B]):-
	earlyStart(A, B).

earlyStart([], []).

earlyStart([H1|T1], [H2, T2]):-
	earlyStart(H1, H2),
	earlyStart(T1, T2).

earlyStart(X1, Time):-
	findall(Z1, prerequisite(X1, Z1), Prereqs),
	earlyStart(Prereqs, Times),
	durationX(Prereqs, Durations),
	list_sum(Times, Durations, PossibleES),
	max(PossibleES, Time).

% earlyFinish(Task, Time) binds earliest finishing time of Task to Time.
earlyFinish(X, Time):-
	earlyStart(X, Y),
	duration(X, Z),
	Time is Y + Z.

% lateFinish(Task, Time) binds latest finishing time of Task to Time.
lateFinish([A], [B]):-
	lateFinish(A, B).

lateFinish([], []).

lateFinish([H1|T1], [H2, T2]):-
	lateFinish(H1, H2),
	lateFinish(T1, T2).

lateFinish(X1, Time):-
	findall(Z1, prerequisite(Z1, X1), Prereqs),
	lateFinish(Prereqs, Times),
	durationX(Prereqs, Durations),
	list_diff(Times, Durations, PossibleLF),
	list_min(PossibleLF, Time).

% lateStart(Task, Time) binds latest starting time of Task to Time.
lateStart(X, Time):-
	lateFinish(X, Y),
	duration(X, Z),
	Time is Y-Z.

% criticalPath(Task, Path) evaluates to true if and only if path is an ordered list of critical path to Task. 
criticalPath(Task, [TaskX|[]]):-
	Task == TaskX.

criticalPath(Task, [H|T]):-
	criticalPath(Task, H),
	criticalPath(Task, T).

criticalPath(TaskA, TaskB):-
	earlyStart(TaskA, ESA),
	earlyStart(TaskB, ESB),
	lateStart(TaskA, LSA),
	lateStart(TaskB, LSB),
	equality(ESA,LSA),
	equality(ESB,LSB),
	greTEQ(ESA,ESB).

%helper predicates
equality([], []).
equality([X], X).
equality([X], A):-
	X==A.

equality([H1]|[], X):-
	equality(H1, X).
equality([H1|[]], [H2|[]]):-
	equality(H1, H2).
equality(A,B):-
	A==B.

greTEQ([],[]).
greTEQ([X], X).
greTEQ([H1]|[], X):-
	greTEQ(H1, X).
greTEQ([H1|[]], [H2|[]]):-
	greTEQ(H1, H2).

greTEQ(A,B):-
	A>=B.

% slack(Task, Time) binds slack of Task to Time.
slack([], []).
slack([A], [B]):-
	slack(A,B).
slack([H1|T1], [H2|T2]):-
	slack([H1], [H2]),
	slack(T1, T2).

slack([A|[]], [B|[]]):-
	slack(A,B).

slack(A, X):-
	lateStart(A, LS),
	earlyStart(A, ES),
	X is LS - ES.

% maxSlack(Task, Time) evaluates to true if and only if Time is the maximum slack of any all tasks in DB and Task's slack is equal to Time.
maxSlack(Task, Time):-
	findall(K, duration(K, Y), Tasks),
	slack(Tasks, Slacks),
	max(Slacks, MS),
	slack(Task, MS),
	Time == MS.









	