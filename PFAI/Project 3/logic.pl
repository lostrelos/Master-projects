/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:4; tab-width:8; -*- 
Logic Assignment

Author: Tony Lindgren

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1: Usage of Knowledgbase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

belongs_to(harry_potter, gryffindor).
belongs_to(hermione_granger, gryffindor).
belongs_to(cedric_diggory, hufflepuff).
belongs_to(draco_malfoy, slytherin).
wand(harry_potter, '11"_holly_phoenix').
wand(harry_potter, '11"_vine_dragon').
wand(harry_potter, '10"_blackthorn_unknown').
wand(harry_potter, '10"_hawthorn_unicorn').
wand(harry_potter, '15"_elder_thestral_hair').
wand(hermione_granger, '11"_vine_dragon_heartstring').
wand(hermione_granger, '13"_walnut_dragon_heartstring').
wand(cedric_diggory, '12"_ash_unicorn_hair').
wand(draco_malfoy, '10"_hawthorn_unicorn_hair').
wand(draco_malfoy, '15"_elder_thestral_hair').
patronus(harry_potter, stag).
patronus(hermione_granger, otter).
boggart(harry_potter,dementor).
boggart(hermione_granger,failure).
boggart(draco_malfoy,lord_voldemort).
loyalty(harry_potter, gryffindor).
loyalty(harry_potter, hermione_granger).
loyalty(hermione_granger, gryffindor).
loyalty(hermione_granger, harry_potter).
loyalty(cedric_diggory, hufflepuff).
loyalty(cedric_diggory, harry_potter).
influence(harry_potter, hermione_granger).
influence(hermione_granger, harry_potter).
influence(cedric_diggory, hermione_granger).
influence(cedric_diggory, harry_potter).
influence(draco_malfoy, hogwarts).
influence(hogwarts, gryffindor).
influence(hogwarts, slytherin).
influence(hogwarts, hufflepuff).
influence(hogwarts, harry_potter).
influence(hogwarts, hermione_granger).
influence(hogwarts, cedric_diggory).
influence(hogwarts, draco_malfoy).

% trans_influence(X, Y) X influnces Y through some other object Z
trans_influence(X,Y) :-
        influence(X,Z),
        influence(Z,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2: Define set and handle terms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define predicates to handle sets 


to_set([], []).
                
to_set([H | T], [H | Set]) :-
    \+ mmember(H, T),
    to_set(T, Set).

to_set([H | T], Set) :-
    mmember(H, T),
    to_set(T, Set).

%mmember(X, [X|_]).
%mmember(X, [_|T]):-
       % mmember(X,T).

mmember(E, [E|_]).
mmember(E, [X|Xs]) :-
    E \== X,
    mmember(E, Xs).


union([],[],[]).

union(L1,L2,S) :-
               aappend(L1,L2,R),
               to_set(R,S).

aappend([], L, L).
aappend([H | T], L2, [H | Result]) :-
    aappend(T, L2, Result).

intersection([], _, []).
intersection([H | T], L2, [H | S]) :-
    mmember(H, L2),
    intersection(T, L2, I),
    to_set(I,S).
intersection([_ | T], L2, S) :-
    intersection(T, L2, I),
    to_set(I,S).
intersection_set(L1, L2, S) :-
    intersection(L1, L2, I),
    to_set(I, S).


diff(L1,L2,S) :-
        to_set(L1,Set1),
        to_set(L2, Set2),
        diff_set(Set1,Set2,S).
diff_set([],_,[]).
diff_set([H|T],L2,S) :-
    mmember(H,L2),
    diff_set(T,L2,S).
diff_set([H|T],L2,[H|S]) :-
    \+ mmember(H,L2),
    diff_set(T,L2,S).
    
subset([],_).
subset([H|T],L2) :-
        mmember(H,L2),
        subset(T,L2).
        
        
        

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3: Monkey and banana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This predicate initialises the search for a solution to the problem. 
% The 1st argument of solve/4 is the initial state, 
% the 2nd the goal statepaint,
% the 3rd is a temporary list of actions creating the plan, initially empty 
% the 4th the plan that will be produced.

start(Plan):-   
    solve([on(monkey,floor),on(box,floor),at(monkey,a),at(box,b),
           at(bananas,c),at(stick,d),status(bananas,hanging)],
           [status(bananas,grabbed)], [], Plan).

% This predicate produces the plan. Once the Goal list is a subset 
% of the current State the plan is complete and it is written to 
% the screen using write_sol/1.

solve(State, Goal, Sofar, Plan):-
        op(Op, Preconditions, Delete, Add),

        % TODO 1:
        % Check if an operator can be utilized or not
        % predicate_name(Preconditions, State)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Define a predicate that becomes true if:  
        %       all members of Preconditions are part of current State (State) 
        % and return false otherwise
        check_operator(Preconditions, State),
                        
    
        % TODO 2:
        % Test to avoid using the operator multiple times 
        % (To avoid infinite loops, in more comlex problems this is often implemented via states)
        % predicate_name(Op, Sofar)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Define a predicate that checks if Op has been done before
        % if so the predicate should fail otherwise be true 
        avoid_multiple(Op, Sofar),
        
        % TODO 3: 
        % First half of applying an operator  
        % predicate_name(State, Delete, Remainder),
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Define a predicate that removes all members of the Delete list 
        % from the state and the results are returned in the Reminder 
        apply_operator(State, Delete, Remainder),
               
   
        append(Add, Remainder, NewState),
        % Useful for debugging (de-comment to see output) 
        %format('Operator:~w ~N', [Op]),    
        %format('NewState:~w ~N', [NewState]),
        solve(NewState, Goal, [Op|Sofar], Plan).

solve(State, Goal, Plan, RPlan):-
        % TODO 4:
        % add a check if State is a subset of Goal here
        subset(Goal, State), 
        reverse(Plan,RPlan).

% TODO 5: 
% reverse(Plan,RPlan) - define this predicate which returns a reversed list
reverse([],[]).
reverse([H|T], R) :-
    reverse(T, RT),
    aappend(RT, [H], R).
        
% The operators take 4 arguments
% 1st arg = name
% 2nd arg = preconditions
% 3rd arg = delete list
% 4th arg = add list.

op(swing(stick),
    [on(monkey,box), at(monkey,X), at(box,X), holding(monkey,stick), at(bananas,X), status(bananas,hanging)],
    [status(B,hanging)],
    [status(B,grabbed)]).

op(grab(stick),
        [at(monkey,X), at(stick, X), on(monkey,floor)],
        [at(stick, X)],
        [holding(monkey,stick)]).

% TODO 6: 
% op(climbon(box) - define this operator  
op(climbon(box),
    [at(monkey, X), at(box, X), on(monkey, floor)],
    [on(monkey,floor)],
    [on(monkey, box)]).

% TODO 7:
% op(push(box,X,Y) - define this  
op(push(box, X, Y),
    [at(monkey, X), at(box, X), on(monkey, floor)],
    [at(box, X), at(monkey, X)],
    [at(box, Y), at(monkey,Y)]):-
    X \== Y.

op(go(X,Y),
        [at(monkey,X), on(monkey,floor)],
        [at(monkey,X)],
        [at(monkey,Y)]):- 
        X \== Y.

% Helper predicates
check_operator([], _).
check_operator([H|Preconditions], State) :-
    mmember(H, State),
    check_operator(Preconditions, State).

avoid_multiple(Op, Sofar):-
    \+ mmember(Op, Sofar).

apply_operator(State, Delete, Remainder):-
      diff(State,Delete,Remainder).
