// rule: skip on arch=x86
// rule: skip on arch=x86-64
export void f_fu(uniform float RET[], uniform float aFOO[], uniform float b) {
    float16 a = aFOO[programIndex];
    RET[programIndex] = min(-10 * (a - 3), .5f16);
    RET[programCount - 1] = min(-10 * (float16)b, 2.0f16);
}

export void result(uniform float RET[]) {
    RET[programIndex] = -10 * (programIndex - 2);
    RET[0] = .5f16;
    RET[1] = .5f16;
    RET[programCount - 1] = -50;
}
