// rule: skip on cpu=TGLLP
bool ok(double x, double ref) { return (abs(x - ref) < 1d-7) || abs((x-ref)/ref) < 1d-6; }
export void f_du(uniform float RET[], uniform double aFOO[], uniform double b) {
  varying double arg = aFOO[programIndex] + b;
  varying double ref = log((float)arg);
  varying double res = log(arg);
  RET[programIndex] = ok(res, ref) ? 0. : 1.;
}

export void result(uniform float RET[]) {
    RET[programIndex] = 0.0;
}
