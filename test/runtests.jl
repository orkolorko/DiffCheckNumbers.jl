using DiffCheckNumbers

println("Testing Constructors")

t = @elapsed include("TestConstructor.jl")

println("done (took $t seconds).")
