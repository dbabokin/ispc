#include "test_static.isph"
task void f_fu(uniform float RET[], uniform float aFOO[], uniform float b) {
    int a = b;
    RET[programIndex] = reduce_equal(a) ? 1 : 0; 
}

task void result(uniform float RET[]) {
    RET[programIndex] = 1;
}
