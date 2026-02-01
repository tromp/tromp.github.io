---
layout: post
title: "The largest number representable in 64 bits"
date: 2026-01-28
---

This post is a rewrite of my earlier blog post from
[Nov 2023](https://tromp.github.io/blog/2023/11/24/largest-number)
with many new insights and updates.

```
┬─┬ ┬─┬──────────                                  ┬─┬─┬ ┬─┬────────────
└─┤ │ │ ──┬──────                                  └─┤ │ │ │ ──┬────────
  │ │ │ ┬─┼──────                                    └─┤ │ │ ──┼─┬──────
  │ │ │ └─┤ ┬─┬──                                      │ │ │ ┬─┼─┼──────
  │ │ │   │ ┼─┼─┬                                      │ │ │ └─┤ │ ┬─┬──
  │ │ │   │ │ ├─┘                                      │ │ │   └─┤ ┼─┼─┬
  │ │ │   │ ├─┘                                        │ │ │     │ │ ├─┘
  │ │ │   ├─┘                                          │ │ │     │ ├─┘  
  │ │ ├───┘                                            │ │ │     ├─┘    
  │ ├─┘                                                │ │ ├─────┘      
  └─┘                                                  │ ├─┘            
                                                       └─┘              
```
Most people believe 2<sup>64</sup>-1 = 18446744073709551615, or
0xFFFFFFFFFFFFFFFF in hexadecimal, to be the largest number
representable in 64 bits. In English, it's quite the mouthful: eighteen
quintillion four hundred forty-six quadrillion seven hundred forty-four
trillion seventy-three billion seven hundred nine million five hundred
fifty-one thousand six hundred fifteen.

That is indeed the maximum possible value of 64 bit unsigned integers,
available as datatype uint64_t in C or u64 in Rust. We can easily
surpass this with floating point numbers. The 64-bit double [floating
point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) has a largest (finite) representable value of
2<sup>1024</sup>(1-2<sup>-53</sup>) ~ 1.8\*10<sup>308</sup>.

What if we allow representations beyond plain datatypes?
Since we want representations to remain computable, the most general
kind of representation would be a program in some programming language.
But the program must be small enough to fit in 64 bits.

## The largest number programmable in 64 bits

The smallest possible valid C program is "main(){}",
consisting of 8 ASCII characters.
[ASCII](https://en.wikipedia.org/wiki/ASCII) is a 7-bit
character encoding standard representing 128 unique characters,
but all modern computers use 8-bit bytes to store either plain ASCII
or [UTF-8](https://en.wikipedia.org/wiki/UTF-8), a unicode character encoding that's backward compatible with
ASCII.  So we'll consider the above all-scaffold do-nothing program to
be the only valid 64-bit C program.

Plenty other languages require no such scaffolding though. For instance,
Linux features the arbitrary precision calculator
[bc](https://en.wikipedia.org/wiki/Bc_(programming_language)). It happily
computes the 954242 digit number 9^999999 = 35908462...48888889, making
it programmable in 8 bytes. So is the much larger 9^9^9^99 =
9^(9^(9^99)) with over 10^10^953 digits, which bc is less happy to
compute. If bc supported the symbol ! for computing factorials, then
9!!!!!!! would represent a much larger number still.

Allowing such primitives feels a bit like cheating though. Would we allow a
language that has the [Ackerman function](https://en.wikipedia.org/wiki/Ackermann_function)
predefined, which sports the 8 byte expression ack(9,9) representing a truly huge number?

## Ackerman considered unhelpful

As it turns out, the question is moot.
One can blow way past ack(9,9) in under 64 bits in a language with no built
in primitive whatsoever. A language with no basic arithmetic; not even numbers themselves.
A language in which all those must be defined from scratch.

But let's first look at another primitives-lacking language, one that has been particularly
well studied for producing largest possible outputs. That is the language of
[Turing machines](https://en.wikipedia.org/wiki/Turing_machine).

## Busy Beaver

The famous [Busy Beaver](https://en.wikipedia.org/wiki/Busy_beaver)
 function, [introduced](https://archive.org/details/bstj41-3-877/mode/2up) by
[Tibor Radó](https://en.wikipedia.org/wiki/Tibor_Rad%C3%B3) in 1962, which we'll
denote BB(n), is defined as the maximal number of steps taken by
an n-state Turing Machine (TM) with a binary tape alphabet,
starting from an all-0 tape, before halting.

Note that this is stretching the meaning of "representable" a bit,
since BB considers the runtime of the machine instead of its output.
Besides the above BB (that Radó called S), Radó did define another
function called Σ that considers the output of the machine as a number in unary,
namely the number of 1s in the final tape contents. But BB has received
more attention as it allows one to determine from BB(n) all halting n-state machines.

The definition also leaves a discrepancy between how the size of a TM is measured, in states,
versus how program size is measured, in bits.
Fortunately there is a straightforward binary encoding of n-state TMs,
which is entirely determined by its transition function.
For each of the n states that the machine's finite control can be in,
and each of its 2 tape symbols that could be scanned by its tape head,
the transition function specifies what new symbol to write in the scanned tape cell (1 bit),
whether to move the tape head left or right (1 bit),
and what new state (or special halt state) to transition to (⌈log2(n+1)⌉ bits).
This encoding takes 6\*2\*(2+3) = 60 bits for a a 6-state TM,
and 7\*2\*(2+3) = 70 bits for a a 7-state TM.

So the largest number TM programmable in 64 bits is BB(6).

## How large is BB(6)?

Unfortunately, we may never know. While all BB(n) have been determined (and even
formally proven) for n&le;5, there are some 6-state TMs whose halting behaviour are
closely related to very hard mathematical problems.
Most of these so-called [cryptids](https://wiki.bbchallenge.org/wiki/Cryptids)
are likely not to halt, with some,
like [Lucy's Moonlight](https://wiki.bbchallenge.org/wiki/Lucy%27s_Moonlight)
likely to halt but unlikely to beat the current champion.
The current 6-state champion shows that
[BB(6) > 2↑↑2↑↑2↑↑10 ](https://wiki.bbchallenge.org/wiki/BB(6)).
Here, m↑↑n is [Knuth's up-arrow notation](https://en.wikipedia.org/wiki/Knuth%27s_up-arrow_notation)
for an exponential tower of n m's, so that for example 2↑↑3 = 2<sup>2<sup>2</sup></sup>.

Large as this number is, it's still very small compared to
ack(9,9) = 2↑<sup>7</sup>12 - 3 = 2↑↑↑↑↑↑↑12 - 3.
It is known however that
[BB(7) > 2↑<sup>11</sup>2↑<sup>11</sup>3 > ack(9,9) ](https://wiki.bbchallenge.org/wiki/BB(7)).

Several leading BB researchers believe that BB(7) is even larger than the famous
[Graham's Number](https://en.wikipedia.org/wiki/Graham%27s_number), which iterates
the function mapping n to 3↑<sup>n</sup>3 64 times starting from n=3.
This is quite a bold belief, considering that the smallest known Graham exceeding TM has
[14 states](https://wiki.bbchallenge.org/wiki/Champions), twice as many.
But they stand behind their belief, by accepting my
$1000 bet that a proof of BB(7) > Graham's Number won't be found within 10 years.

Meanwhile, Graham's Number is easily surpassed within 64 bits, by moving beyond Turing machines
into the language of

## Lambda Calculus

Alonzo Church conceived the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus)
in about 1928 as a formal logic system for expressing
computation based on function abstraction and application using variable binding and substitution.

The Graham beating lambda term originates in a Code Golf challenge asking for the
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
The function λf λx. f<sup>n</sup> x, that iterates a given function n times on a given argument
is called Church numeral n, and is the standard way of representing numbers in the λ-calculus.
The encoding of Church numeral n is 00 00 (01 110)<sup>n</sup> 10 of size 5n+6 bits.

The program, which we'll name after its discoverer, can be expressed more legibly as

```
Melo = let { 2 = λf λx. f (f x); H = λg λm. m g 2; J = λy. y (y H) } in J J
```

Melo evaluates to a Church numeral, "Melo's Number", that comfortably exceeds Graham's Number.

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

### Lemma 2. For k,n &ge; 2, k H 2 n > 3↑<sup>k</sup>(1+n)

### Proof:
By induction on k.  First note that H2 n = H 2 n = n 2 2 = 2^2^n

Base:   2 H 2 n = H H2 n = n H2 2 = 2↑↑(1+2n) > 3↑<sup>2</sup>(1+n)
        already at n=2, since 2↑↑5 = 2^2^16 > 3^27 = 3↑↑3
Step: k+1 H 2 n = H (k H 2) n = n (k H 2) 2 > 3↑<sup>k</sup>(1+ 3↑<sup>k</sup>(1+ ...
3↑<sup>k</sup>(1+2)...))
                                            > 3↑<sup>k+1</sup>(1+n)

### Lemma 3. For n &ge; 2, HH (HH n) > 3↑<sup>n</sup>3

### Proof
By induction on n

Base: Lemma 1's proof shows HH (HH 2) = 2↑↑6 > 3{2</sup>3
Step: HH (HH 1+n) = HH 1+n H 2 = 1+n H 2 H 2 = H (n H 2) H 2 =
H (n H 2) 2 2 = 2 (n H 2) 2 2 = n H 2 (n H 2 2) 2 ><sup>Lm2</sup>
3↑<sup>n</sup>(1+3↑<sup>n</sup>(1+2)) 2 > 3↑<sup>n+1</sup>3.

### Theorem: J J > Graham's Number G(64), where G(n) = n (\n -> 3↑<sup>n</sup>3) 4

### Proof:
 J J =<sup>Lm1</sup> 2↑↑6 HH 2 ><sup>Lm3</sup> (2↑↑6 / 2 - 1) (\n -> 3↑<sup>n</sup>3)
3↑<sup>2</sup>3
> (2↑↑6 / 2 - 1) (\n -> 3↑<sup>n</sup>3) 4 = G(2↑↑6 / 2 - 1) > G(64)

## Leaving Melo's Number in the dust

With 15 bits to spare, opportunities for vastly boosting Melo abound.
Discord users 50\_ft\_lock and Sam found the following term that extends Melo's H with an extra argument:
```
w218 = let { 2 = λf λx. f (f x); A = λa λb λc. c a b 2; T = λy. y (y A) } in T T T
```
represents the lambda term
```
(λT.T T T) (λy.y (y (λa λb λc. c a b (λf.λx.f (f x)))))
```
in conventional notation, or
```
(λ 1 1 1) (λ 1 (1 (λ λ λ 1 3 2 (λ λ 2 (2 1)))))
```
in de Bruijn notation, with 61-bit encoding
```
01 00 01 01 10 10 10 00 01 10 01 10 00 00 00 01 01 01 10 1110 110 00 00 01 110 01 110 10
```

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

Readers unfamiliar with
[ordinal](https://en.wikipedia.org/wiki/Ordinal_number)
[arithmetic](https://en.wikipedia.org/wiki/Ordinal_arithmetic),
may want to skip the next section.

The following FGH definition differs slightly from the standard one,
which has the slightly slower growing [0] n = n+1 and [α+1] n = n [α] n.
This allows Lemma 5 to be exact rather than a mere lower bound.

### Definition of Fast Growing Hierarchy

1. [0] n = 2 n = n<sup>2</sup>
2. [α+1] n = n 2 [α] 2 = A 2 [α] n
3. [ω<sup>i+1</sup>(α+1)] n = [ω<sup>i+1</sup>α+ω<sup>i</sup> n] 2

### Lemma 5. For k&ge;0, n>=2, : k+1 A 2 [ω<sup>k</sup> α] n = [ω<sup>k</sup> (α+1)] n

### Proof:
Base k=0:
0+1 A 2 [ω<sup>0</sup> α] n = A 2 [α] n = n 2 [α] 2 = [α+1] n

Step k>0:
k+1 A 2 [ω<sup>k</sup> α] n = A (k A 2) [ω<sup>k</sup> α] n = n (k A 2) [ω<sup>k</sup> α] 2 = [ω<sup>k</sup> α + ω<sup>k-1</sup> n] 2 = [ω<sup>k</sup> (α+1)] n

Lemma 5 gives w218 = (2↑↑18 A 2 [0] 2) 2 2 2 2 2 2 2 = 2^2^2^2^2^2^2^([ω<sup>2↑↑18-1</sup>] 2).
In comparison, Graham's number is known to be less than the much smaller [ω+1] 64.

## A Functional Busy Beaver

The λ-calculus analogue to BB is:

BBλ(n) = the maximum beta normal form size of any closed lambda term of size n

which appears in the Online Encyclopedia of Integer Sequences (OEIS) as
[functional Busy Beaver function](https://oeis.org/A333479)
Besides being simpler than BB, it has the advantage of using the standard unit of information theory,
bits, rather than states. And it doesn't require stretching the meaning of "representable" as did
BB's measuring of runtime instead of output size.

The much more fine-grained use of bits allows the first 36 values of BBλ 
to be currently known, versus only 5 values of BB.

Since both are Church numerals, term Melo implies that BBλ(49) &ge; 5 (Melo's Number) + 6,
while w218 implies that BBλ(61) &ge; 5 (2^2^2^2^2^2^2^([ω<sup>2↑↑18-1</sup>] 2)) + 6.

## BB vs BBλ growth compared on bit-by-bit basis

The growth rates of the two BB functions may be compared by how quickly they are known
to exceed certain large number milestones, that correspond to well known ordinals in the
Fast Growing Hierarchy.

For Graham's Number, at ordinal ω+1, we saw earlier that Melo's 49 bits compares with 14 states,
which take 14\*2\*(2+4) = 168 bits to encode. If I lose my bet, then the comparison
becomes rather closer at 49 vs 70 bits.

For [Goodstein's function](https://en.wikipedia.org/wiki/Goodstein%27s_theorem) at ordinal ε<sub>0</sub>,
[111
bits](https://github.com/tromp/AIT/blob/master/fast_growing_and_conjectures/BBE0.lam)
compares with [51 states](https://wiki.bbchallenge.org/wiki/Champions) taking 51\*2\*(2+6) = 816 bits.

For the limit of Bashicu Matrix System (BMS), at (presumed) ordinal PTO(Z<sub>2</sub>),
[331 bits](https://github.com/tromp/AIT/blob/master/fast_growing_and_conjectures/bms.lam)
compares with a [150 state TM](https://morphett.info/turing/turing.html) by Discord user patcail,
which takes 150\*2\*(2+8) = 3000 bits.

Finally, for Loader's Number, at (presumed) ordinal PTO(Z<sub>ω</sub>),
[1850
bits](https://codegolf.stackexchange.com/questions/176966/golf-a-number-bigger-than-loaders-number/274634#274634)
compares with a [1015 state TM
](https://github.com/CatsAreFluffy/metamath-turing-machines/tree/master), taking 
1015\*2\*(2+10) = 24360 bits.

One reason for TMs taking many more bits to achieve comparable growth,
especially at the larger milestones, is the extremely poor programmability of TMs.
The λ-calculus, despite its similar bare bones nature, doesn't share this drawback.
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

It is because programming a Turing machine is so impossibly tedious,
that people have resorted to implementing higher level languages like
[Not-Quite-Laconic](https://github.com/sorear/metamath-turing-machines)
for writing nontrivial programs such as the TM that halts only upon
finding an inconstency in ZFC. The above 1015 state TM for exceeding Loader's Number
even includes a λ-calculus interpreter written in NQL!

In his paper [The Busy Beaver Frontier](https://scottaaronson.com/papers/bb.pdf),
[Scott Aaronson](https://scottaaronson.com/) tries to answer the question
## But why Turing machines?

"For all their historic importance, haven’t Turing machines been completely superseded
by better alternatives—whether stylized assembly languages or various codegolf languages or Lisp?
As we’ll see, there is a reason why Turing machines were a slightly unfortunate choice
for the Busy Beaver game: namely, the loss incurred when we encode a state transition table
by a string of bits or vice versa.
But Turing machines also turn out to have a massive advantage that compensates for this."

### Interesting behaviour at small sizes

"Namely, because Turing machines have no “syntax” to speak of, but only graph structure,
we immediately start seeing interesting behavior even with machines of only 3, 4, or 5 states,
which are feasible to enumerate."

The number of uniquely behaving TMs with "only" 5 states is
4^10 \* [632700](https://oeis.org/A107668) = 663434035200 , which is more than
the number of closed lambda terms of size at most 52 bits (513217604750).
The latter certainly exhibit no less interesting behaviour, so TMs hold no advantage here.

### Ancient and fixed computational model

"And there’s a second advantage. Precisely because the Turing machine model is so ancient and fixed,
whatever emergent behavior we find in the Busy Beaver game, there can be no suspicion that
we “cheated” by changing the model until we got the results we wanted."

The λ-calculus is just slightly more ancient and is arguably more fixed.
There is no choice of tape alphabet size, no choice of whether the tape head needs
to move in every transition, no choice of halting and output
convention, and no choice in number of tapes or tape heads.

The λ-calculus can neither be suspected of being designed toward fast growth,
so again TMs hold no advantage here.

The only remaining advantage of BB over BBλ is the many decades of research behind
and publications about it.

## A Universal Busy Beaver

Is BBλ then an ideal Busy Beaver function? Not quite.
It's still lacking one desirable property, namely universality.

This property mirrors a notion of optimality for shortest description lengths, where it's known
as the [Invariance theorem](https://en.wikipedia.org/wiki/Kolmogorov_complexity#Invariance_theorem):

  Given any description language L, L<sub>opt</sub>
  is at least as efficient as L, with at most constant additive overhead.

In the realm of beavers, this means we require of an optimal Busy Beaver BB<sub>opt</sub> that
it surpass any Busy Beaver function bb (based on self-delimiting programs) with at most constant lag:

for some constant c depending on bb, and for all n: BB<sub>opt</sub>(n+c) &ge; bb(n)

While BBλ is not universal, the closely related

[BBλ2](https://oeis.org/A361211)(n) = the maximum output size of self-delimiting BLC programs of size n

achieves universality by giving λ-calculus terms access to pure binary data. BLC programs
consist of an encoded lambda term, followed by arbitrary binary data, that the term is applied to.

Since (λ\_. t) applied to any (standard lambda representation of) binary data equals t,
BBλ champions provide lower bounds for BBλ2: for all n, BBλ2(2+n) &ge; BBλ(n).

## In conclusion

The largest number (currently known to be) representable in 64 bits is w218,
which lower bounds both BBλ(61) and BBλ2(63).
