//==---------------- simple-esimd.cpp  - DPC++ ESIMD on-device test ---------==//

#include <CL/sycl.hpp>
#include <iostream>
#include <sycl/ext/intel/experimental/esimd.hpp>

using namespace sycl::ext::intel::experimental::esimd;

constexpr unsigned VL = 8;

extern "C" SYCL_EXTERNAL void vmult(simd<float, VL> *a, simd<float, VL> *res, int factor, int n) {
    for (int i = 0; i < n / VL; ++i) {
        auto b = a[i];
        res[i] = b * factor;
    }
}