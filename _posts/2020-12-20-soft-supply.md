---
layout: post
title: "A case for using soft total supply."
date: 2020-12-20
---

The cryptocurrency space features endless debates about the pros and cons of various possible emission curves. Prime among them is question of whether supply should be capped (finite) or uncapped (infinite). But is this really an essential difference?

It doesn’t take much to change a finite supply into an infinite one. Bitcoin’s block reward drops from 1 satoshi to 0 satoshi somewhere in the year 2140, completing a supply of approximately 21 million bitcoin [1]. What if that final drop never happened?

Bitcoin would continue emitting a 1 satoshi block reward in perpetuity, yielding an infinite supply. It would eventually reach 21 million + 1 bitcoin. Let’s see when that happens. We need to wait an additional 100 million blocks, which takes approximately 10⁸/6/24/365 = 1902 years.

Would that make make Bitcoin any less hard a currency? I don’t think anyone would be willing to argue that. So what makes a currency hard, if not a capped supply? I think the answer is obvious. Eventual negligible inflation is what makes for hard currency. It is what distinguishes cryptocurrencies from fiat.

How low should inflation be to be considered negligible? There are two related measures for quantifying this. One is the yearly supply inflation rate, commonly used for fiat currencies. The other is its inverse, stock-to-flow ratio, the ratio between existing supply (stock) and the supply to be added in the next year (flow). This measure is popular for commodities. As discussed more extensively in https://medium.com/the-capital/stock-to-flow-ratio-why-bitcoins-value-increases-after-each-halving-d08c23d46a08, bitcoin’s inflation rate fell below 2% in 2020, and will fall below that of Gold in the next few years.

As long as the block reward (flow) never increases, then just by having supply increase every year, the inflation rate will naturally fall towards zero. The technical term for this is “disinflationary”. The inflation rate never reaches 0, but it gets arbitrarily close.

In cryptocurrency practice though, it doesn’t matter whether inflation has reached 0.1% or 0.01%. And that is because unlike Gold, it’s rather easy to lose cryptocurrency. Estimates for the fraction of all Bitcoin that is forever lost range from 15% to as much as 25%. People forget or lose passwords or take them to the grave. People accidentally erase wallet files. People accidentally send bitcoin to obsolete addresses, or straight into the void. People explicitly burn bitcoin. With newer coins, standards for recovery phrases, more mature software and hardware wallets, we can expect much lower loss percentages, but getting the yearly loss rate significantly below 1% will remain a challenge.

This motivates a definition of the “soft” end of emission as the time when the inflation rate drops below 1%, and the soft (total) supply as the supply at the time. At this time, new supply more or less balances the inevitable ongoing loss of coins. After its 4th halving in 2024, bitcoin will reach the soft end of its emission with a soft supply of (15/16) * 21M = 19.6875M BTC. At the extreme end of slow emissions is Grin. Its pure linear emission of 1 Grin per second forever, will reach its soft supply of a century (100\*365\*24\*60\*60s) of Grin, only in 2119.

This allows for a sensible supply comparison of nearly all coins. The only coins with uncapped soft supply are those with some explicit positive percentage growth rate, such as what fiat currencies aim for. I think there are only a handful of proof-of-stake coins that fall into that category. For all others, it gives a sensible measure of how far along a coin is in its emission. Using soft supply, a daily dollar issuance ranking like [2] would no longer need to show infinities for remaining supply of coins with a tail emission.

[1] [https://medium.com/amberdata/why-the-bitcoin-supply-will-never-reach-21-million-7263e322de1](https://medium.com/amberdata/why-the-bitcoin-supply-will-never-reach-21-million-7263e322de1)

[2] [https://www.f2pool.com/coins](https://www.f2pool.com/coins)
