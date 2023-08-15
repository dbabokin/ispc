// 44: global-decl-1.ispc
// CHECK: Error: Definition of variable "foo44" conflicts with definition at

extern int foo44;
float foo44;
// 45: global-decl-2.ispc
// CHECK: Error: Definition of variable "foo45" conflicts with definition at

extern int foo45;
extern float foo45;
// 46: global-redef-1.ispc
// CHECK: Error: Definition of variable "foo46" conflicts with definition at

int foo46;
float foo46;
// 47: global-redef.ispc
// CHECK: Error: Redefinition of variable "foo47" is illegal.

int foo47;
int foo47;

// 54: initexpr-2.ispc
// CHECK: Error: Initializer list for array "varying int32[2][4]" must have no more than 2 elements (has 3).

int a54[2][4] = { { 1, 2, 3 }, { 1, 2, 3, 4 }, 1 };

// 57: initexpr-5.ispc
// CHECK: Error: Inconsistent initializer expression list lengths make it impossible to size unsized array dimensions.

int a57[2][] = { { 1, 2, 3 }, { 1, 2, 3, 4 } };

// 58: initexpr-6.ispc
// CHECK: Error: Illegal to declare a global variable with unsized array dimensions that aren't set with an initializer expression.

int a58[][];

// 61: lvalue-2.ispc
// Can't assign to type "const uniform int32" on left-hand side of expression.

int bar61(){
    4 = 0;
}

// 62: lvalue-3.ispc
// CHECK: Error: Can't assign to type "const uniform int32" on left-hand side of expression.

int bar62(){
    int x;
    4 = x;
}

// LATE - emit code

// 48: goto-1.ispc
// CHECK: Error: Multiple labels named "label" in function.

void func48(int x) {
 label:
    ;
 label:
     ;
}


// 49: goto-2.ispc
// CHECK: Error: "goto" statements are only legal under "uniform" control flow

void func49(int x) {
    if (x < 0)
        goto label;

 label:
        ;
}


// 50: goto-3.ispc
// CHECK: Error: "goto" statements are only legal under "uniform" control flow.

void func50(int x) {
    cif (x < 0)
        goto label;

 label:
        ;
}


// 51: goto-4.ispc
// CHECK: Error: "goto" statements are only legal under "uniform" control flow.

void func51(int x) {
 label:

    for(int i =0 ;i<x;)
        goto label;
}


// 52: goto-5.ispc

// CHECK: Error: No label named "label" found in current function.
void func52(int x) {
completelydifferentlabel:
    goto label;
}

// 53: goto-6.ispc

// CHECK: Error: No label named "label" found in current function.
void func53(int x) {
libel:
babel:
lbel:
label2:
    goto label;
}

// 55: initexpr-3.ispc
// CHECK: Error: Inconsistent initializer expression list lengths make it impossible to size unsized array dimensions.

void foo55() {
    int a[2][] = { { 1, 2, 3 }, { 1, 2, 3, 4 } };
}

// 56: initexpr-4.ispc
// CHECK: Error: Illegal to declare an unsized array variable without providing an initializer expression to set its size.

void foo56() { int a[][]; }

// 59: int-ptr-fail.ispc
// CHECK: Error: Type conversion from "const uniform int32" to "uniform int32 * varying" for initializer is not possible

int foo59() {
    int * varying foo = 1l;
}
// 60: lvalue-1.ispc
// CHECK: Error: Left hand side of assignment expression can't be assigned to.

int foo60() {return 2;}

int bar60()
{
    foo60() = 2;
}

// 63: nested-foreach.ispc
// CHECK: Error: Nested "foreach" statements are currently illegal.

void func63();

void foo63(uniform int a, uniform int b) {
    foreach (i = 0 ... a) {
        foreach (j = 0 ... b) {
            func63();
        }
    }
}
