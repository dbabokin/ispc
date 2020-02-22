//; RUN: %{ispc} %s --target=avx512skx-i32x16 --emit-asm -o - | FileCheck -check-prefix=AVX512F %s
//; RUN: %{ispc} %s --target=avx512knl-i32x16 --emit-asm -o - | FileCheck -check-prefix=AVX512F %s

// The purpose of this file is:
// (1) to test in systematic way that we are generating correct AVX512F instructions for primitives supported by ISPC.
// (2) to enumerate AVX512F instruction that have no clear mapping from ISPC.

// Note that this file focuses exclusivly on AVX512F.
// SKX is AVX512 F+VL+DQ+BW
// KNL is AVX512 F+CD+ER+PF

// AVX512F instruction groups:
// 1. Arithmetic, logic, and bit manipulation per-element instructions (most of them map to varying arithmetic).
// 2. Type convertions (most of them map to type convertions in ISPC).
// 3. Gather/scatter, memory moves (generally supported through ISPC pointers).
// 4. Element shuffles (not explicitly generated from ISPC).
// 5. Mask manipulations (indirectly supported by ISPC through control flow).
// 6. String instructions (generally not supported by ISPC).
// 7. Others.

// 1. Arithmetic instructions:
// add
// sub
// mul
// PMULUDQ (i32xi32->i64) - not supported
// div
// fma/fms/fnma/fnms
// fmaddsubb/fmsubadd - not supported
// min
// max
// abs - not supported yet, issue #1486
// sqrt
// rcp
// rsqrt
// scale (x*2^y) - not supported
// round scale - not supported
// fixup - not supported
// get exponent / get mantissa - not supported
// cmp
//
//    Logic:
// and
// andnot
// or
// xor
// ternary - not supported.
//
//    Bit manipulation:
// bit rotate left / right - not supported
// bit shift left / arith right / logical right
// variable bit shift left / arith right / logical right

// 6. String instructions.
// align - not supported.
// compress - not supported.
// expand - not supported.


// LLVM 5.0 is known not to generate some of expected instructions.


// AVX512F-LABEL: vaddps___
float vaddps(float f1, float f2) {
    float f = 0;
    if (f1 > 5) {
// AVX512F: vaddps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
        f = f1+f2;
    }
    return f;
}

// AVX512F-LABEL: vaddpd___
double vaddpd(double d1, double d2) {
    double d = 0;
    if (d1 > 5) {
// AVX512F: vaddpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
// AVX512F: vaddpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
        d = d1+d2;
    }
    return d;
}

// ADDSS/ADDSD - no

// VALIGND/VALIGNQ ??

// AVX512F-LABEL: vblendps___
float vblendps(float f1, float f2) {
    float f;
// AVX512F: vblendmps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
    if (f1 > 0) {
        f = f1;
    } else {
        f = f2;
    }
    return f;
}

// AVX512F-LABEL: vblendpd___
double vblendpd(double d1, double d2) {
    double d;
// AVX512F: vblendmpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
// AVX512F: vblendmpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
    if (d1 > 0) {
        d = d1;
    } else {
        d = d2;
    }
    return d;
}

// AVX512F-LABEL: vpblendmd___
int vpblendmd(int i1, int i2) {
    int i;
// AVX512F: vpblendmd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
    if (i1 > 0) {
        i = i1;
    } else {
        i = i2;
    }
    return i;
}

// AVX512F-LABEL: vpblendmq___
int64 vpblendmq(int64 i1, int64 i2) {
    int64 i;
// AVX512F: vpblendmq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
// AVX512F: vpblendmq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}}
    if (i1 > 0) {
        i = i1;
    } else {
        i = i2;
    }
    return i;
}

// AVX512F-LABEL: vpbroadcastd___
int vpbroadcastd(uniform int i) {
// AVX512F: vpbroadcastd {{%e[a-z]+}}, {{%zmm[0-9]+}}
    return i;
}

// AVX512F-LABEL: vpbroadcastq___
int64 vpbroadcastq(uniform int64 i) {
// AVX512F: vpbroadcastq {{%r[a-z]+}}, {{%zmm[0-9]+}}
    return i;
}

// AVX512F-LABEL: vbroadcastss___
float vbroadcastss(uniform float i) {
// AVX512F: vbroadcastss {{%xmm[0-9]+}}, {{%zmm[0-9]+}}
    return i;
}

// AVX512F-LABEL: vbroadcastsd___
double vbroadcastsd(uniform double i) {
// AVX512F: vbroadcastsd {{%xmm[0-9]+}}, {{%zmm[0-9]+}}
    return i;
}

// VBROADCASTF64X4  - ??

// AVX512F-LABEL: vpcmpd___
int vpcmpd(int i1, int i2) {
// AVX512F: vpcmpgtd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
    return i1 > i2 ? 1 : 0;
}

// AVX512F-LABEL: vpcmpq___
int vpcmpq(int64 i1, int64 i2) {
// AVX512F: vpcmpgtq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
// AVX512F: vpcmpgtq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
    return i1 > i2 ? 1 : 0;
}

// AVX512F-LABEL: vcmppf___
int vcmppf(float f1, float f2) {
// AVX512F: vcmpnleps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
    return f1 > f2 ? 1 : 0;
}

// AVX512F-LABEL: vcmppd___
int vcmppd(double d1, double d2) {
// AVX512F: vcmpnlepd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
// AVX512F: vcmpnlepd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%k[0-9]+}}
    return d1 > d2 ? 1 : 0;
}

// VCOMISD/VCOMISS - no

// AVX512F-LABEL: vdivps___
float vdivps(float f1, float f2) {
    float f = 0;
// AVX512F: vdivps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
    if (f1 > f2) {
        f = f1 / f2;
    }
    return f;
}

// AVX512F-LABEL: vdivpd___
double vdivpd(double d1, double d2) {
    double d = 0;
// AVX512F: vdivpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
// AVX512F: vdivpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}} {{{%k[0-9]+}}} {z}
    if (d1 > d2) {
        d = d1 / d2;
    }
    return d;
}

// VCOMPRESSPS / VCOMPRESSPD - ??

// Converts.
// Missing converts: scalar / vector [f32, f64] -> [i32, u32] with out truncation.
// Missing f16 converts: f16 <-> f32.

//////////// Vector converts

// AVX512F-LABEL: vcvtdq2pd___
double vcvtdq2pd(int i) {
// AVX512F: vcvtdq2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vcvtdq2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
    return (double) i;
}

// AVX512F-LABEL: vcvtdq2ps___
float vcvtdq2ps(int i) {
// AVX512F: vcvtdq2ps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return (float) i;
}

//trunc
// AVX512F-LABEL: vcvttpd2dq___
int vcvttpd2dq(double d) {
// AVX512F: vcvttpd2dq {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
// AVX512F: vcvttpd2dq {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
    return (int) d;
}

// AVX512F-LABEL: vcvtpd2ps___
float vcvtpd2ps(double d) {
// AVX512F: vcvtpd2ps {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
// AVX512F: vcvtpd2ps {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
    return (float) d;
}

//trunc
// AVX512F-LABEL: vcvttpd2udq___
unsigned int vcvttpd2udq(double d) {
// AVX512F: vcvttpd2udq {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
// AVX512F: vcvttpd2udq {{%zmm[0-9]+}}, {{%ymm[0-9]+}}
    return (unsigned int) d;
}

//trunc
// AVX512F-LABEL: vcvttps2dq___
int vcvttps2dq(float f) {
// AVX512F: vcvttps2dq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return (int) f;
}

//trunc
// AVX512F-LABEL: vcvttps2udq___
unsigned int vcvttps2udq(float f) {
// AVX512F: vcvttps2udq {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return (unsigned int) f;
}

// AVX512F-LABEL: vcvtps2pd___
double vcvtps2pd(float f) {
// AVX512F: vcvtps2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vcvtps2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
    return (double) f;
}

// AVX512F-LABEL: vcvtudq2pd___
double vcvtudq2pd(unsigned int u) {
// AVX512F: vcvtudq2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vcvtudq2pd {{%ymm[0-9]+}}, {{%zmm[0-9]+}}
    return (double) u;
}

// AVX512F-LABEL: vcvtudq2ps___
float vcvtudq2ps(unsigned int u) {
// AVX512F: vcvtudq2ps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return (float) u;
}

//////////// Scalar converts

//trunc
// AVX512F-LABEL: vcvttsd2si___
uniform int vcvttsd2si(uniform double d) {
// AVX512F: vcvttsd2si {{%xmm[0-9]+}}, %e{{[a-z]+}}
    return (uniform int) d;
}

//trunc
// AVX512F-LABEL: vcvttsd2usi___
uniform unsigned int vcvttsd2usi(uniform double d) {
// AVX512F: vcvttsd2usi {{%xmm[0-9]+}}, %e{{[a-z]+}}
    return (uniform unsigned int) d;
}

// AVX512F-LABEL: vcvtsd2ss___
uniform float vcvtsd2ss (uniform double d) {
// AVX512F: vcvtsd2ss {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform float) d;
}

// AVX512F-LABEL: vcvtsi2sd___
uniform double vcvtsi2sd(uniform int i) {
// AVX512F: vcvtsi2sdl %e{{[a-z]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform double) i;
}

// AVX512F-LABEL: vcvtsi2ss___
uniform float vcvtsi2ss(uniform int i) {
// AVX512F: vcvtsi2ssl %e{{[a-z]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform float) i;
}

// AVX512F-LABEL: vcvtss2sd___
uniform double vcvtss2sd(uniform float f) {
// AVX512F: vcvtss2sd {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform double) f;
}

//trunc
// AVX512F-LABEL: vcvttss2si___
uniform int vcvttss2si(uniform float f) {
// AVX512F: vcvttss2si {{%xmm[0-9]+}}, %e{{[a-z]+}}
    return (uniform int) f;
}

//trunc
// AVX512F-LABEL: vcvttss2usi___
uniform unsigned int vcvttss2usi(uniform float f) {
// AVX512F: vcvttss2usi {{%xmm[0-9]+}}, %e{{[a-z]+}}
    return (uniform unsigned int) f;
}

// AVX512F-LABEL: vcvtusi2sd___
uniform double vcvtusi2sd(uniform unsigned int u) {
// AVX512F: vcvtusi2sdl %e{{[a-z]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform double) u;
}

// AVX512F-LABEL: vcvtusi2ss___
uniform float vcvtusi2ss(uniform unsigned int u) {
// AVX512F: vcvtusi2ssl %e{{[a-z]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return (uniform float) u;
}

// VEXPANDPS / VEXPANDPD - ??

// VEXTRACTF32x4/VEXTRACTF64x4 / VEXTRACTI32x4/VEXTRACTI64x4 - ??

// EXTRACTPS - ?? 

// VFIXUPIMMPD / VFIXUPIMMPS / VFIXUPIMMSD / VFIXUPIMMSS - ??

// FMA: missing fmns, fmsubadd / fmaddsub

// AVX512F-LABEL: fmaddps___
float fmaddps(float a, float b, float c) {
// AVX512F: vfmadd{{[1-3]+}}ps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return a*b+c;
}

// AVX512F-LABEL: fmaddpd___
double fmaddpd(double a, double b, double c) {
// AVX512F: vfmadd{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vfmadd{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return a*b+c;
}

// AVX512F-LABEL: fmsubps___
float fmsubps(float a, float b, float c) {
// AVX512F: vfmsub{{[1-3]+}}ps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return a*b-c;
}

// AVX512F-LABEL: fmsubpd___
double fmsubpd(double a, double b, double c) {
// AVX512F: vfmsub{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vfmsub{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return a*b-c;
}

// AVX512F-LABEL: fnmaddps___
float fnmaddps(float a, float b, float c) {
// AVX512F: vfnmadd{{[1-3]+}}ps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return c-a*b;
}

// AVX512F-LABEL: fnmaddpd___
double fnmaddpd(double a, double b, double c) {
// AVX512F: vfnmadd{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vfnmadd{{[1-3]+}}pd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return c-a*b;
}

// Gather: double / int64 do not work.

// AVX512F-LABEL: vgatherdps___
float vgatherdps(uniform float * uniform p, int i) {
// AVX512F: vgatherdps (%r{{[a-z]+}},{{%zmm[0-9]+}}), {{%zmm[0-9]+}} {{{%k[0-9]+}}}
#pragma ignore warning(perf) 
    return p[i];
}

// AVX512F-LABEL: vgatherqps___
int vgatherqps(uniform int * uniform p, int i) {
// AVX512F: vpgatherdd (%r{{[a-z]+}},{{%zmm[0-9]+}}), {{%zmm[0-9]+}} {{{%k[0-9]+}}}
#pragma ignore warning(perf)
    return p[i];
}

// GETEXP / GETMANT - ??

// VINSERTF32x4/VINSERTF64x4 - ??

// INSERTPS - ??

// Min/max:

// AVX512F-LABEL: maxps___
float maxps(float f1, float f2) {
// AVX512F: vmaxps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return max(f1, f2);
}

// AVX512F-LABEL: maxpd___
double maxpd(double f1, double f2) {
// AVX512F: vmaxpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vmaxpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return max(f1, f2);
}

// AVX512F-LABEL: maxss___
uniform float maxss(uniform float f1, uniform float f2) {
// AVX512F: vmaxss {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return max(f1, f2);
}

// AVX512F-LABEL: maxsd___
uniform double maxsd(uniform double f1, uniform double f2) {
// AVX512F: vmaxsd {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return max(f1, f2);
}

// AVX512F-LABEL: minps___
float minps(float f1, float f2) {
// AVX512F: vminps {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return min(f1, f2);
}

// AVX512F-LABEL: minpd___
double minpd(double f1, double f2) {
// AVX512F: vminpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
// AVX512F: vminpd {{%zmm[0-9]+}}, {{%zmm[0-9]+}}, {{%zmm[0-9]+}}
    return min(f1, f2);
}

// AVX512F-LABEL: minss___
uniform float minss(uniform float f1, uniform float f2) {
// AVX512F: vminss {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return min(f1, f2);
}

// AVX512F-LABEL: minsd___
uniform double minsd(uniform double f1, uniform double f2) {
// AVX512F: vminsd {{%xmm[0-9]+}}, {{%xmm[0-9]+}}, {{%xmm[0-9]+}}
    return min(f1, f2);
}
