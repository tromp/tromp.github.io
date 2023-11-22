---
layout: post
title: "SK numerals"
date: 2021-11-05
---

## Church Numerals

Church numerals are the standard way of representing natural numbers in the lambda calculus. Cn, the Church numeral for n, iterates a given function n times on a given argument. So we have
```
C0 f x = f⁰ x = x
C1 f x = f¹ x = f x
C2 f x = f² x = f (f x)
```
etcetera. We can define a successor function "Csucc" which iterates a given function one more time than a given numeral does:
```
Csucc = λn.λf.λx. f (n f x)
```
(λn.λf.λx. n f (f x) works equally well). Each Church numeral Cn is thus itself the n'th iterate of Csucc on C0:
```
Cn = Cn Csucc C0
```
The best thing about Church numerals is the ease of defining arithmetic operators. It is straightforward to verify that
```
add = λm.λn.λf.λx. m f (n f x)
mul = λm.λn.λf. m (n f)
pow = λm.λn. n m
```
work as advertised.

E.g. pow C2 C3 = C3 C2 = λf. C2 (C2 (C2 f)) = λf.((f²)²)² = λf.f⁸ = C8

Much less straightforward is the predecessor operator, that takes C(n+1) to Cn and leaves C0 unchanged:
```
Cpred = λn.λf.λx. n(λg.λh. h(g f))(λu. x)(λu. u)
```
Wikipedia tries to explain its operation in detail.

Even less straightforward is the following division operator that springs from the creative mind of Bertram Felgenhauer:
```
div = λn.λm.λf.λx.n(λx.λf.f x)(λd.x)(n (λt.m(λx.λf.f x)(λc.f(c t))(λx.x))x)
```
whose operation is illustrated in this Algorithmic Information Theory github repository.

## SK Combinatory Logic

Combinatory Logic is concerned with terms consisting of the 2 basic combinators
```
S = λx.λy.λz. x z (y z)
K = λx.λy. x
```
combined through application. It turns out that any closed lambda term is equivalent to a combinator. For example, the identity combinator can be obtained as
```
I = S K K
```
since I x = S K K x = K x (K x) = x.

While reading Stephen Wolfram's latest book, I came across an interesting alternative to Church numerals for Combinatory Logic:
```
F0 = K
F1 = S K
F2 = S (S K)
F3 = S ( S (S K)))
```
etcetera, so S iterated n times on K, or Fn = Cn S K.

This takes economy to an extreme, by using the 2 primitive combinators S and K as the very building blocks of numbers:
```
F0 = K
Fsucc = S
```
We have
```
F0 x y = x
F(n+1) x y = S Fn x y = Fn y (x y)
```
so that
```
F1 x y = y
F2 x y = x y
F3 x y = y (x y)
F4 x y = x y (y (x y))
```
etcetera, which can be shown by induction so satisfy the Fibonacci recurrence
```
F(n+2) x y = (Fn x y) (F(n+1) x y)
```
with sum replaced by application! Consequently, there are exactly fib(n) occurrences of variable y in Fn x y.

In honor of this close connection we denote these SK numerals with the letter F . Curiously, F0 and F1 coincide with the standard representations of booleans
```
True = K
False = S K
```
The big question, though, is whether they work as numerals. The ultimate test of that is the ability to convert them back into Church numerals. Wolfram's book suggests a way to do that by applying an SK numeral to x and y that are both Church numerals, perhaps C3 and C2, which leads to all applications working as powers. For example, F3 C3 C2 = C2 (C3 C2) = C2 C8 = C256. And from that we could work our way back to the 3, resulting in a size 181 conversion combinator.

A more elegant conversion can be obtained by defining predecessor and iszero operators, and using these to count down to zero
```
Fpred = λn.λx.λy. n (K y) x
Fiszero = λn. n False I S K
F2C = λn. Fiszero n C0 (Csucc (F2C (pred n)))
```
We may check that
```
Fpred F1 x y = F1 (K y) x = x
Fpred F2 x y = F2 (K y) x = K y x = y
```
and by induction, Fpred F(n+1) = Fn holds for all n. In fact, it works so well, it lets us venture into the negative numbers:
```
F-1 x y = Fpred F0 x y = F0 (K y) x = K y
F-2 x y = Fpred F-1 x y = F-1 (K y) x = K x
F-3 x y = Fpred F-2 x y = F-2 (K y) x = K (K y)
```
etcetera. And Fsucc works on these negative numerals too.

Fiszero however works on non-negative numerals only, as follows:
```
Fiszero F0 = F0 False I S K = False S K = K = True
Fiszero F(n+1) False I S K = S Fn False I S K = Fn I I S K = I S K = S K = False
```
Using the optimal Y combinator S S K (S (K (S S (S (S S K)))) K), F2C is combinator of size 69, a huge improvement.

But it turns out we can do better still, courtesy of good old Bertram:
```
pair = λx.λy. λp. p x y
F2C = λn.(λp. n p(p p) False) (pair (λf.λy.λx. pair f (Csucc y)) C0)
```
This size 60 combinator
```
S (S (K (S S (K (K (S K))))) (S S (S K))) (K (S (S (S K K) (K (S (K (S (K (S (K (S (K (S (K (S (K (S S (K (S (K (S (K (S (K K))) S)) (S (K (S (K S) K))))))) K)) S)) K)) S)) (S (S K K)))) K))) (S K)))
```
applies the SK numeral to x and y that are both pairs of some function and a church numeral. Applying one such pair to another results in the function applied to itself and the two numerals:
```
(pair f Cm) (pair f Cn) = (pair f Cn) f Cm = f f Cn Cm
```
so all function f has to do is take the successor of the right Church numeral and wrap it back up into a pair. In the F2C definition above, p is a wrapped C0 and (p p) becomes a wrapped C1.

And that wraps us our brief exploration of SK numerals.
