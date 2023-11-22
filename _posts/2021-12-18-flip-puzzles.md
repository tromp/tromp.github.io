---
layout: post
title: "Flip Puzzles and Linear Algebra"
date: 2021-12-18
---

This post discusses how to solve flip puzzles like Simon Tatham’s “Flip” [1] or David Johnson-Davies’s 16 LEDs puzzle [2], where each cell in a rectangular grid represents a light that can be either on or off, and the goal is to have all lights turned on.

The challenge is that, while each light can be flipped by clicking on its cell (or pressing a button directly below the LED), this action also flips several other lights in a certain pattern.

Because the LED puzzle uses diagonals through a cell as patterns, this decomposes the 16 LEDs puzzle into 2 disjoint 8 LEDs puzzles:
```
_ A _ B                 H _ I _
C _ D _                 _ J _ K
_ E _ F                 L _ M _
B _ G _                 _ N _ O
```
according to the light and dark squares in a checkerboard pattern. Let’s focus on the 8 LEDs puzzle on the left, with the 8 lights marked as A..G.
If we denote the corresponding switches in lowercase a..g, then the behavior of light A can be described as A = a + c + d + f, since pressing any of these 4 switches will flip light A, and the other switches have no effect on A. A switch takes on value 0 if not pressed, and 1 if pressed. Furthermore, since flipping twice is the same as not flipping, we add modulo 2, where 1 + 1 = 0. Mathematicians call this number system GF(2). The behavior of all 8 light can now be expressed in a single matrix equation

```
 A   ( 1 0 1 1 0 1 0 )   a
 B   ( 0 1 0 1 1 0 0 )   b
 C   ( 1 0 1 0 1 0 1 )   c
 D = ( 1 1 0 1 1 1 0 )   d
 E   ( 0 1 1 1 1 0 1 )   e
 F   ( 1 0 0 1 0 1 1 )   f
 G   ( 0 0 1 0 1 1 1 )   g
```
This matrix over GF(2) is not invertible; its rank is only 5, so the lights cannot be changed arbitrarily. By Gaussian elimination [3], one finds that switch f does the same as switches a+b+e, and button g the same as b+c+d. This means there’s no need to use these switches (f=g=0) and the matrix equation simplifies to

```
A   ( 1 0 1 1 0 )   a
B   ( 0 1 0 1 1 )   b
C = ( 1 0 1 0 1 )   c
D   ( 1 1 0 1 1 )   d
E   ( 0 1 1 1 1 )   e
```
Using Linear Algebra, we can invert the matrix [4] and express the switch values in terms of the light values:

```
a   ( 0 1 0 1 0 )   A
b   ( 1 1 1 0 0 )   B
c = ( 0 1 0 0 1 )   C
d   ( 1 0 0 1 1 )   D
e   ( 0 0 1 1 1 )   E
```
So if the puzzle has only lights A and E off, and we want to know what switches to press to flip these two lights and no others, then we compute the sum of the 1st and 5th column of the matrix:

```
0   ( 0 1 0 1 0 )   1
1   ( 1 1 1 0 0 )   0
1 = ( 0 1 0 0 1 )   0
0   ( 1 0 0 1 1 )   0
1   ( 0 0 1 1 1 )   1
```
to find that switches b, c, and e must be pressed. Indeed:

```
_ 0 _ 1       _ 1 _ 0       _ 0 _ 1         _ 1 _ 0
0 _ 1_        1 _ 0 _       1 _ 1 _         0 _ 0 _
_ 1 _ 0   +   _ 1 _ 0   +   _ 1 _ 0    =    _ 1 _ 0
1 _ 0 _       0 _ 1 _       1 _ 1 _         0 _ 0 _
   b             c             e
```
Happy flipping!

[1] [https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/flip.html](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/flip.html)

[2] [http://www.technoblogy.com/show?3PO0](http://www.technoblogy.com/show?3PO0)

[3] [https://en.wikipedia.org/wiki/Gaussian_elimination](https://en.wikipedia.org/wiki/Gaussian_elimination)

[4] [https://en.wikipedia.org/wiki/Gaussian_elimination#Finding_the_inverse_of_a_matrix](https://en.wikipedia.org/wiki/Gaussian_elimination#Finding_the_inverse_of_a_matrix)
