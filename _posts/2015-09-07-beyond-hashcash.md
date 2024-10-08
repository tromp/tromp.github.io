---
layout: post
title: "Beyond the Hashcash Proof-of-Work (there’s more to mining than hashing)"
date: 2015-09-07
---

Many people equate Proof of Work (PoW) with one particular instance of it.  It’s not hard to understand why. The Hashcash PoW is used not only in Bitcoin but in the vast majority of altcoins as well.

In Hashcash, miners all compete to look for a so called `nonce’ which, if provided as input (together with other parts of a block header) to a hash function, yields an output that’s numerically small enough to claim the next block reward.

Where most crypto currencies differ is in the choice of hash function; the Hashcash flavor as it were. Besides Bitcoin’s `vanilla’ flavor of SHA256, there is Litecoin’s scrypt, Cryptonote’s CryptoNight, Darkcoin’s X11, and many more. Most alternative flavors have the explicitly stated goal of reducing the performance gap between custom and commodity hardware, either by use of memory, or by sheer complexity.

But miners are only part of the picture. Proofs of work must not only be found, but verified as well, by every single client, including smartphones and other devices with limited resources. In Hashcash, verification amounts to evaluating the hash function on the given nonce and comparing the output with the difficulty threshold. Which is exactly the same effort as a single proof attempt.

Thus, in order to keep verification cheap, hash functions in Hashcash must restrict their resource usage as well. That’s why scrypt is configured to use only 128KB of memory.

Non-Hashcash PoWs do not suffer this limitation; they are asymmetric, with verification much cheaper than proof attempt. The first such PoW is Primecoin, which finds chains of nearly doubled prime numbers. The most recent example is my Cuckoo Cycle PoW, which was presented at the BITCOIN’2015 workshop in January. The whitepaper can be found at github.com/tromp/cuckoo, which also hosts various implementations, as well as bounties for improving on them.

In Cuckoo Cycle, proofs take the form of a length 42 cycle (loop) in a large random graph defined by some nonce. Imagine two countries, each with a billion cities, and imagine picking a billion border crossing roads that connect a random city in one country to a random city in the other country (the PoW actually uses a cheaply computed hash function to map the nonce, road number, and country to a city). We are asked if there is cycle of 42 roads visiting 42 different cities. If someone hands you a nonce and 42 road numbers, it is indeed easy to verify, requiring negligible time and memory.

But finding such a cycle is no easy task. Note however, that a city that connects to one road only cannot be part of the solution, nor can that road. David Andersen pointed out that such dead-end roads can be repeatedly eliminated, using one bit of memory per road to remember if that road is useful, and two bits per city to count if there are zero, one, or multiple useful roads to that city.

This process of computing counts for cities, and marking roads that lead to a city with count one as not useful, is the essence of Cuckoo Cycle mining and accounts for about 98% of the effort. It results in billions of random global memory accesses for reading and writing the counters. Consequently, about 2/3 of the runtime is memory latency, making this a low-power algorithm that keeps computers running cool.

After a sufficient number of counting and marking rounds, so few useful roads remain that another algorithm, inspired by Cuckoo Hashing, can quickly identify cycles (re-using the memory for the no longer needed counters). 

Cuckoo Cycle has some downsides as well. First of all, proofs are large and will roughly triple the size of block headers. Secondly, it is very slow, taking the better part of a minute on a high end CPU (or GPU, which offer roughly the same speed) to look for a cycle among a billion roads.

In order to give slower CPUs a (somewhat) fair chance to win, the block interval should be much longer than a single proof attempt, so the amount of memory Cuckoo Cycle can use is constrained by the choice of block interval length.

These seem like reasonable compromises for an instantly verifiable memory bound PoW that is unique in being dominated by latency rather than computation. In that sense, mining Cuckoo Cycle is a form of ASIC mining where DRAM chips serve the application of randomly reading and writing billions of bits.

When even phones charging overnight can mine without orders of magnitude loss in efficiency, not with a mindset of profitability but of playing the lottery, the mining hardware landscape will see vast expansion, benefiting adoption as well as decentralization.
