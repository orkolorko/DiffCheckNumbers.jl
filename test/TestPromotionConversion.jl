module TestPromotionConversion

using Test
using DiffCheckNumbers

constant = DiffCheck{Float64, ()}(1.0, NamedTuple{(), NTuple{0, Float64}}(( )))
x = DiffCheck{Float64, (:x, )}(1.0, NamedTuple{(:x, ), NTuple{1, Float64}}((1.0, )))
xy = DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((1.0, 1.0)))

z = DiffCheck(Complex{Float64}(1.0), :z)
zw = DiffCheck(1.0+im*0, [:z, :w])

#########
#Conversions
#########

# Testing Base.convert(::Type{DiffCheck{T, S, N}}, z::DiffCheck{T, S, N})
@test convert(DiffCheck{Float64, (), 0}, constant) === constant
@test convert(DiffCheck{Float64, (:x, ), 1}, x) === x
@test convert(DiffCheck{Float64, (:y, :x), 2}, xy) === xy
@test convert(DiffCheck{Complex{Float64}, (:z, ), 1}, z) === z
@test convert(DiffCheck{Complex{Float64}, (:w, :z), 2}, zw) === zw

# Testing Base.convert(::Type{DiffCheck{T, S, N}}, z::DiffCheck{R, S, N})
@test convert(DiffCheck{Complex{Float64}, (), 0}, constant) === DiffCheck{Complex{Float64}, ()}(value(constant), StaticTuple{Complex{Float64}, (), 0}(()))
@test convert(DiffCheck{Complex{Float64}, (:x, ), 1}, x) === DiffCheck{Complex{Float64}, (:x, )}(value(constant), StaticTuple{Complex{Float64}, (:x, ), 1}((1, )))
@test convert(DiffCheck{Complex{Float64}, (:y, :x), 2}, xy) === DiffCheck{Complex{Float64}, (:y, :x)}(value(constant), StaticTuple{Complex{Float64}, (:y, :x), 2}((1, 1)))

# convert a complex with no Imaginary part to Real 
@test convert(DiffCheck{Float64, (:z, ), 1}, z) === DiffCheck{Float64, (:z, )}(1.0, StaticTuple{Complex{Float64}, (:z, ), 1}((1, )))
# throws the right exception when it is not possible
@test try 
		convert(DiffCheck{Float64, (:z, ), 1}, DiffCheck(1.0+im, :z)) 
	  catch e 
		isa(e, InexactError) 
	  end


# Test convert(::Type{DiffCheck{T, (), 0}}, x::T)
@test convert(DiffCheck{Float64, (), 0}, 1.0) === constant

# Test convert(::Type{DiffCheck{T, S, N}}, x::T) 
@test convert(DiffCheck{Float64, (:y, :x), 2}, 1.0) === DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((0.0, 0.0)))

# Test convert(::Type{T}, z::DiffCheck), converts only constants
@test convert(Float64, constant) === 1.0
@test try 
		convert(Float64, x)
	  catch e 
		isa(e, InexactError) 
	  end	  

# Test convert(::Type{DiffCheck{T₁, S₁, N₁}}, x::DiffCheck{T₂, S₂, N₂}), only works upwards
@test convert(DiffCheck{Float64, (:y, :x), 2}, x) === DiffCheck{Float64, (:y, :x)}(1.0, NamedTuple{(:y, :x), NTuple{2, Float64}}((0.0, 1.0)))

@test try 
		convert(DiffCheck{Float64, (:x, ), 1}, xy)
	  catch e 
		isa(e, InexactError) 
	  end	  

########
#Promotions
########

@test promote_type(DiffCheck{Float64, (:y, :x), 2}, DiffCheck{Complex{Float64}, (:y, :x), 2}) === DiffCheck{Complex{Float64}, (:y, :x), 2}
@test promote_type(DiffCheck{Float64, (:y, :x), 2}, Complex{Float64}) === DiffCheck{Complex{Float64}, (:y, :x), 2}
@test promote_type(DiffCheck{Float64, (:y, :x), 2}, Float64) === DiffCheck{Float64, (:y, :x), 2}
@test promote_type(DiffCheck{Float64, (), 0}, Float64) === DiffCheck{Float64, (), 0}
@test widen(DiffCheck{Float64, (:y, :x), 2}) === DiffCheck{BigFloat, (:y, :x), 2}




end