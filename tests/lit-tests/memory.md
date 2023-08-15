One of the most important, if not the most important, optimizations that ISPC is doing is optimization of memory accesses - generation of vector loads/stores and gathers/scatters. The language ensures that information required for optimisal generation is explicitly present in the program and the compiler is able to use it.

Language constructs that lead to generation of vector loads/stores and gathers/scatters:
- dereferencing a uniform pointer to a varying value: vector loads/stores or masked vector load/store
- indexing into an array with varying value: vector loads/stores, masked vector load/stroe, and gathers/scatters.

Compiler optimization flow:
- front-end generates pseudo gather/scatter intrinsics
- ImproveMemoryOpsPass many times
- IntrinsicsOpt - if the mask is known for masked load/stores and it's all-off or all-on, replace it with undef value or regular vector load/store.
- ReplacePseudoMemoryOpsPass

Internal reprsentation of vector memory operations:
- pseudo gather/scatter - memory location is represented as a vector of (independent) pointers and a mask. `__pseudo_gather[32|64]_[type]`
- [native] pseudo gather/scatter base offsets - memory location is represented as a uniform base pointer with a vector of 32 or 64 bit offsets and optional scale (1/2/4/8). This form is for targets with gather/scatter support.
- [scalar] factored pseudo gather/scatter base offset - memory location is represented as a uniform base pointer with a vector of 32 or 64 bit offsets and optional scale (1/2/4/8) and a vector "offset delta", and a mask. This form is for targets without gather/scatter support.
- hardware instructions.

Types of vector memory operations:
- vector load/store
- masked vector load/store
- gather/scatter


32bit addressing?
