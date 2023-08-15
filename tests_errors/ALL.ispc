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
// 26: foreach-assign.ispc
// CHECK: Error: Can't assign to type "const varying int32" on left-hand side of expression.

int foo26() {
    foreach (i = 0 ... 10) {
        ++i;
    }
}
// 27: foreach-unique-1.ispc
// CHECK: Error: Iteration domain type in "foreach_tiled" loop must be an atomic, pointer, or enum type, not "varying struct Point27".

struct Point27 {
    float x, y;
};

uniform int foo27(Point27 p) {
    uniform int count = 0;
    foreach_unique(pt in p)++ count;
    return count;
}

// 28: foreach-unique-2.ispc
// CHECK: Error: Can't assign to type "const uniform int32" on left-hand side of expression.

void foo28(int x) { foreach_unique(u in x)++ u; }

// 31: fptr-typecheck-1.ispc
// CHECK: Error: Too many parameter values provided in function call (3 provided, 2 expected).

float bar31(float a, float b);

export uniform int foo31(uniform int x[], uniform int i[]) {
    float (*fptr)(float, float) = bar31;
    fptr(0., 1, 2);
}
// 32: fptr-typecheck-2.ispc
// CHECK: Error: Can't convert argument of type "void * uniform" to type "varying float" for function call argument.

float bar32(float a, float b);

export uniform int foo32(uniform int x[], uniform int i[]) {
    float (*fptr)(float, float) = bar32;
    fptr(NULL, 1);
}
// 33: fptr-typecheck-3.ispc
// CHECK: Error: Too few parameter values provided in function call (1 provided, 2 expected).

float bar33(float a, float b);

export uniform int foo33(uniform int x[], uniform int i[]) {
    float (*fptr)(float, float) = bar33;
    fptr(1.);
}
// 34: func-call-through-variable.ispc
// CHECK: Error: Must provide function name or function pointer for function call expression.

export void saxpy_ispc(uniform int N, uniform float scale, uniform float X[], uniform float Y[],
                       uniform float result[]) {
    foreach (i = 0 ... N) {
        result[i] = scale * X[i] + Y[i];
    }
}

task void saxpy_ispc_task(uniform int N, uniform int span, uniform float scale, uniform float X[], uniform float Y[],
                          uniform float result[]) {
    uniform int indexStart;
    uniform int indexEnd;
    indexStart = (taskIndex * span);
    indexEnd = min(N, indexStart + (span) / 8);
    foreach (i = indexStart... indexEnd) {
        result[i] = scale * X[i] + Y[i];
    }
    uniform int k = 0;
    for (k = 0; k < 8; k++) {
        indexStart = (((7 - taskIndex - k) % 8) * span) + k(span / 8);
        indexEnd = min(N, indexStart + (span) / 8);
        foreach (i = indexStart... indexEnd) {
            result[i] = scale * X[i] + Y[i];
        }
    }
}
export void saxpy_ispc_withtasks(uniform int N, uniform float scale, uniform float X[], uniform float Y[],
                                 uniform float result[]) {

    uniform int span = N / 8; // 8 tasks

    launch[N / span] saxpy_ispc_task(N, span, scale, X, Y, result);
}
// 35: func-def-with-typedef.ispc
// CHECK: Error: Illegal "typedef" provided with function definition.

typedef float foo35(float a, float b) {}

// 36: func-export-task.ispc
// CHECK: Error: Function can't have both "task" and "export" qualifiers

export task void foo36() {}
// 37: func-overload-by-return-type.ispc
// CHECK: Error: Illegal to overload function by return type only.

float foo37() { int x = {2}; }

int y = {2};

void foo37() {
    do
        ;
    while (1);
}

// 38: func-param-mismatch-2.ispc
// CHECK: Error: Unable to find any matching overload for call to function

void foo38(int x);

void bar38(int x) { foo38(); }
// 39: func-param-mismatch-3.ispc
// CHECK: Error: Unable to find any matching overload for call to function

void foo39(int x);

void bar39(int x) { foo39(x, x); }
// 40: func-param-mismatch.ispc
// CHECK: Error: Unable to find any matching overload for call to function

void foo40();

void bar40(int x) { foo40(x); }
// 41: func-param-redeclare.ispc
// CHECK: Error: Ignoring redeclaration of symbol "a".

int foo41(int a[], int a) { return a[i]; }
// 42: func-param-static.ispc
// CHECK: Error: Storage class "static" is illegal in function parameter declaration for parameter "x".

void foo42(static int x) {}

// LATE 1 - type check

// 24: float-logical-1.ispc
// CHECK: Error: First operand to binary operator "&" must be an integer or bool.

float foo24(float a, float b) { return a & b; }
// 25: float-logical.ispc
// CHECK: Error: Illegal to use ^= operator with floating-point operands.

float foo25(float a, float b) { return a ^= b; }

// 43: function-redefinition.ispc
// CHECK: Error: Ignoring redefinition of function "foo43".

float foo43() { int x = {2}; }

int y43 = {2};

float foo43() {
    do
        ;
    while (1);
}

//LATE 2 - emit code

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

// 29: foreach-unique-3.ispc
// CHECK: Error: "break" statement is illegal outside of for/while/do loops and "switch" statements.

void foo29(int x) {
    foreach_unique(u in x) {
        if (u == 0)
            break;
    }
}

// 30: foreach-unique-4.ispc
// CHECK: Error: "return" statement is illegal inside a "foreach" loop.

void foo30(int x) {
    foreach_unique(u in x) {
        if (u == 0)
            return;
    }
}
