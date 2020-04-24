module DiffCheckNumbers

using SpecialFunctions
import NaNMath
import Calculus


include("Constructor.jl")
include("ConversionPromotion.jl")
include("Helper.jl")
include("Arithmetic.jl")
include("Calculus.jl")

export DiffCheck, value, derivatives, StaticTuple



end # module
