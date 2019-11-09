/**
*
*
*
*/

/*		PARSER		*/
	/*NEEDS TESTS*/
who(Words, Ref) :- np(Words, Ref).

/* Noun phrase can be a proper name or can start with an article */

np([Name],Name) :- proper_noun(Name).
np([Art|Rest], Who) :- article(Art), np2(Rest, Who).


/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],Who) :- adjective(Adj,Who), np2(Rest, Who).
np2([Noun|Rest], Who) :- common_noun(Noun, Who), mods(Rest,Who).


/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, Who) :-
	appendLists(Start, End, Words),
	prepPhrase(Start, Who),	mods(End, Who).

prepPhrase([Prep|Rest], Who) :-
	preposition(Prep, Who, Ref), np(Rest, Ref).

appendLists([], L, L).
appendLists([H|L1], L2, [H|L3]) :-  appendLists(L1, L2, L3).
	/* COPPIED FROM A4 DOC IN D2L */

	
/*		LEXICON		*/
	/*SHOULD BE GOOD*/
article(a).
article(the).
article(any).

adjective(small,X) :- size(X,small).
adjective(medium,X) :- size(X,medium).
adjective(big,X) :- size(X,big).
adjective(large,X) :- size(X,large).
adjective(huge,X) :- size(X,huge).

adjective(blue,X) :- colour(X,blue).
adjective(yellow,X) :- colour(X,yellow).
adjective(orange,X) :- colour(X,orange).
adjective(pink,X) :- colour(X,pink).
adjective(red,X) :- colour(X,red).
adjective(green,X) :- colour(X,green).

common_noun(wedge,X) :- shape(X,wedge).
common_noun(block,X) :- block(X).
common_noun(pyramid,X) :- shape(X,pyramid).
common_noun(cube,X) :- shape(X,cube).
common_noun(table,X) :- table(X).

preosition(on,X,Y) :- locatedOn(X,Y).
preosition(beside,X,Y) :- beside(X,Y).
preosition(below,X,Y) :- above(Y,X).
preosition(above,X,Y) :- above(X,Y).

/* 		WORDS NEEDED IN EXAMPLES
 *  a, the, any 				article
 * huge, small, big, large, medium		adj
 * blue, yellow, orange, pink, red, green	adj
 * wedge, block, pyramid, cube, table		common nouns
 * on, beside, below, above			prepositions
 */

/* 		DATABASE		*/
	/*AND OF COURSE PREDICATES NEED WORK*/
table(table1).
table(table2).
table(table3).
table(table4).
table(table5).
table(table6).
block(b1).
block(b2).
block(b3).
block(b4).
block(b5).
block(b6).
block(b7).
block(b8).
block(b9).
block(b10).
block(b11).
block(b12).
block(b13).

justLeftOf(table1,table2).
justLeftOf(table2,table3).
justLeftOf(table3,table4). 
justLeftOf(table4,table5). 
justLeftOf(table5,table6).

locatedOn(b1,a1). %A1
locatedOn(b2,a4). %A4
locatedOn(b3,b1).
locatedOn(b4,b3).
locatedOn(b5,a2). %A2
locatedOn(b6,a3). %A3
locatedOn(b7,a5). %A5
locatedOn(b8,b5).
locatedOn(b9,b6).
locatedOn(b10,b9).
locatedOn(b11,b10).
locatedOn(b12,b7).
locatedOn(b13,b12).
		  %NOBODY ON A6

colour(b1,blue).
colour(b2,green).
colour(b3,yellow).
colour(b4,green).
colour(b5,pink).
colour(b6,orange).
colour(b7,pink).                 
colour(b8,red).
colour(b9,green).
colour(b10,blue).
colour(b11,yellow).
colour(b12,pink).
colour(b13,red).

size(b1,large).
size(b2,small).
size(b3,large).
size(b4,small).
size(b5,large).
size(b6,small).
size(b7,huge).
size(b8,large).
size(b9,large).
size(b10,medium).
size(b11,large).
size(b12,medium).
size(b13,small).

shape(b1,cube).
shape(b2,pyramid).
shape(b3,cube).
shape(b4,wedge).
shape(b5,cube).
shape(b6,cube).
shape(b7,cube).
shape(b8,wedge).
shape(b9,cube).
shape(b10,cube).
shape(b11,wedge).
shape(b12,cube).
shape(b13,pyeramid).

beside(X,Y) :- locatedOn(X,A1), locatedOn(Y,A2), justLeftOf(A1,A2).
beside(X,Y) :- locatedOn(X,A1), locatedOn(Y,A2), justLeftOf(A2,A1).
above(X,Y) :- locatedOn(X,Y).
above(X,Y) :- locatedOn(X,Z), above(Z,Y).

blockLeft(X,Y) :- locatedOn(X,A1), locatedOn(Y,A2), justLeftOf(A2,A1). %reads "X is the block left of Y"
leftOf(X,Y) :- blockLeft(Y,X). % if "X is left of Y" then "Y is the block left of X" 
leftOf(X,Y) :- blockLeft(Y,Z), leftOf(Z,X), Z\=X,Z\=Y.
%leftOf(X,Y) :- leftOf(X,Z), above(Y,Z).

blockRight(X,Y) :- locatedOn(X,A1), locatedOn(Y,A2), justLeftOf(A1,A2), A1\=A2. %reads "X is the block left of Y"

rightOf(X,Y) :- blockRight(Y,X). % if "X is right of Y" then "Y is the block left of X"
rightOf(X,Y) :- blockRight(X,Z), rightOf(Z,Y).
%rightOf(X,Y) :- rightOf(X,Z), above(Y,Z).

