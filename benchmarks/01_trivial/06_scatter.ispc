export void scatter_i32(uniform int32 *uniform A, uniform int32 *uniform B, uniform int32 count) {
    foreach (i = 0...count) { A[B[i]] = i; }
}
