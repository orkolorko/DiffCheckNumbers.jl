using DiffCheckNumbers

println("Testing Constructors")

t = @elapsed include("TestConstructor.jl")

println("done (took $t seconds).")

println("Testing Promotion and Conversion")

t = @elapsed include("TestPromotionConversion.jl")

println("done (took $t seconds).")

println("Testing Arithmetic")

t = @elapsed include("TestArithmetic.jl")

println("done (took $t seconds).")
