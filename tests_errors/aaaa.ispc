// 1: addr-of-1.ispc
// CHECK: Error: Illegal to take address of non-lvalue or function.

void foo1() {
    int *ptr = &(1+1);
}
// 2: array-dim-huge.ispc
// CHECK: Error: Array dimension must be representable with a 32-bit integer.

struct foo2 {
    int x[0xffffffffffff];
};


// 3: array-dim-negative.ispc
// CHECK: Error: Array dimension must be non-negative.

struct foo3 {
    int x[-1];
};


// 4: array-increment.ispc
// CHECK: Error: Can only pre/post increment numeric and pointer types, not "varying float[5]".

void foo4() {
    float a[5] = { 1,2,3,4,5};
    ++a;
}
// 5: array-plus-equals.ispc
// CHECK: Error: Illegal to assign to array type "varying float[5]".

void foo5(float *x) {
    float a[5] = { 1,2,3,4,5};
    a += 3;
}
// 6: array-pointer-assign.ispc
// CHECK: Error: Illegal to assign to array type "varying float[5]".

void foo6(float *x) {
    float a[5] = { 1,2,3,4,5};
    a = x;
}
// 7: assign-struct-with-const-member-2.ispc
// CHECK: Error: Illegal to assign to type "varying struct Bar7" in type "varying struct Foo7" due to element "a" with type "const varying int32".

struct Bar7 {
    const int a;
};

struct Foo7 {
    struct Bar7 b;
};

void foo7(Foo7 f) {
    Foo7 g;
    g = f;
}
// 8: assign-struct-with-const-member.ispc
// CHECK: Error: Illegal to assign to type "varying struct Foo8" due to element "a" with type "const varying int32".

struct Foo8 {
    const int a;
};

void foo8(Foo8 f) {
    Foo8 a;
    a = f;
}
// 10: const-1.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

int func10() {
    const int x = 2;
    ++x;
}
// 11: const-2.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

int func11() {
    const int x = 2;
    x = 0;
}
// 12: const-3.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

struct Foo12 {
    int x;
};

int func12(const Foo12 f) {
    f.x = 0;
}
// 13: const-4.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

//struct Foo13 {
//    int x;
//};

int func13(const int f) {
    f -= 2;
}
// 14: const-5.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

int func14() {
    const int a[10] = {1,2,3,4,5,6,7,8,9,10};
    a[0] = 1;
}
// 15: const-global.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

const int x15 = 0;

void foo15() {
    ++x15;
}
// 16: const-too-large.ispc
// CHECK: Warning: Binary expression with type "const uniform int8" can't represent value.

int8 v = (int8)64 * (int8)32;


// 18: deref-1.ispc
// CHECK: Error: Member operator "." can't be used with expression of "uniform int32" type.

int func18(int *a) {
    a.x = 0;
}
// 19: deref-2.ispc
// CHECK: Error: Member operator "." can't be applied to pointer type "uniform struct Foo19". Did you mean to use "->"?

struct Foo19 { int x; };

int func19(Foo19 *a) {
    a.x = 0;
}
// 20: deref-3.ispc
// CHECK: Error: Member operator "->" can't be applied to non-pointer type "varying struct Foo20". Did you mean to use "."?

struct Foo20 { int x; };

int func20(Foo20 a) {
    a->x = 0;
}
// 21: deref-4.ispc
// CHECK: Error: Illegal to dereference non-pointer type "varying float".

float func21(float a) {
    *a = 0;
    return 0;
}
// 22: deref.ispc
// CHECK: Error: Member operator "->" can't be used with expression of "uniform int32" type.

int func22(int *a) {
    a->x = 0;
}
// 23: export-multiple-name.ispc
// CHECK: Error: Illegal to provide "export" qualifier for functions with the same name but different types.

export void foo23() { }

export void foo23(uniform int x) { }
// 24: export-vector-param.ispc
// CHECK: Error: Vector-typed parameter "x" is illegal in an exported function.

export void foo24(uniform float<3> x) {
}


// Late errors
// 9: break.ispc
// CHECK: Error: "break" statement is illegal outside of

void foo9() {
    break;
}

// 17: decl-4.ispc
// CHECK: Error: Illegal to declare an unsized array variable without providing an initializer expression to set its size.

int func17() {
    int a[];
}
