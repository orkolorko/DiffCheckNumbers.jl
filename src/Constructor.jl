const ReComp = Union{Real,Complex}
const StaticTuple{T,S,N} = NamedTuple{S, NTuple{N,T}}


# Thanks simeonshaub on https://discourse.julialang.org/t/namedtuples-with-constant-type/37977/2
struct DiffCheck{T<:ReComp, S, N} <: Number
    value::T
    der::StaticTuple{T,S,N} # maybe not the fastest structure
    
    #function DiffCheck{T, S}(x::T, der::StaticTuple{T,S,N}) where {T<:ReComp, S, N}
    #    val_tuple = StaticTuple{T,S,N}(values(der))
    #    return new{T,S,N}(T(x), val_tuple)
    #end

    function DiffCheck{T₁, S}(x::T₂, der::StaticTuple{T₃, S, N}) where {T₁<:ReComp, T₂,T₃<:Number, S, N}
        val_tuple = StaticTuple{T₁, S, N}(values(der))
        return new{T₁,S,N}(T₁(x), val_tuple)
    end
end

DiffCheck(x::T) where {T<:ReComp} = DiffCheck{T, ()}(x, StaticTuple{T, (), 0}(()))
DiffCheck{T₁}(x::T₂) where {T₁<:ReComp, T₂<:Number} = DiffCheck{T₁, ()}(T₁(x), StaticTuple{T₁, (), 0}(()))
DiffCheck(x::T, y::Symbol) where {T<:ReComp} = DiffCheck{T, (y, )}(x, StaticTuple{T, (y, ), 1}((T(1),)))
DiffCheck{T₁}(x::T₂, y::Symbol) where {T₁<:ReComp, T₂<:Number} = DiffCheck{T₁, (y, )}(T₁(x), StaticTuple{T₁, (y, ), 1}((T₁(1),)))

# not possible to be generated, since y is only known at runtime
function DiffCheck(x::T, y::Array{Symbol}) where {T<:ReComp} 
    Z = Tuple(Set(y))
    N = length(Z)
    return DiffCheck{T, Z}(x, StaticTuple{T, Z, N}(Tuple(ones(T, N))))
end

DiffCheck{T₁}(x::T₂, y::Array{Symbol}) where {T₁<:ReComp, T₂<:Number} = DiffCheck(T₁(x), y)

DiffCheck{T}(x::DiffCheck{R, S, N}) where {R, T<:ReComp, S, N} = Base.convert(DiffCheck{T, S, N}, x)
