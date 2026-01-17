---
layout: post
title: "Nesting interpreters"
date: 2026-01-16
---

# Nesting interpreters

A friend of mine enquired about my experience with Lévy-optimal evaluation of lambda calculus,
to which I replied:

```
I've tried various others and found them horribly slow
on actual benchmarks despite their optimality.
So I prefer simple (and hence non-opimal) runtimes that are pretty
quick in practice, namely combinator graph reduction such as
https://github.com/augustss/MicroHs or my own
https://github.com/tromp/AIT/blob/master/uni.c

There's one thing that I really would like to get more optimal though.
What I notice with combinatory reducers is that you can run nested
binary combinatory logic interpreters
with only additive overhead; each additional interpreter basically
rewrites itself into the higher level one.
That is not the case with all the binary lambda calculus interpreters
I tried, even the ones based on
Kiselyov's direct translation
https://theory.stanford.edu/~blynn/lambda/kiselyov.html

I'd like to know if that is fundamentally impossible or not.
```

My friend understandably asked for clarification on the nesting of interpreters and additive overhead,
and while pondering a reply, I realized this might be of interest to more people, so I decided to
make a blog post about it.

## Universal Lambda Machine

To dive straight in, I've proposed a ULM [1] [2] that reads from a binary input stream
an encoded lambda term, and applies it to the remainder of input.

When the encoded term is itself a lambda calculus interpreter operating as a universal lambda machine,
then the ULM's behaviour on the remaining input is identical to its original behaviour.

Except when behaviour includes performance on actual hardware.
Nesting interpreters normally incur a constant factor slowdown or worse.

This was already noted in my 2012 IOCCC submission where a "Performance" section [4]
compares runtimes with 0,1,2,3, and 4 nested interpreters running a prime number sieve,
incurring slowdowns of respectively 4.4x, 10.0x, 12.2x, and 12.4x.

Let's rerun that experiment with the much more performant (and compilable) uni.c runtime [4],
and with a simpler end-task resulting in a normal form:

```
$ (cat delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 9746 time 0ms steps/s 666M #GC 0 HP 20492
$ (cat uni.blc delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 143176 time 3ms steps/s 47M #GC 0 HP 159806
$ (cat uni.blc uni.blc delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 1554114 time 36ms steps/s 43M #GC 1 HP 539112
$ (cat uni.blc uni.blc uni.blc delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 17928565 time 407ms steps/s 44M #GC 18 HP 282330
$ (cat uni.blc uni.blc uni.blc uni.blc delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 209071006 time 5047ms steps/s 41M #GC 233 HP 518110
$ (cat uni.blc uni.blc uni.blc uni.blc uni.blc delimit.blc; echo -n 1111000111001) | ../uni -b
11010steps 2439995720 time 69617ms steps/s 35M #GC 3407 HP 940096
```

File uni.blc contains the 196 bit encoding of the universal lambda term
(λ11)(λ(λλλ1(λλ2(1(λ6(λ2(6(λλ3(λλ23(14))))(7(λ7(λ31(21)))))))(41(111))))(11))(λ1((λ11)(λ11))).

The delimit program decodes the Levenshtein encoding [5] 1111000111001 of the binary string 11010.
Now we see step slowdowns of 14.7x, 10.9x, 11.5x, 11.7x, and 11.7x.

Now to make the experiment vastly more interesting, let's try nesting binary combinatory logic interpreters instead.

```
$ (cat uniSK.blc delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 62490 time 1ms steps/s 62M #GC 0 HP 78802
$ (cat uniSK.blc uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 119378 time 2ms steps/s 59M #GC 0 HP 127812
$ (cat uniSK.blc uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 158725 time 3ms steps/s 52M #GC 0 HP 145464
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 201786 time 4ms steps/s 50M #GC 0 HP 163116
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 248561 time 4ms steps/s 62M #GC 0 HP 180768
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 299050 time 5ms steps/s 59M #GC 0 HP 198420
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 353253 time 6ms steps/s 58M #GC 0 HP 216072
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 411170 time 7ms steps/s 58M #GC 0 HP 233724
$ (cat uniSK.blc uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl uniSK.bcl delimit.bcl; echo -n 1111000111001) | ../uni -b
11010steps 472801 time 8ms steps/s 59M #GC 0 HP 251376
```

Shockingly, the constant factor slowdown is gone!
The slowdown is now more like an additive one, of 56888, 39347, 43061, 46775, 50489, 54203, 57917, and 61631 steps.

Two contributing factors make this possible.
First, uni.c is a combinatory graph reducer, bulding an acyclic graph of binary application nodes
and combinator leaves, and repeatedly rewriting the graph for combinators applied to sufficiently many arguments.
For a combinator that duplicates arguments, such as S x y z = x z (y z), the z node will be shared as the right
child of both the (newly created) application nodes for x z and for y z.

Second, the combinatory logic binary encoding is exceedingly simple, using 1 for (prefix [6]) application,
10 for K, and 11 for S, allowing for a very simple interpreter that immediately passes an encoded combinator to a given
continuation after reading its code.

Combined, this means that the graph of the interpreter, applied to the graph representing the input stream of bits,
ends up rewriting itself back to the graph of the interpreter. Or mostly, considering the step difference still increases.

The lambda calculus interpreters are not quite so straightforward. After reading the code of a term, what they pass 
to the given continuation is a function that maps an environment of free variables to the encoded term.
This extra mapping prevents the combinator graph from just rewriting itself.

I had hoped that a more direct translation from encoded lambda terms to combinators, based on Oleg Kiselyov's work [7],
could also avoid the constant factor slowdown, but sadly that was not the case.

# Future work

If we replaced the uni.c runtime with a Lévy-optimal lambda evaluator, then supposedly we
should see additive slowdowns, at least in terms of number of beta reductions performed.
But we may also see constant factor slowdowns in the number of beta reductions performed per second,
negating the former. Hopefully we will see more performant optimal evaluators in future,
perhaps based on interaction nets [8],
to continue these experiments with.

I've started work on a binary language that is a hybrid of lambda calculus and combinatory logic,
tentatively called Binary Combinatory Lambda Calculus, or BCLC.
It encodes application as 001, K as 010, S as 011, abstraction as 000, and a De Bruijn index as 1^i0.
This allows one to slowly morph a combinatory logic interpreter into a lambda calculus interpreter,
and see where the "phase transition" from additive slowdown to constant factor slowdown occurs.

# References

[1] [Most functional](https://www.ioccc.org/2012/tromp/)

[2] [Universal Lambda Machine](https://rosettacode.org/wiki/Universal_Lambda_Machine)

[3] [Performance](https://www.ioccc.org/2012/tromp/index.html#performance)

[4] [uni.c](https://github.com/tromp/AIT/blob/master/uni.c)

[5] [Levenshtein code](https://en.wikipedia.org/wiki/Levenshtein_coding)

[6] [Polish notation](https://en.wikipedia.org/wiki/Polish_notation)

[7] [Kiselyov Combinator Translation](https://theory.stanford.edu/~blynn/lambda/kiselyov.html)

[8] [Interaction Nets](https://en.wikipedia.org/wiki/Interaction_nets)
