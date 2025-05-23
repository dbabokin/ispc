// RUN: %{ispc} --target=host %s -o - --emit-llvm-text | FileCheck %s
// RUN: %{ispc} --target=host --debug-phase=2:2 %s -o t.o | FileCheck %s --check-prefix=CHECK-DECL

// Before LLVM 16.0, the memory attribute was displayed as readonly, readnone
// not as memory(read), memory(none).

// CHECK: ; Function Attrs: {{.*}} memory(none)
// CHECK-LABEL: define {{.*}} @foo___univyi{{.*}}
// CHECK: ; Function Attrs: {{.*}} memory(argmem: read)
// CHECK-LABEL: define i32 @bar___un_3C_uni_3E_{{.*}}
__attribute__((memory("none"))) int foo(uniform int x, int y) { return y; }
__attribute__((memory("read"))) uniform int bar(uniform int *uniform p) { return *p; }

// CHECK-DECL: ; Function Attrs: nounwind memory(read)
// CHECK-DECL-LABEL: declare void @func1{{.*}}
// CHECK-DECL: ; Function Attrs: nounwind memory(none)
// CHECK-DECL-LABEL: declare void @func2{{.*}}
__attribute__((memory("read"))) void func1();
__attribute__((memory("none"))) void func2();
