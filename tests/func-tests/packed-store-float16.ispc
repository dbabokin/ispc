#include "test_static.isph"
// rule: skip on arch=x86
// rule: skip on arch=x86-64
task void f_f(uniform float RET[], uniform float aFOO[]) {
    float a = aFOO[programIndex]; 
    uniform float16 pack[programCount];
    for (uniform int i = 0; i < programCount; ++i)
        pack[i] = 0;
    #pragma ignore warning(perf)
    packed_store_active(pack, (float16)a);
    #pragma ignore warning(perf)
    RET[programIndex] = pack[programIndex]; 
}

task void result(uniform float RET[]) {
    RET[programIndex] = 1 + programIndex;
}
