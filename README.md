# DiffCheckNumbers.jl
Sparse Differentiation Arithmetics for Julia

This library implements the ideas in 

[Slaven Peles and Stefan Klus, **Sparse Automatic Differentiation for Large-Scale Computations Using Abstract Elementary Algebra**](https://arxiv.org/abs/1505.00838)

by using some of Julia metaprogramming functionalities to force the computation of the dependency at compile time.

## Usage
The use is quite straightforward, suppose f is a function 
```julia
using DiffCheckNumbers
f(x,y,z) = [x*y+1, x+2*z, z]
```
we can now define
```julia
x = DiffCheck(1.0, :x)
y = DiffCheck(1.0, :y)
z = DiffCheck(1.0, :z)
@time f(x, y, z) 
```
which returns
```
0.343909 seconds (406.48 k allocations: 23.015 MiB, 2.32% gc time)
3-element Array{DiffCheck{Float64,S,N} where N where S,1}:
 DiffCheck{Float64,(:y, :x),2}(2.0, (y = 1.0, x = 1.0))
 DiffCheck{Float64,(:z, :x),2}(3.0, (z = 2.0, x = 1.0))
            DiffCheck{Float64,(:z,),1}(1.0, (z = 1.0,))

```
where we have both the partial derivatives and the dependence.
We can see that the first variable depends on x,y and the value of the partial derivatives, etc...

What is interesting in DiffCheckNumbers is that we have now a compiled version of f which keeps track of the dependence of the variables, so, any new computation of the Jacobian is faster.

```
x = DiffCheck(2.0, :x)
y = DiffCheck(0.0, :y)
z = DiffCheck(1.0, :z)

@time f(x,y,z)
  0.000013 seconds (13 allocations: 624 bytes)
3-element Array{DiffCheck{Float64,S,N} where N where S,1}:
 DiffCheck{Float64,(:y, :x),2}(1.0, (y = 2.0, x = 0.0))
 DiffCheck{Float64,(:z, :x),2}(4.0, (z = 2.0, x = 1.0))
            DiffCheck{Float64,(:z,),1}(1.0, (z = 1.0,))
```
Please note that the compiled f only computes the derivative when there is explicit dependence.
While on small function ForwardDiff.jacobian is faster, for "sparse" functions this approach may be faster, once the compilation time is take into account (please remark that due to the strong use of metaprogramming, this can be expensive).

For a trivial example
```
f(v) = v
w = ones(2000)
@time ForwardDiff.jacobian(f, w)
0.142886 seconds (9 allocations: 30.717 MiB, 5.65% gc time)

v = [DiffCheck(1.0, Symbol("x",i)) for i in 1:2000]
@time f(v)
0.000003 seconds (4 allocations: 160 bytes)
```

Please note that the allocation of v is expensive, though.
