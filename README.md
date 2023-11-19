## Testing my github blog

# Aliens

What if aliens sent us this message?

```
                                                      ┬──────────
                                                      ┼─────┬────
                                                      ┼─────┼─┬──
                                                      │ ──┬─┼ ┼ ┬
        ──┬────       ──┬────        ──┬────          │ ┬─┼─┼ │ │
        ┬─┼─┬──       ┬─┼─┬──        ┬─┼─┬──          │ │ ├─┘ │ │
        ┼─┼─┼─┬       ┼─┼─┼─┬        ┼─┼─┼─┬          │ ├─┘   │ │
        │ ├─┘ │       │ ├─┘ │        │ ├─┘ │          ├─┘     │ │
        │ ├───┘       │ ├───┘        │ ├───┘          ├───────┘ │
        ├─┘           ├─┘            ├─┘              ├─────────┘
                                                                         
    ─            ┬──          ┬─┬──          ┬─┬─┬──               ┬─┬──
    ┬            ┼─┬          ┼─┼─┬          ┼─┼─┼─┬               ┼─┼─┬
                 ├─┘          │ ├─┘          │ │ ├─┘               │ ├─┘
                              ├─┘            │ ├─┘                 ├─┘
                                             ├─┘
    
    ┬─┬───────────────────────────────────┬──── ────┬
    │ │ ┬─┬ ────┬─┬────────────────────── ┼───┬ ┬───┼
    │ │ ├─┘ ────┼─┼───────────────────┬── ┼───┼ │ ┬ │
    │ │ │   ┬───┼─┼───────────────────┼── ┼─┬─┼ │ ┼ │
    │ │ │   │ ─ ┼─┼─┬─────┬──── ──────┼─┬ │ ├─┘ ├─┘ │
    │ │ │   │ ┬ ├─┘ │ ┬─┬ ┼─┬─┬ ──┬───┼─┼ ├─┘   ├───┘
    │ │ │   ├─┘ ├───┘ ├─┘ │ ├─┘ ──┼─┬─┼─┼ │     │    
    │ │ │   │   │     │   ├─┘   ┬─┼─┼─┼─┼ │     │    
    │ │ │   │   │     ├───┘     ├─┘ │ ├─┘ │     │    
    │ │ │   │   ├─────┘         │   ├─┘   │     │    
    │ │ │   │   │               ├───┘     │     │    
    │ │ │   │   ├───────────────┘         │     │    
    │ │ │   ├───┘                         │     │    
    │ │ ├───┘                             │     │    
    │ │ ├─────────────────────────────────┘     │    
    │ ├─┘                                       │    
    ├─┘                                         │    
    ├───────────────────────────────────────────┘
```

# The largest number representable in 64 bits
Most people believe 18446744073709551615, or 0xFFFFFFFFFFFFFFFF in hexadecimal, to be the largest number representable in 64 bits. Which is indeed the case if we are talking about 64 bit unsigned integers such as represented by the datatype uint64\_t in C or u64 in Rust. We can reach quite a bit further with floating point values. The 64-bit double floating point format finds its largest (finite) representable value in the 309 digit number 21024(1-2-53) = 17976931...24858368.
