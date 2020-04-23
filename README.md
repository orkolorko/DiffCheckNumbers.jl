# DiffCheckNumbers.jl
Sparse Differentiation Arithmetics for Julia

This library implements the ideas in 

[Slaven Peles and Stefan Klus, **Sparse Automatic Differentiation for Large-Scale Computations Using Abstract Elementary Algebra**](https://arxiv.org/abs/1505.00838)

by using some of Julia metaprogramming functionalities to force the computation of the dependency at compile time. This is an idea of Maurizio Monge, that had implemented a code generator for AD in C++ for one of his works and spoke to me about an alternative approach with types that is easily expressed in Julia.

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
f(x, y, z) 
```
which returns
```
3-element Array{DiffCheck{Float64,S,N} where N where S,1}:
 DiffCheck{Float64,(:y, :x),2}(2.0, (y = 1.0, x = 1.0))
 DiffCheck{Float64,(:z, :x),2}(3.0, (z = 2.0, x = 1.0))
            DiffCheck{Float64,(:z,),1}(1.0, (z = 1.0,))
```
where we have both the partial derivatives and the dependence.
What is interesting in my approach is that we have now a compiled version of f which keeps track of the dependence of the variables, so, any new computation of the Jacobian is faster.
