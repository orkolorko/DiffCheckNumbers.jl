#changing the field
Base.convert(::Type{DiffCheck{T, S, N}}, z::DiffCheck{T, S, N}) where {T<:ReComp, S, N} = z
Base.convert(::Type{DiffCheck{T, S, N}}, z::DiffCheck{R, S, N}) where {T, R<:ReComp, S, N} = 
	DiffCheck{T, S}(convert(T, value(z)), NamedTuple{S, NTuple{N,T}}(convert.(T, values(derivatives(z)))))

#conversion for scalars
Base.convert(::Type{DiffCheck{T, (), 0}}, x::T) where {T<:ReComp} = DiffCheck{T}(x)
Base.convert(::Type{DiffCheck{T, S, N}}, x::T) where {T<:ReComp, S, N} = convert(DiffCheck{T, S, N}, DiffCheck{T}(x))

Base.convert(::Type{DiffCheck}, x::T) where {T<:ReComp} = Base.convert(DiffCheck{T, (), 0}, x)
Base.convert(::Type{T}, z::DiffCheck) where {T<:ReComp} = (isempty(derivatives(z)) ? convert(T, value(z)) : throw(InexactError()))

#This convert is only used to convert upward, i.e., S₂ ⊂ S₁ 
@generated function Base.convert(::Type{DiffCheck{T₁, S₁, N₁}}, x::DiffCheck{T₂, S₂, N₂}) where {T₁, T₂<:ReComp, S₁, S₂, N₁, N₂}
    if issubset(Set(S₂), Set(S₁))
        str = "("
        for z in S₁
            if z in S₂ # Since Z is the union both cannot be false 
               str*="$T₁(x.der[:$z]), "     
            else 
               str*="zero(T₁) ,"
            end
        end
        str*= ")"
        expr = Meta.parse(str)
        return :(DiffCheck{$T₁, $S₁}($T₁(value(x)), NamedTuple{$S₁, NTuple{$N₁, $T₁}}($expr)))
    else
        return :(throw(InexactError())) #check
    end
end

# Promote rule for 
Base.promote_rule(::Type{DiffCheck{T, S, N}}, ::Type{DiffCheck{R, S, N}}) where {T<:ReComp,R<:ReComp, S, N} = DiffCheck{promote_type(T, R), S, N}

# Unsure wheter to use this
#@generated function Base.promote_rule(::Type{DiffCheck{T₁, S₁, N₁}}, ::Type{DiffCheck{T₂, S₂, N₂}}) where {T₁, T₂<:ReComp, S₁, S₂, N₁, N₂}
#    Z = Tuple(union(Set(S₁), Set(S₂)))
#    N = length(Z)
#    return :(DiffCheck{promote_type($T₁, $T₂), $Z, $N})
#end

Base.promote_rule(::Type{DiffCheck{T, S, N}}, ::Type{R}) where {T, R<:ReComp, S, N} = DiffCheck{promote_type(T, R), S, N}
Base.promote_rule(::Type{DiffCheck{T, S, N}}, ::Type{T}) where {T<:ReComp, S, N} = DiffCheck{T, S, N}
Base.promote_rule(::Type{DiffCheck{T, (), 0}}, ::Type{T}) where {T<:ReComp, S, N} = DiffCheck{T, (), 0}

Base.widen(::Type{DiffCheck{T, S, N}}) where {T, S, N} = DiffCheck{widen(T),S, N}