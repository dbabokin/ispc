#include "test_static.isph"
struct Foo {
    float x;
    float f;
    int i[3];
};

float bar(struct Foo f) { return f.f; }
task void f_fu(uniform float RET[], uniform float aFOO[], uniform float b) {
    float a = aFOO[programIndex];
    struct Foo myFoo[3] = { { a, a, {a, a, a} }, 
                            { a, a, {a, a, a} }, 
                            { a, a, {a, a, a} } };
    RET[programIndex] = bar(myFoo[1]);
}


task void result(uniform float RET[4]) {
    RET[programIndex]=1+programIndex;
}
