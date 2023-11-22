---
layout: post
title: "The largest number representable in 64 bits"
date: 2023-03-25
---

```
┬─┬─────────┬─┬─┬ ┬─┬──
└─┤ ──┬──── │ │ │ ┼─┼─┬
  │ ──┼─┬── │ │ │ │ ├─┘
  │ ┬─┼─┼─┬ │ │ │ ├─┘  
  │ └─┤ │ │ │ │ │ │    
  │   └─┤ │ │ │ │ │    
  │     ├─┘ │ │ │ │    
  └─────┤   │ │ │ │    
        └───┤ │ │ │    
            └─┤ │ │    
              └─┤ │    
                └─┘    
```
Most people believe 18446744073709551615, or 0xFFFFFFFFFFFFFFFF in hexadecimal,
to be the largest number representable in 64 bits. Which is indeed the case if
we are talking about 64 bit unsigned integers such as represented by the
datatype uint64_t in C or u64 in Rust. We can reach quite a bit further with
floating point values. The 64-bit
[double floating point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
finds its largest (finite) representable value in the 309 digit number
2<sup>1024</sup>(1-2<sup>-53</sup>) = 17976931...24858368.

What if we allow representations beyond mere datatypes? Such as a program small
enough to fit in 64 bits. For most programming languages, there is very little
you can do in so few bits. 64 bits is only 8 characters or bytes after all.

In the C language that only leaves you with "main(){}", which doesn't do much.
But there are plenty languages that require no such scaffolding. For instance,
on Linux there is bc, an arbitrary precision calculator language. It happily
computes the 954242 digit number 9^999999 = 35908462...48888889, which can thus
be said to be representable in 64 bits. We can imagine a similar language
featuring the symbol ! for computing factorials, which makes 9!!!!!!! a much
larger number representable in 64 bits.

Allowing such primitives feels a bit like cheating though. Would we allow a
language that has the [Ackerman function](https://en.wikipedia.org/wiki/Ackermann_function)
predefined, which sports the 8 byte expression ack(9,9) representing a truly huge number?

## No primitives needed

As it turns out, the question is moot. There are simple languages with no built
in primitives of any kind. Not even primitives for arithmetic. Not even numbers
themselves. Languages in which all those must be defined from scratch. One such
language allows us to blow way past ack(9,9) in under 64 bits. But let's first
look at another such language, one that has been particularly well studied for
producing largest possible outputs. That is the language of
[Turing machines](https://en.wikipedia.org/wiki/Turing_machine).

## Busy Beaver

The famous [Busy Beaver](https://en.wikipedia.org/wiki/Busy_beaver)
 function, [introduced](https://archive.org/details/bstj41-3-877/mode/2up) by
i[Tibor Radó](https://en.wikipedia.org/wiki/Tibor_Rad%C3%B3) in 1962, which we'll
denote BB<sub>TM</sub>(n), is defined as the maximum number of 1s that can be written with
an n state TM starting from an all 0 tape before halting. Note that if we
consider this output as a number M written in binary, then it only gets
credited for its length, which is log2(M+1).

With 64 bits, we can fully specify a 6 state binary Turing machine, or TM for
short. For each of its internal states and each of its 2 tape symbols, we can
specify what new tape symbol it should write in the currently scanned tape
cell, whether to move the tape head left or right, and what new internal state,
or special halt state, to transition to. That takes 6\*2\*(2+⌈log2(6+1)⌉) = 60
bits, leaving 4 bits to spare. 7 state TMs take 7\*2\*(2+log2(7+1)) = 70 bits
to describe in a straightforward manner, exceeding our budget. Just how big an
output can we produce on a 6 state TM?

The best known result for 6 states is
[BB<sub>TM</sub>(6) >= 10↑↑15](https://www.sligocki.com/2022/06/21/bb-6-2-t15.html),
which denotes an
exponential tower of fifteen 10s. Clearly, in this notation there's not that
much difference between a number and its size in bits. Large as this number is,
it's still pathetically small compared to the earlier ack(9,9). To surpass
that, we need to move beyond the language of Turing machines, into the language
of [Lambda Calculus](https://en.wikipedia.org/wiki/Lambda_calculus).

## Lambda Calculus

A 63 bit program in this language represents a number unfathomably larger than
not only ack(9,9), but [Graham's Number](https://en.wikipedia.org/wiki/Graham%27s_number)
 as well. It originates in a Code Golf
challenge asking for the "Shortest terminating program whose output size
exceeds Graham's number",
[answered](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/219734#219734)
by user [Patcail](https://codegolf.stackexchange.com/users/101119/patcail) and
[further optimized](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/219734#comment533337_219734) by user
[2014MELO03](https://codegolf.stackexchange.com/users/98257/2014melo03). With
one final optimization applied, this is the program:

```
010001010101011010000000010101101110110101010100000011100111010
```

It's the [Binary Lambda Calculus](https://tromp.github.io/cl/cl.html) encoding of term (λ 1 1 (λ λ λ 1 3 2 1) 1 1 1)
(λ λ 2 (2 1)), where λ (lambda) denotes an anonymous function, and number i is
the variable bound by the i-th nested λ. This is known as [De Bruijn notation](https://en.wikipedia.org/wiki/De_Bruijn_notation), a
way to avoid naming variables. A more conventional notation using variable
names would be
```
(λt. t t (λh λf λn. n h f n) t t t) (λf λx. f (f x))
```

The last 16 bits of the program---making up more than a quarter of its
size---encodes the term λf λx. f (f x), which takes arguments f and x in turn,
and iterates f twice on x. This is the standard way of representing numbers in
lambda calculus, known as Church numerals. Church numeral n iterates a given
function n times on a given argument. The program, which we'll name after the
underlying growth rate, is thus

```
wCubed = let { 2 = λf λx. f (f x); H = λh λf λn. n h f n } in 2 2 H 2 2 2
```

## Proof of exceeding Graham's Number

Following the great suggestion of Googology user "BMS is not well-founded", let
us start by defining a wCubed-customized [Fast-growing hierarchy](https://en.wikipedia.org/wiki/Fast-growing_hierarchy), a family that
assigns, to each ordinal α, a function [α] (diverting from the usual f<sub>α</sub>
notation for improved legibility) from natural numbers to natural numbers.
We'll treat all numbers as Church Numerals, so we can write n f instead of the
usual f<sup>n</sup> and write f n instead of f(n) as normally done in λ-calculus.

### Definitions:

1. H h f n = n h f n
2. H2 = H 2
3. [0] n = 2 n = n<sup>2</sup>
4. [α+1] n = 2 n [α] n = H 2 [α] n
5. [ωα+ω] n = [ωα+n] n
6. [ω<sup>i+1</sup>(α+1)] n = [ω<sup>i+1</sup>α+ω<sup>i</sup> n] n

### Lemmas:

1. 2 H 2 [ωi] n = H H2 [ωi] n =<sup>(Def. 1)<sup> n H2 [ω i] n =<sup>(n x Def. 4)<sup> [ωi+n] n =<sup>(Def. 5)<sup> [ω(i+1)] n
2. 3 H 2 [ω<sup>2</sup>i] n = H (2 H 2) [ω<sup>2</sup>i] n =<sup>(Def. 1)</sup> n (2 H 2) [ω<sup>2</sup>i] n =<sup>(n x Lemma 1)</sup> [ω<sup>2</sup>i+ωn] n =<sup>(Def. 6)</sup> [ω<sup>2</sup>(i+1)] n
3. 4 H 2 [0] n = H (3 H 2) [0] n =<sup>(Def. 1)</sup> n (3 H 2) [0] n =<sup>(n x Lemma 2)</sup> [ω2n] n =<sup>(Def 6)</sup> [ω<sup>3</sup>] n

Lemma 3 gives wCubed = 2 2 H 2 2 2 = 4 H 2 [0] 2 = [ω<sup>3</sup>] 2. In comparison,
Graham's number is known to be less than the much much smaller [ω+1] 64. As it
turns out, this proof becomes almost trivial in our custom hierarchy. We start
with defining Graham's number as a Church numeral, exploiting the fact that in
[Knuth's up-arrow notation](https://en.wikipedia.org/wiki/Knuth%27s_up-arrow_notation),
3 ↑ n = 3<sup></sup>n = upify (mult 3) n, and 3 ↑<sup>k+1</sup> n = (3 ↑<sup>k</sup>
)<sup>n-1</sup> 3 = (3 ↑<sup>k</sup> )<sup>n-1</sup> (3 ↑<sup>k</sup> 1) = (3 ↑<sup>k</sup> )<sup>n</sup> 1:

### Definitions:

* mult a b f = a (b f)
* upify f n = n f 1
* g n = n upify (mult 3) 3
* Graham = 64 g 4

### Lemmas (assuming n ≥ 3):

1. times 3 n ≤ n<sup>2</sup> = [0] n
2. upify [α] n = n 1 < 2 n [α] 1 = [α+1] n
3. g n = n upify (times 3) 3 ≤<sup>(Lemma 1)</sup> n upify [0] 3 <<sup>(Lemma 2)</sup> fn n = [ω] n

By Lemma 3, Graham = 64 g 4 < 64 [ω] 64 = [ω+1] 64

## A Functional Busy Beaver

Based on the Binary Lambda Calculus, I recently added to OEIS a
[functional Busy Beaver function](https://oeis.org/A333479) BB<sub>λ</sub>() that, besides greater simplicity, has the advantage of
measuring program size in bits rather than states. Note how, similar to BB<sub>TM</sub>(),
the value of BB<sub>λ</sub>() is not the program output considered as a number itself, but
rather the output size. And in case of binary λ-calculus, the size of a Church
numeral n is 5n+6.

We can try to compare growth rates of the two BB functions by how quickly they
exceed Graham's number. The current best effort for BB<sub>TM</sub>(), after many rounds
of optimization, is [stuck at 16 states](https://googology.fandom.com/wiki/Busy_beaver_function#Small_values),
weighing in at over 16*2*(2+4) = 192
bits. The existence of a [29 bit Ackermann-like function](https://mathoverflow.net/questions/353514/whats-the-smallest-lambda-calculus-term-not-known-to-have-a-normal-form)
and a [79 bit function](https://github.com/tromp/AIT/blob/master/fast_growing_and_conjectures/E0.lam)
growing too fast to be provably total in Peano Arithmetic, also have no
parallels in the realm of Turing machines. Which suggests that BB<sub>λ</sub> might grow a
bit faster. This is borne out by all known existing values and lower bounds,
suggesting the following

Conjecture: For all n, BB<sub>TM</sub>(n) < BB<sub>λ</sub>(⌈2n(2+log2(n+1))⌉)

## But why Turing machines?

Although [Scott Aaronson](https://scottaaronson.com/) answers this question in his paper
i[The Busy Beaver Frontier](https://scottaaronson.com/papers/bb.pdf)

But why Turing machines? For all their historic importance, haven’t Turing
machines been completely superseded by better alternatives—whether stylized
assembly languages or various codegolf languages or Lisp? As we’ll see, there
is a reason why Turing machines were a slightly unfortunate choice for the Busy
Beaver game: namely, the loss incurred when we encode a state transition table
by a string of bits or vice versa. But Turing machines also turn out to have a
massive advantage that compensates for this. Namely, because Turing machines
have no “syntax” to speak of, but only graph structure, we immediately start
seeing interesting behavior even with machines of only 3, 4, or 5 states, which
are feasible to enumerate. And there’s a second advantage. Precisely because
the Turing machine model is so ancient and fixed, whatever emergent behavior we
find in the Busy Beaver game, there can be no suspicion that we “cheated” by
changing the model until we got the results we wanted. In short, the Busy
Beaver game seems like about as good a yardstick as any for gauging humanity’s
progress against the uncomputable

one can argue that the mentioned properties:

1. emergence of interesting behaviour on small sizes, and
2. lack of cheating toward wanted results

hold just as much for binary λ-calculus as for Turing machines.
