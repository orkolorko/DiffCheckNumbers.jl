module DiffCheckNumbers

using SpecialFunctions
import NaNMath
import Calculus


include("Constructor.jl")
include("ConversionPromotion.jl")
include("Helper.jl")
include("Arithmetic.jl")


export DiffCheck, value, derivatives



end # module
