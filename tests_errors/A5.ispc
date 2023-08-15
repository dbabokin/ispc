// 64: new-delete-1.ispc
// CHECK: Error: Illegal to delete non-pointer type "varying int32".
// rule: skip on arch=xe32
// rule: skip on arch=xe64
void func64(int a) {
    delete a;
}
// 65: new-delete-2.ispc
// CHECK: Error: syntax error, unexpected 'const'.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

int * func65(int a) {
    return const new int[a];
}
// 66: new-delete-3.ispc
// CHECK: Error: syntax error, unexpected '(', expecting ',' or ';'.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

int * func66(int a) {
    return new int[a](10);
}
// 67: new-delete-4.ispc
// CHECK: Error: Type conversion from "varying struct P67" to "varying unsigned int32" for item count is not possible.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

struct P67 { int x; };

int * func67(P67 p) {
    return new int[p];
}
// 68: new-delete-5.ispc
// CHECK: Error: Illegal to provide "varying" allocation count with "uniform new" expression.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

int * func68(int x) {
    return uniform new int[x];
}
// 69: new-delete-6.ispc
// CHECK: Error: Can't convert from type "uniform int32 * varying" to type "uniform int32 * uniform" for return statement.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

int * uniform func69(int x) {
    return new int[x];
}
// 70: new-delete-7.ispc
// CHECK: Error: Can't convert from type "varying float" to type "uniform float" for initializer.
// rule: skip on arch=xe32
// rule: skip on arch=xe64

struct Point70 {
    uniform float x, y, z;
};

export void f_fu70(uniform float RET[], uniform float aFOO[], uniform float b) {
    float a = aFOO[programIndex];
    uniform Point70 * uniform buf = uniform new uniform Point70(a, b, 1234.);
    RET[programIndex] = buf->y;
    delete buf;
}
