---
layout: post
title: "The largest number representable in 64 bits"
date: 2023-11-24
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
Most people believe 2<sup>64</sup>-1 = 18446744073709551615, or 0xFFFFFFFFFFFFFFFF in hexadecimal,
to be the largest number representable in 64 bits. In English, it's quite the mouthful:
eighteen quintillion four hundred forty-six quadrillion seven hundred forty-four
trillion seventy-three billion seven hundred nine million five hundred fifty-one
thousand six hundred fifteen.

That is indeed the maximum possible value of 64 bit unsigned integers,
available as datatype uint64_t in C or u64 in Rust.
We can easily surpass this with floating point numbers. The 64-bit
[double floating point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
has a largest (finite) representable value of
2<sup>1024</sup>(1-2<sup>-53</sup>) ~ 1.8\*10<sup>308</sup>.

What if we allow representations beyond plain datatypes?
Such as a program small enough to fit in 64 bits.
For most programming languages, there is very little you can do in a mere  8 bytes.
In C that only leaves you with the nothingness of "main(){}".

But there are plenty languages that require no such scaffolding. For instance,
on Linux there is arbitrary precision calculator "bc". It happily
computes the 954242 digit number 9^999999 = 35908462...48888889, which can thus
be said to be representable in 64 bits. Had it supported the symbol ! for computing factorials,
then 9!!!!!!! would make a much larger number representable in 64 bits.

Allowing such primitives feels a bit like cheating though. Would we allow a
language that has the [Ackerman function](https://en.wikipedia.org/wiki/Ackermann_function)
predefined, which sports the 8 byte expression ack(9,9) representing a truly huge number?

## No primitives needed

As it turns out, the question is moot. There are simple languages with no built
in primitives. Not even basic arithmetic. Not even numbers themselves.
Languages in which all those must be defined from scratch. One such
language allows us to blow way past ack(9,9) in under 64 bits.

But let's first look at another such language, one that has been particularly well studied for
producing largest possible outputs. That is the language of
[Turing machines](https://en.wikipedia.org/wiki/Turing_machine).

## Busy Beaver

The famous [Busy Beaver](https://en.wikipedia.org/wiki/Busy_beaver)
 function, [introduced](https://archive.org/details/bstj41-3-877/mode/2up) by
[Tibor Radó](https://en.wikipedia.org/wiki/Tibor_Rad%C3%B3) in 1962, which we'll
denote BB<sub>TM</sub>(n), is defined as the maximum number of 1s that can be written with
an n state Turing machine starting from an all 0 tape before halting. Note that if we
consider this output as a number M written in binary, then it only gets
credited for its length, which is log<sub>2</sub>(M+1).

In 64 bits, one can fully specify a 6 state binary Turing machine, or TM for
short. For each of its internal states and each of its 2 tape symbols, one can
specify what new tape symbol it should write in the currently scanned tape
cell, whether to move the tape head left or right, and what new internal state,
or special halt state, to transition to. That takes 6\*2\*(2+⌈log2(6+1)⌉) = 60 bits.
Just how big an output can a 6 state TM produce?

The best known result for 6 states is
[BB<sub>TM</sub>(6) > 10↑↑15](https://www.sligocki.com/2022/06/21/bb-6-2-t15.html),
which denotes an exponential tower of fifteen 10s. Clearly, in this notation there's not that
much difference between a number and its size in bits.
Large as this number is, it's still pathetically small compared to even
ack(5,5), which no known TM of less than 10 states---amounting to 110 bits of
description---can surpass.

For that, we need to move beyond Turing machines, into the language of

## Lambda Calculus

Alonzo Church conceived the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus)
in about 1928 as a formal logic system for expressing
computation based on function abstraction and application using variable binding and substitution.

A tiny 63 bit program in this language represents a number unfathomably larger than not only ack(9,9),
but the far larger [Graham's Number](https://en.wikipedia.org/wiki/Graham%27s_number) as well.
It originates in a Code Golf challenge asking for the
"Shortest terminating program whose output size exceeds Graham's number",
[answered](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/219734#219734)
by user [Patcail](https://codegolf.stackexchange.com/users/101119/patcail) and
[further optimized](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/219734#comment533337_219734) by user
[2014MELO03](https://codegolf.stackexchange.com/users/98257/2014melo03).
With one final optimization applied, the following 63 bit program

```
01 00 01 01 01 01 01 10 10 00 00 00 01 01 01 10 1110 110 10 10 10 10 00 00 01 110 01 110 10
```

is the [Binary Lambda Calculus](https://tromp.github.io/cl/cl.html) [encoding](https://gist.github.com/tromp/86b3184f852f65bfb814e3ab0987d861#lambda-encoding) of the term
```
(λ 1 1 (λ λ λ 1 3 2 1) 1 1 1) (λ λ 2 (2 1))
```
where λ (lambda) denotes an anonymous function, and number i is the variable bound by the i-th nested λ.
This is known as [De Bruijn notation](https://en.wikipedia.org/wiki/De_Bruijn_notation), a
way to avoid naming variables. A more conventional notation using variable names would be
```
(λt. t t (λh λf λn. n h f n) t t t) (λf λx. f (f x))
```
The top of this post shows a [graphical representation](https://tromp.github.io/cl/diagrams.html) of the term.
The last 16 bits of the program---making up more than a quarter of its size---encodes
the term λf λx. f (f x), which takes arguments f and x in turn, and iterates f twice on x.
In general, the function that iterates a given function n times on a given argument
is called Church numeral n, and is the standard way of representing numbers in the λ-calculus.
The program, which we'll name after its underlying growth rate, can be expressed more legibly as

```
wCubed = let { 2 = λf λx. f (f x); H = λh λf λn. n h f n } in 2 2 H 2 2 2
```
The next section is mostly for the benefit of readers familiar with ordinal arithmetic,
and is probably better skipped by others.

## Proof of exceeding Graham's Number

Following the great suggestion of Googology user "BMS is not well-founded", let
us start by defining a wCubed-customized
[Fast-growing hierarchy](https://en.wikipedia.org/wiki/Fast-growing_hierarchy), a family that
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

1. 2 H 2 [ω i] n = H H2 [ω i] n =<sup>(Def. 1)</sup> n H2 [ω i] n =<sup>(n x Def. 4)</sup> [ω i+n] n =<sup>(Def. 5)</sup> [ω(i+1)] n
2. 3 H 2 [ω<sup>2</sup>i] n = H (2 H 2) [ω<sup>2</sup>i] n =<sup>(Def. 1)</sup> n (2 H 2) [ω<sup>2</sup>i] n =<sup>(n x Lemma 1)</sup> [ω<sup>2</sup>i+ω n] n =<sup>(Def. 6)</sup> [ω<sup>2</sup>(i+1)] n
3. 4 H 2 [0] n = H (3 H 2) [0] n =<sup>(Def. 1)</sup> n (3 H 2) [0] n =<sup>(n x Lemma 2)</sup> [ω2n] n =<sup>(Def 6)</sup> [ω<sup>3</sup>] n

Lemma 3 gives wCubed = 2 2 H 2 2 2 = 4 H 2 [0] 2 = [ω<sup>3</sup>] 2. In comparison,
Graham's number is known to be less than the much much smaller [ω+1] 64. As it
turns out, this proof becomes almost trivial in our custom hierarchy. We start
with defining Graham's number as a Church numeral, exploiting the fact that in
[Knuth's up-arrow notation](https://en.wikipedia.org/wiki/Knuth%27s_up-arrow_notation),
3 ↑ n = 3<sup>n</sup> = upify (mult 3) n, and 3 ↑<sup>k+1</sup> n = (3 ↑<sup>k</sup>
)<sup>n-1</sup> 3 = (3 ↑<sup>k</sup> )<sup>n-1</sup> (3 ↑<sup>k</sup> 1) = (3 ↑<sup>k</sup> )<sup>n</sup> 1:

### Definitions:

* mult a b f = a (b f)
* upify f n = n f 1
* g n = n upify (mult 3) 3
* Graham = 64 g 4

### Lemmas (assuming n ≥ 3):

1. times 3 n ≤ n<sup>2</sup> = [0] n
2. upify [α] n = n 1 < 2 n [α] 1 = [α+1] n
3. g n = n upify (times 3) 3 ≤<sup>(Lemma 1)</sup> n upify [0] 3 &lt;<sup>(Lemma 2)</sup> fn n = [ω] n

By Lemma 3, Graham = 64 g 4 < 64 [ω] 64 = [ω+1] 64

## A Functional Busy Beaver

Based on the λ-calculus, I recently added to OEIS a
[functional Busy Beaver function](https://oeis.org/A333479) BB<sub>λ</sub> that,
besides greater simplicity, has the advantage of
measuring program size in bits rather than states. Note how, similar to BB<sub>TM</sub>(),
the value of BB<sub>λ</sub>() is not the program output considered as a number itself, but
rather the output size. And in case of binary λ-calculus, the size of a Church numeral n is 5n+6.
[//]: # The first unknown BB<sub>TM</sub> is at 5 states, while the first unknown BB<sub>λ</sub> is at 37 bits.

The growth rates of the two BB functions may be compared by how quickly they exceed
that most famous of large numbers: Graham's number.
The current best effort for BB<sub>TM</sub>, after many rounds of optimization,
is [stuck at 16 states](https://googology.fandom.com/wiki/Busy_beaver_function#Small_values),
weighing in at over 16\*2\*(2+4) = 192 bits. That compares rather unfavorably with our 63 bits.

The existence of a [29 bit Ackermann-like function](https://mathoverflow.net/questions/353514/whats-the-smallest-lambda-calculus-term-not-known-to-have-a-normal-form)
and a [79 bit function](https://github.com/tromp/AIT/blob/master/fast_growing_and_conjectures/E0.lam)
growing too fast to be provably total in Peano Arithmetic,
also have no parallels in the realm of Turing machines, suggesting that the λ-calculus exhibits faster growth.

It further enjoys massive advantages in programmability.
Modern high level pure functional languages like [Haskell](https://www.haskell.org/)
are essentially just syntactically sugared λ-calculus,
with programmer friendly features like [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type)
translating directly through [Scott encodings](https://en.wikipedia.org/wiki/Mogensen%E2%80%93Scott_encoding).
The [bruijn programming language](https://bruijn.marvinborner.de/) is an even
thinner layer of syntactic sugar for the pure untyped lambda calculus, whose
extensive [standard library](https://bruijn.marvinborner.de/std/) contains many
datatypes and functions.
It is this excellent programmability of the λ-calculus that facilitated the creation of wCubed.

In contrast, programming a Turing machine has been called impossibly tedious,
which explains why people have resorted to implementing higher level languages like
[Not-Quite-Laconic](https://github.com/sorear/metamath-turing-machines)
for writing nontrivial programs that don't waste too many states.

In his paper [The Busy Beaver Frontier](https://scottaaronson.com/papers/bb.pdf), [Scott Aaronson](https://scottaaronson.com/) tries to answer the question

## But why Turing machines?

```
For all their historic importance, haven’t Turing machines been completely superseded
by better alternatives—whether stylized assembly languages or various codegolf languages or Lisp?
As we’ll see, there is a reason why Turing machines were a slightly unfortunate choice
for the Busy Beaver game: namely, the loss incurred when we encode a state transition table
by a string of bits or vice versa.
But Turing machines also turn out to have a massive advantage that compensates for this.
Namely, because Turing machines have no “syntax” to speak of, but only graph structure,
we immediately start seeing interesting behavior even with machines of only 3, 4, or 5 states,
which are feasible to enumerate.
And there’s a second advantage. Precisely because the Turing machine model is so ancient and fixed,
whatever emergent behavior we find in the Busy Beaver game, there can be no suspicion that
we “cheated” by changing the model until we got the results we wanted.
In short, the Busy Beaver game seems like about as good a yardstick as any for gauging humanity’s
progress against the uncomputable
```

The claimed advantages for the "slightly unfortunate choice" do not hold over that even more
ancient model of the λ-calculus, while the latter's relatively straightforward binary encoding make
it a preferable yardstick for exploring the limits of computation. The real question then is
"Why not λ-calculus?", the answer to which appears to be rooted in historical accident more than anything.

## A Universal Busy Beaver

Is BB<sub>λ</sub> then an ideal Busy Beaver function (apart from a historical lack of study)?
Not quite. It's still lacking one desirable property, namely universality.

This property mirrors a notion of optimality for shortest description lengths, where it's known
as the [Invariance theorem](https://en.wikipedia.org/wiki/Kolmogorov_complexity#Invariance_theorem):

  Given any description language L, the optimal description language is at least as efficient as L, with some constant overhead.

In the realm of beavers, this means that given any Busy Beaver function BB
(based on self-delimiting programs), an optimal Busy Beaver surpasses it with
at most constant lag:

for some constant c depending on BB, and for all n: BB<sub>opt</sub>(n+c) &ge; BB(n)

While BB<sub>λ</sub> is not universal, it's not far from one either.
By giving λ-calculus terms access to pure binary data, as in the Binary Lambda Calculus,
function [BB<sub>BLC</sub>](https://oeis.org/A361211) achieves universality
while lagging only 2 bits behind BB<sub>λ</sub>.
It's known to eventually outgrow the latter, but that could take thousands of bits.

Besides having a somewhat more complicated definition, and being somewhat harder to analyze,
BB<sub>BLC</sub> has one other downside: it doesn't represent the ginormous wCubed in 64 bits...
