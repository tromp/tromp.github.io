---
layout: post
title: "Useless Darts Trivia"
date: 2014-12-22
---

## Which scores are finishes?

One can throw 36, 40, or 50 plus any triple up to 120, and these numbers are 0, 1, and 2 modulo 3 respectively. In a picture:
```
           ... 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170
triple+36       *           *           *
triple+40           *           *           *           *
triple+50               *           *           *           *           *           *           *

finishes:  ... 150 151 152 153 154 155 156 157 158     160 161         164         167         170
```

## How many possible 9-darter games are there?

This seems rather dificult to count until we start to distinguish cases based on final double and minimum of the first 8 darts. The 50,50 entry for instance is calculated as partitions of 501 - 50 - 8 * 50 = 51 into 0s, 1s, 4s, 7s, and 10s, with at least one 0:
```
(    8    )   (    8    )   (    8    )
(2 1 0 0 5) + (2 0 1 1 4) + (2 0 0 3 3) = 168 + 840 + 560 = 1568.


  \dbl     24    30    34    36    40    50
min\       --------------------------------
34                                       56
40                                      672
45                            8
48                           56
50                     56         672  1568
51                8         224
54               56         448
57          8    56          56
```

Giving a grand total of 3944 possible 9-darters, as confirmed in this report, which also states the number of essentially different solutions (as a multi-set of first 8 dart scores) as 22.

Note that a finishing double of e.g. 38 is not possible, as there is no way to partition 501-8\*60-38 = -17 into the numbers -3, -6, -9, -10, -12, and -15.

In practice you'll only see 9-darters starting with two 180s, leaving a 141 finish. The number of ways to finish 141 is calculated similarly:

```
  \dbl     24    30    34    36    40    50
min\       --------------------------------
34                                        2
40                                        2
45                            2
48                            2
50                      2           2
51                2           2
54                2
57          2
```

That's 20 ways.

## What is the most impressive 9-darter?

That would be throwing three 167 "finishes" in a row, repeating triple 20, triple 19, and bulls eye. The bulls eye is harder to hit than any triple, and a 9-darter can include at most three of them. I will likely never witness that in my lifetime, but then who could have imagined all of these incredible rarities?

