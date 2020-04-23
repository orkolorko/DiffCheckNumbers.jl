module TestArithmetic

using Test
using DiffCheckNumbers

constant = DiffCheck{Float64, ()}(2.0, NamedTuple{(), NTuple{0, Float64}}(( )))
x = DiffCheck{Float64, (:x, )}(1.0, NamedTuple{(:x, ), NTuple{1, Float64}}((1.0, )))
xy = DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 1.0)))
z = DiffCheck{Float64, (:z, )}(1.0, NamedTuple{(:z, ), NTuple{1, Float64}}((1.0, )))
complex_z = DiffCheck(Complex{Float64}(1.0), :z)
complex_zw = DiffCheck(1.0+im*0, [:z, :w])

### Sum
@test x+constant === DiffCheck{Float64, (:x, )}(3.0, NamedTuple{(:x, ), NTuple{1, Float64}}((1.0, )))
@test x+2.0 === x+constant
@test x+2 === x+constant
@test x+Complex{Float64}(2.0) === x+constant

@test xy+constant === DiffCheck{Float64, (:y, :x)}(3.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 1.0)))
@test xy+2.0 === xy+constant
@test xy+2 === xy+constant
@test xy+Complex{Float64}(2.0) === xy+constant

@test xy+x === DiffCheck{Float64, (:y, :x)}(2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 2.0)))
@test (xy+x)+2 === DiffCheck{Float64, (:y, :x)}(4.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 2.0)))
@test xy+(x+2) === DiffCheck{Float64, (:y, :x)}(4.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 2.0)))

@test complex_z+constant === DiffCheck{Complex{Float64}, (:z, )}(3.0, NamedTuple{(:z, ), NTuple{1, Complex{Float64}}}((1.0, )))
@test complex_z+2.0 === complex_z+constant
@test complex_z+2 === complex_z+constant
@test complex_z+Complex{Float64}(2.0) === complex_z+constant

@test complex_zw+constant === DiffCheck{Complex{Float64}, (:w,:z)}(3.0, NamedTuple{(:w, :z), NTuple{2, Complex{Float64}}}((1.0, 1.0)))
@test complex_zw+2.0 === complex_zw+constant
@test complex_zw+2 === complex_zw+constant
@test complex_zw+Complex{Float64}(2.0) === complex_zw+constant
@test complex_zw+x === DiffCheck{Complex{Float64}, (:w, :z, :x)}(2.0, NamedTuple{(:w, :z, :x), NTuple{3, Complex{Float64}}}((1.0, 1.0, 1.0+0*im)))

### Difference
### Sum
@test x-constant === DiffCheck{Float64, (:x, )}(-1.0, NamedTuple{(:x, ), NTuple{1, Float64}}((1.0, )))
@test x-2.0 === x-constant
@test x-2 === x-constant
@test x-Complex{Float64}(2.0) === x-constant

@test xy-constant === DiffCheck{Float64, (:y, :x)}(-1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 1.0)))
@test xy-2.0 === xy-constant
@test xy-2 === xy-constant
@test xy-Complex{Float64}(2.0) === xy-constant

@test xy-x === DiffCheck{Float64, (:y, :x)}(0.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 0.0)))
@test (xy-x)-2 === DiffCheck{Float64, (:y, :x)}(-2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 0.0)))
@test xy-(x-2) === (xy-x)+2 

@test complex_z-constant === DiffCheck{Complex{Float64}, (:z, )}(-1.0, NamedTuple{(:z, ), NTuple{1, Complex{Float64}}}((1.0, )))
@test complex_z-2.0 === complex_z-constant
@test complex_z-2 === complex_z-constant
@test complex_z-Complex{Float64}(2.0) === complex_z-constant

@test complex_zw-constant === DiffCheck{Complex{Float64}, (:w,:z)}(-1.0, NamedTuple{(:w, :z), NTuple{2, Complex{Float64}}}((1.0, 1.0)))
@test complex_zw-2.0 === complex_zw-constant
@test complex_zw-2 === complex_zw-constant
@test complex_zw-Complex{Float64}(2.0) === complex_zw-constant
@test complex_zw-x === DiffCheck{Complex{Float64}, (:w, :z, :x)}(0.0, NamedTuple{(:w, :z, :x), NTuple{3, Complex{Float64}}}((1.0, 1.0, -1.0+0*im)))
@test x-complex_zw === DiffCheck{Complex{Float64}, (:w, :z, :x)}(0.0-0.0*im, NamedTuple{(:w, :z, :x), NTuple{3, Complex{Float64}}}((-1.0-0*im, -1.0-0*im, +1.0+0*im)))


### Multiplication
@test x*constant === DiffCheck{Float64, (:x, )}(2.0, NamedTuple{(:x, ), NTuple{1, Float64}}((2.0, )))
@test x*2.0 === x*constant
@test x*2 === x*constant
@test x*Complex{Float64}(2.0) === x*constant

@test xy*constant === DiffCheck{Float64, (:y, :x)}(2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((2.0, 2.0)))
@test xy*2.0 === xy*constant
@test xy*2 === xy*constant
@test xy*Complex{Float64}(2.0) === xy*constant

@test xy*x === DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 2.0)))
@test (xy*x)*2 === DiffCheck{Float64, (:y, :x)}(2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((2.0, 4.0)))
@test xy*(x*2) === DiffCheck{Float64, (:y, :x)}(2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((2.0, 4.0)))

@test x*pi === DiffCheck{Float64, (:x, )}(pi, NamedTuple{(:x, ), NTuple{1, Float64}}((pi, )))

### Division

### Multiplication
@test x/constant === DiffCheck{Float64, (:x, )}(0.5, NamedTuple{(:x, ), NTuple{1, Float64}}((0.5, )))
@test x/2.0 === x/constant
@test x/2 === x/constant
@test x/Complex{Float64}(2.0) === x/constant

@test constant/x === DiffCheck{Float64, (:x, )}(2.0, NamedTuple{(:x, ), NTuple{1, Float64}}((-2.0, )))
@test 2.0/x === constant/x
@test 2/x === constant/x
@test Complex{Float64}(2.0)/x === constant/x

@test xy/constant === DiffCheck{Float64, (:y, :x)}(0.5, NamedTuple{(:y, :x), NTuple{2, Float64}}((0.5, 0.5)))
@test xy/2.0 === xy/constant
@test xy/2 === xy/constant
@test xy/Complex{Float64}(2.0) === xy/constant

@test constant/xy === DiffCheck{Float64, (:y, :x)}(2.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((-2.0, -2.0)))
@test 2/xy === constant/xy

@test xy/x === DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 0.0)))
@test (complex_z*x)/x === DiffCheck{Complex{Float64}, (:z, :x)}(1.0, NamedTuple{(:z, :x), NTuple{2, Complex{Float64}}}((1.0, 0.0)))
@test (2+im)*complex_z == DiffCheck{Complex{Float64}, (:z,)}(2+im, NamedTuple{(:z, ), NTuple{1, Complex{Float64}}}((2+im, )))

end