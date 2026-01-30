---
layout: post
title: "The largest number representable in 64 bits - Revised"
date: 2026-01-28
---

```
┬─┬ ┬─┬──────────				┬─┬─┬ ┬─┬────────────
└─┤ │ │ ──┬──────				└─┤ │ │ │ ──┬────────
  │ │ │ ┬─┼──────				  └─┤ │ │ ──┼─┬──────
  │ │ │ └─┤ ┬─┬──				    │ │ │ ┬─┼─┼──────
  │ │ │   │ ┼─┼─┬				    │ │ │ └─┤ │ ┬─┬──
  │ │ │   │ │ ├─┘				    │ │ │   └─┤ ┼─┼─┬
  │ │ │   │ ├─┘  				    │ │ │     │ │ ├─┘
  │ │ │   ├─┘    				    │ │ │     │ ├─┘  
  │ │ ├───┘      				    │ │ │     ├─┘    
  │ ├─┘          				    │ │ ├─────┘      
  └─┘            				    │ ├─┘            
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
computes the 954242 digit number 9^999999 = 35908462. . .48888889, which can thus
be said to be representable in 64 bits. Had it supported the symbol ! for computing factorials,
then 9!!!!!!! would represent a much larger number.

Allowing such primitives feels a bit like cheating though. Would we allow a
language that has the [Ackerman function](https://en.wikipedia.org/wiki/Ackermann_function)
predefined, which sports the 8 byte expression ack(9,9) representing a truly huge number?

## No primitives needed

As it turns out, the question is moot.
One can blow way past ack(9,9) in under 64 bits in a language with no built
in primitive whatsoever. A language with no basic arithmetic; not even numbers themselves.
A language in which all those must be defined from scratch.

But let's first look at another primitives-lacking language, one that has been particularly well studied for
producing largest possible outputs. That is the language of
[Turing machines](https://en.wikipedia.org/wiki/Turing_machine).

## Busy Beaver

The famous [Busy Beaver](https://en.wikipedia.org/wiki/Busy_beaver)
 function, [introduced](https://archive.org/details/bstj41-3-877/mode/2up) by
[Tibor Radó](https://en.wikipedia.org/wiki/Tibor_Rad%C3%B3) in 1962, which we'll
denote BB(n), is defined as the maximum number of 1s that can be written with
an n state Turing Machine (TM) starting from an all 0 tape before halting. Note that if we
consider this output as a number M written in binary, then it only gets
credited for its length, which is log<sub>2</sub>(M+1).

60 bits suffice to fully specify any 6 state binary TM.
For each of its 6 internal states and each of its 2 tape symbols,
it writes either symbol in the currently scanned tape cell (1 bit),
moves the tape head left or right (1 bit),
and transitions to any of the 6 states or the special halt state (⌈log2(6+1)⌉ = ⌈2.81⌉ = 3 bits),
totalling 6\*2\*(2+3) = 60 bits.
Just how big an output can a 6 state TM produce?

Nobody knows for sure, since BB(n) has only been determined for n <= 5.
The current 6-state champion shows that
[BB(6) > 2↑↑2↑↑2↑↑10 ](https://wiki.bbchallenge.org/wiki/BB(6)),
which denotes an exponential tower of M 2s, where M is an exponential tower of N 2s,
and N is an exponential tower fo 10 2s (phew!). Clearly, in this notation there's not that
much difference between a number and its size in bits.
Large as this number is, it's still very small compared to ack(9,9).
It is known however that
[BB(7) > 2↑<sup>11</sup>2↑<sup>11</sup>3 > ack(9,9) ](https://wiki.bbchallenge.org/wiki/BB(7)),
and any 7 state TM can be described in 7\*2\*(2+log2(7+1)) = 70 bits.

For exceeding ack(9,9) within 64 bits, we need to move beyond Turing machines, into the language of

## Lambda Calculus

Alonzo Church conceived the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus)
in about 1928 as a formal logic system for expressing
computation based on function abstraction and application using variable binding and substitution.

A tiny 49 bit program in this language represents a number exceeding not just ack(9,9),
but the unfathomably larger [Graham's Number](https://en.wikipedia.org/wiki/Graham%27s_number) as well.

It originates in a Code Golf challenge asking for the
"Shortest terminating program whose output size exceeds Graham's number",
[answered](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/219734#219734)
by user [Patcail](https://codegolf.stackexchange.com/users/101119/patcail) and
[further optimized](https://codegolf.stackexchange.com/questions/6430/shortest-terminating-program-whose-output-size-exceeds-grahams-number/263884#263884) by user
[2014MELO03](https://codegolf.stackexchange.com/users/98257/2014melo03).
The following 49 bit program

```
01 00 01 10 10 00 01 10 01 10 00 00 01 01 10 110 00 00 01 110 01 110 10
```

is the [Binary Lambda Calculus](https://tromp.github.io/cl/cl.html) [encoding](https://gist.github.com/tromp/86b3184f852f65bfb814e3ab0987d861#lambda-encoding) of the term
```
(λ 1 1) (λ 1 (1 (λ λ 1 2 (λ λ 2 (2 1)))))
```
where λ (lambda) denotes an anonymous function, and number i is the variable bound by the i-th nested λ.
This is known as [De Bruijn notation](https://en.wikipedia.org/wiki/De_Bruijn_notation), a
way to avoid naming variables. A more conventional notation using variable names would be
```
(λJ.J J) (λy.y (y (λg λm. m g (λf.λx.f (f x)))))
```
The top left of this post shows a [graphical representation](https://tromp.github.io/cl/diagrams.html) of the term.
The last 16 bits of the program---making up almost a third of its size---encodes
the term λf λx. f (f x), which takes arguments f and x in turn, and iterates f twice on x.
In general, the function that iterates a given function n times on a given argument
is called Church numeral n, and is the standard way of representing numbers in the λ-calculus.
The program, which we'll name after its discoverer, can be expressed more legibly as

```
Melo = let { 2 = λf λx. f (f x); H = λg λm. m g 2; J = λy. y (y H) } in J J
```

Melo evaluates to a Church numeral, "Melo's Number", that comfortably exceeds the famous Graham's Number.

The next section is mostly for the benefit of readers familiar with
[ordinal](https://en.wikipedia.org/wiki/Ordinal_number)
[arithmetic](https://en.wikipedia.org/wiki/Ordinal_arithmetic),
and is probably better skipped by others.

## Proof of exceeding Graham's Number

### Lemma 1. J J = 2↑↑6 HH 2, where HH denotes H H

### Proof:
J J = J (J H) = J (H HH) = H HH (H HH H)
    = H HH H        HH 2
    = H HH 2        HH 2
    = 2 HH 2        HH 2
    = HH (HH 2)     HH 2
    = HH 2 H 2      HH 2
    = 2 H 2 H 2     HH 2
    = H (H 2) H 2   HH 2
    = H (H 2) 2 2   HH 2
    = 2 (H 2) 2 2   HH 2
    = H 2 (H 2 2) 2 HH 2
    = H 2 2 2 2 2   HH 2
    = 2 2 2 2 2 2   HH 2
    = 2↑↑6          HH 2

### Lemma 2. For k,n >= 2, k H 2 n > 3{k}(1+n)

### Proof:
By induction on k.  First note that H2 n = H 2 n = n 2 2 = 2^2^n

Base:   2 H 2 n = H H2 n = n H2 2 = 2↑↑(1+2n) > 3{2}(1+n)
        already at n=2, since 2↑↑5 = 2^2^16 > 3^27 = 3↑↑3
Step: k+1 H 2 n = H (k H 2) n = n (k H 2) 2 > 3{k}(1+ 3{k}(1+ ... 3{k}(1+2)...))
                                            > 3{k+1}(1+n)

### Lemma 3. For n >= 2, HH (HH n) > 3{n}3

### Proof
By induction on n

Base: Lemma 1's proof shows HH (HH 2) = 2↑↑6 > 3{2}3
Step: HH (HH 1+n) = HH 1+n H 2 = 1+n H 2 H 2 = H (n H 2) H 2 =
H (n H 2) 2 2 = 2 (n H 2) 2 2 = n H 2 (n H 2 2) 2 ><sup>Lm2</sup> 3{n}(1+3{n}(1+2)) 2 > 3{n+1}3.

### Theorem: J J > Graham's Number G(64), where G(n) = n (\n -> 3{n}3) 4

### Proof:
 J J =<sup>Lm1</sup> 2↑↑6 HH 2 ><sup>Lm3</sup> (2↑↑6 / 2 - 1) (\n -> 3{n}3) 3{2}3
> (2↑↑6 / 2 - 1) (\n -> 3{n}3) 4 = G(2↑↑6 / 2 - 1) > G(64)


## Leaving Melo's Number in the dust

With 15 bits to spare, opportunities for vastly boosting Melo abound.
Discord users 50\_ft\_lock and Sam found the following term that extends Melo's H with an extra argument:
```
w218 = let { 2 = λf λx. f (f x); A = λa λb λc. c a b 2; T = λy. y (y A) } in T T T
(λT.T T T) (λy.y (y (λa λb λc. c a b (λf.λx.f (f x)))))
(λ 1 1 1) (λ 1 (1 (λ λ λ 1 3 2 (λ λ 2 (2 1)))))
01 00 01 01 10 10 10 00 01 10 01 10 00 00 00 01 01 01 10 1110 110 00 00 01 110 01 110 10
```
shown together with its convention notation, de Bruijn notation, and 61-bit encoding.
The similarity to Melo is also apparent in its graphical representation at the top right of this post.
The name is inspired by the following

### Lemma 4. T T T = 2↑↑18 A 2 2 2 2 2 2 2 2 2 2

### Proof: Let AA denote A A
      T T                                                            T
    = T (T A)                                                        T
    = T (A AA)                                                       T
    = A AA (A AA A) T
    = T AA                                                  (A AA A) 2
    = AA (AA A) (A AA A)                                             2
    = A AA A A                                              (AA A) 2 2
    = A AA A 2                                              (AA A) 2 2
    = 2 AA A                                              2 (AA A) 2 2
    = AA (AA A) 2                                           (AA A) 2 2
    = 2 A (AA A)                                          2 (AA A) 2 2
    = A (A (AA A)) 2 (AA A)                                        2 2
    = AA A (A (AA A))                                          2 2 2 2
    = A (AA A) A A                                           2 2 2 2 2
    = A (AA A) A 2                                           2 2 2 2 2
    = 2 (AA A) A                                           2 2 2 2 2 2
    = AA A (AA A A)                                        2 2 2 2 2 2
    = AA A A                                         A A 2 2 2 2 2 2 2
    = A A A 2                                        A A 2 2 2 2 2 2 2
    = 2 A A                                        2 A A 2 2 2 2 2 2 2
    = A AA 2 A                                         A 2 2 2 2 2 2 2
    = A AA 2 2                                         A 2 2 2 2 2 2 2
    = 2 AA 2                                         2 A 2 2 2 2 2 2 2
    = AA (AA 2) 2                                      A 2 2 2 2 2 2 2
    = 2 A (AA 2)                                     2 A 2 2 2 2 2 2 2
    = A (A (AA 2)) 2 A                                   2 2 2 2 2 2 2
    = A (A (AA 2)) 2 2                                   2 2 2 2 2 2 2
    = 2 (A (AA 2)) 2                                   2 2 2 2 2 2 2 2
    = A (AA 2) (A (AA 2) 2) 2                            2 2 2 2 2 2 2
    = 2 (AA 2) (A (AA 2) 2) 2                            2 2 2 2 2 2 2
    = AA 2 (AA 2 (A (AA 2) 2))                         2 2 2 2 2 2 2 2
    = AA 2 (A (AA 2) 2)                          A 2 2 2 2 2 2 2 2 2 2
    = A (AA 2) 2 A                           2 2 A 2 2 2 2 2 2 2 2 2 2
    = A (AA 2) 2 2                           2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2 (AA 2) 2                           2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = AA 2 (AA 2 2)                        2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = AA 2 2                         A 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2 A 2                        2 A 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A (A 2) 2 A                      2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A (A 2) 2 2                      2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2 (A 2) 2 2                      2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A 2 (A 2 2) 2                    2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2 2 (A 2 2) 2                    2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 4 (A 2 2) 2                      2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A 2 2 (A 2 2 (A 2 2 (A 2 2 2)))  2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A 2 2 (A 2 2 (A 2 2 2))    2 2 2 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A 2 2 (A 2 2 2)      2 2 2 2 2 2 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = A 2 2 2        2 2 2 2 2 2 2 2 2 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2 2 2 2        2 2 2 2 2 2 2 2 2 2 2 2 2 2 A 2 2 2 2 2 2 2 2 2 2
    = 2↑↑18 A 2 2 2 2 2 2 2 2 2 2

These 2↑↑18 iterations of A also let us relate its magnitude to the so-called
[Fast-growing hierarchy](https://en.wikipedia.org/wiki/Fast-growing_hierarchy),
a family that assigns, to each ordinal α, a function [α] (diverting from the usual f<sub>α</sub>
notation for improved legibility) from natural numbers to natural numbers.
We'll treat all numbers as Church Numerals, so we can write n f instead of the
usual f<sup>n</sup> and write f n instead of f(n) as normally done in λ-calculus.

The following definition differs slightly from the standard one,
which has the slightly slower growing [0] n = n+1 and [α+1] n = n [α] n.
This allows Lemma 5 to be exact rather than a mere lower bound.

### Definition of Fast Growing Hierarchy

1. [0] n = 2 n = n<sup>2</sup>
2. [α+1] n = n 2 [α] 2 = A 2 [α] n
3. [ω<sup>i+1</sup>(α+1)] n = [ω<sup>i+1</sup>α+ω<sup>i</sup> n] 2

### Lemma 5. For k>=0, n>=2, : k+1 A 2 [ω<sup>k</sup> α] n = [ω<sup>k</sup> (α+1)] n

### Proof:
Base k=0:
0+1 A 2 [ω<sup>0</sup> α] n = A 2 [α] n = n 2 [α] 2 = [α+1] n

Step k>0:
k+1 A 2 [ω<sup>k</sup> α] n = A (k A 2) [ω<sup>k</sup> α] n = n (k A 2) [ω<sup>k</sup> α] 2 = [ω<sup>k</sup> α + ω<sup>k-1</sup> n] 2 = [ω<sup>k</sup> (α+1)] n

Lemma 5 gives w218 = (2↑↑18 A 2 [0] 2) 2 2 2 2 2 2 2 = 2^2^2^2^2^2^2^([ω↑↑18-1] 2).
In comparison, Graham's number is known to be less than the much smaller [ω+1] 64.

## A Functional Busy Beaver

The λ-calculus analogue to BB is:

BBλ(n) = the maximum beta normal form size in bits of any closed lambda term of size n

which appears in the Online Encyclopedia of Integer Sequences (OEIS) as
[functional Busy Beaver function](https://oeis.org/A333479)
Besides being simpler than BB, it has the advantage of using the standard unit of information theory,
rather than states.
In the binary λ-calculus, the size of a Church numeral n is 5n+6.
The much more fine-grained use of bits allows the first 36 values of BBλ 
to be currently known, versus only 5 values of BB.

The growth rates of the two BB functions may be compared by how quickly they are known
to exceed famous large numbersmilestones such as Graham's number.

The current best effort for BB rests at [14 states](https://wiki.bbchallenge.org/wiki/Champions),
weighing in at 14\*2\*(2+4) = 168 bits. That compares rather unfavorably with Melo's 49 bits.
Several leading BB researchers do believe however that Graham can be exceeded with only half that
number of states, namely 7, going so far as to bet $1000 with me on the premise that a proof
should be found within 10 years.

The existence of a [29 bit Ackermann-like function](https://mathoverflow.net/questions/353514/whats-the-smallest-lambda-calculus-term-not-known-to-have-a-normal-form),
a [79 bit function](https://github.com/tromp/AIT/blob/master/fast_growing_and_conjectures/E0.lam)
growing too fast to be provably total in Peano Arithmetic,
a 331 bit program for reaching the limit of the Bashicu Matrix System (BMS),
or an 1850 bit program for exceeding Loader's Number,
also have no parallels in the realm of Turing machines,
suggesting that the λ-calculus exhibits faster growth.

It further enjoys a sizeable advantage in programmability.
Modern high level pure functional languages like [Haskell](https://www.haskell.org/)
are essentially just syntactically sugared λ-calculus,
with programmer friendly features like [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type)
translating directly through [Scott encodings](https://en.wikipedia.org/wiki/Mogensen%E2%80%93Scott_encoding).
The [bruijn programming language](https://bruijn.marvinborner.de/) is an even
thinner layer of syntactic sugar for the pure untyped lambda calculus, whose
extensive [standard library](https://bruijn.marvinborner.de/std/) contains many
datatypes and functions.
It is this excellent programmability of the λ-calculus that facilitated the construction 
of highly optimized programs for BMS and Loader's.

In contrast, programming a Turing machine has been called impossibly tedious,
which explains why people have resorted to implementing higher level languages like
[Not-Quite-Laconic](https://github.com/sorear/metamath-turing-machines)
for writing nontrivial programs that don't waste too many states.

In his paper [The Busy Beaver Frontier](https://scottaaronson.com/papers/bb.pdf),
[Scott Aaronson](https://scottaaronson.com/) tries to answer the question
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

The claimed "massive advantage" of TMs do not hold over the λ-calculus.

First, the number of uniquely behaving TMs with "only" 5 states is
4^10 \* [632700](https://oeis.org/A107668) = 663434035200 , which is more than
the number of closed lambda terms of size at most 52 bits (513217604750),
which exhibit as much if not more interesting behaviour.

Second, the  λ-calculus is more ancient (by just a few years) and more fixed (no choice of
tape alphabet size, or number of tapes), leaving no suspicion either.

BBλ's use of bits, the standard unit of information theory, therefore make it the prefered
yardstick for exploring the limits of computation.

## A Universal Busy Beaver

Is BBλ then an ideal Busy Beaver function (apart from a historical lack of study)?
Not quite. It's still lacking one desirable property, namely universality.

This property mirrors a notion of optimality for shortest description lengths, where it's known
as the [Invariance theorem](https://en.wikipedia.org/wiki/Kolmogorov_complexity#Invariance_theorem):

  Given any description language L, the optimal description language is at least as efficient as L, with some constant overhead.

In the realm of beavers, this means that given any Busy Beaver function BB
(based on self-delimiting programs), an optimal Busy Beaver surpasses it with
at most constant lag:

for some constant c depending on BB, and for all n: BBopt(n+c) &ge; BB(n)

While BBλ is not universal, it's not far from one either.
By giving λ-calculus terms access to pure binary data, as in the Binary Lambda Calculus,
function [BBλ2](https://oeis.org/A361211) achieves universality
while lagging only 2 bits behind BBλ (still leaving room for w218 in under 64 bits).
It's known to eventually outgrow the latter, but that could take thousands of bits.
