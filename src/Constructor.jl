const ReComp = Union{Real,Complex}

# Thanks simeonshaub on https://discourse.julialang.org/t/namedtuples-with-constant-type/37977/2
struct DiffCheck{T<:ReComp, S, N} <: Number
    value::T
    der::NamedTuple{S, NTuple{N,T}} # maybe not the fastest structure
    
    function DiffCheck{T, S}(x::T, der::NamedTuple{S, NTuple{N,T}}) where {T<:ReComp, S, N}
        return new{T,S,N}(T(x), NamedTuple{S, NTuple{N,T}}(T.(values(der))))
    end
end

DiffCheck(x::T) where {T<:ReComp} = DiffCheck{T, ()}(x, NamedTuple{(), NTuple{0,T}}(()))

# not possible to be generated, since y is only known at runtime
function DiffCheck(x::T, y::Array{Symbol}) where {T<:ReComp} 
    Z = Tuple(Set(y))
    N = length(Z)
    return DiffCheck{T, Z}(x, NamedTuple{Z, NTuple{N, T}}(Tuple(ones(T, N))))
end

DiffCheck(x::T, y::Symbol) where {T<:ReComp} = DiffCheck{T, (y, )}(x, NamedTuple{(y, ), NTuple{1, T}}((1,)))
DiffCheck{T}(x::T) where T<:ReComp = DiffCheck{T, ()}(T(x), NamedTuple{(), NTuple{0,T}}(()))
DiffCheck{T}(x::DiffCheck{R,S,N}) where {R, T<:ReComp, S, N} = Base.convert(DiffCheck{T, S, N}, x)
