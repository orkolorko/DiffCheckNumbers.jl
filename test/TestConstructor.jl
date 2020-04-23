module TestConstructor

using Test
using DiffCheckNumbers

constant = DiffCheck{Float64, ()}(1.0, NamedTuple{(), NTuple{0, Float64}}(( )))
x = DiffCheck{Float64, (:x, )}(1.0, NamedTuple{(:x, ), NTuple{1, Float64}}((1.0, )))
xy = DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 1.0)))
z = DiffCheck{Float64, (:z, )}(1.0, NamedTuple{(:z, ), NTuple{1, Float64}}((1.0, )))


#tests DiffCheck{T}(x::T) where T<:ReComp = DiffCheck{T, ()}(T(x), NamedTuple{(), NTuple{0,T}}(()))
@test DiffCheck(1.0) === constant
#tests DiffCheck(x::T, y::Symbol) where {T<:ReComp} = DiffCheck{T, (y, )}(x, NamedTuple{(y, ), NTuple{1, T}}((1,)))
@test DiffCheck(1.0, :x) === x
#tests DiffCheck(x::T, y::Array{Symbol}) where {T<:ReComp}
@test DiffCheck(1.0, [:y, :x]) === xy
# please be careful with the order of the symbols when comparing!!!
complex_z = DiffCheck(Complex{Float64}(1.0), :z)
complex_w = DiffCheck{Complex{Float64}}(0.0, :w)
complex_zw = DiffCheck(1.0+im*0, [:z, :w])
complex_zw2 = DiffCheck{Complex{Float64}}(1.0, [:z, :w])
### 

@test complex_z === DiffCheck{Complex{Float64}, (:z, )}(1.0, NamedTuple{(:z, ), NTuple{1, Complex{Float64}}}((1.0, )))
@test complex_w === DiffCheck{Complex{Float64}, (:w, )}(0.0, NamedTuple{(:w, ), NTuple{1, Complex{Float64}}}((1.0, )))
@test complex_zw === DiffCheck{Complex{Float64}, (:w, :z)}(1.0, StaticTuple{Complex{Float64},(:w, :z),2}((1.0, 1.0)))
@test complex_zw2 === DiffCheck{Complex{Float64}, (:w, :z)}(1.0, StaticTuple{Complex{Float64},(:w, :z),2}((1.0, 1.0)))

end