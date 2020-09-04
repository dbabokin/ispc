#include <benchmark/benchmark.h>
#include <cstdint>
#include <stdio.h>

#include "../common.h"
#include "05_scatter_ispc.h"

static Docs docs("Test scatter performance\n");

#define ARGS RangeMultiplier(2)->Range(64, 64 << 6)->Complexity(benchmark::oN)

template <typename T> static void init(T *dst, int *idx, int count) {
    for (int i = 0; i < count; i++) {
        idx[i] = (i * 3) % count;
        dst[i] = 0;
    }
}

template <typename T> static void check(T *dst, int count) {
    for (int i = 0; i < count; i++) {
        if (dst[((i * 3) % count)] != i) {
            printf("Error i=%d\n", i);
            return;
        }
    }
}

static void scatter_i32_bench(benchmark::State &state) {
    int count = state.range(0);
    int *dst = static_cast<int *>(aligned_alloc(ALIGNMENT, sizeof(int) * count));
    int *idx = static_cast<int *>(aligned_alloc(ALIGNMENT, sizeof(int) * count));

    // init
    init(dst, idx, count);

    for (auto _ : state) {
        ispc::scatter_i32(dst, idx, count);
    }

    // check
    check(dst, count);

    free(dst);
    free(idx);
    state.SetComplexityN(state.range(0));
}

BENCHMARK(scatter_i32_bench)->ARGS;

BENCHMARK_MAIN();
