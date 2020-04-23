## Arithmetics

Base.:+(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:ReComp} = DiffCheck{T, S}(value(x) + T(y), derivatives(x))
Base.:+(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:ReComp} = Base.:+(x, y)

@generated function Base.:+(x::DiffCheck{T₁, S, N}, y::DiffCheck{T₂, Q, M}) where {T₁, T₂<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="x.der[:$z]+y.der[:$z], "     
        elseif z in S
           str*="x.der[:$z],"
        else 
           str*="y.der[:$z],"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{promote_type($T₁,$T₂), $Z}(value(x) + value(y), StaticTuple{promote_type($T₁,$T₂),$Z, $N}($expr)))
end

Base.:-(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:ReComp} = DiffCheck{T, S}(value(x) - T(y), derivatives(x))
Base.:-(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:ReComp} = 
    DiffCheck{T, S}(T(y) - value(x), StaticTuple{T, S, N}(-1 .* values(derivatives(x))))

@generated function Base.:-(x::DiffCheck{T₁, S, N}, y::DiffCheck{T₂, Q, M}) where {T₁, T₂<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="x.der[:$z]-y.der[:$z], "     
        elseif z in S
           str*="x.der[:$z],"
        else 
           str*="-y.der[:$z],"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{promote_type($T₁,$T₂), $Z}(value(x) - value(y), StaticTuple{promote_type($T₁,$T₂),$Z, $N}($expr)))
end

Base.:*(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:ReComp} = 
    DiffCheck{T, S}(y*value(x), StaticTuple{T, S, N}(y .* values(derivatives(x))))

Base.:*(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:ReComp} = x*y


@generated function Base.:*(x::DiffCheck{T₁, S, N}, y::DiffCheck{T₂, Q, M}) where {T₁, T₂<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="x.value*y.der[:$z]+x.der[:$z]*y.value, "     
        elseif z in S
           str*="y.value*x.der[:$z],"
        else 
           str*="x.value*y.der[:$z],"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{promote_type($T₁,$T₂), $Z}(value(x) * value(y), StaticTuple{promote_type($T₁,$T₂),$Z, $N}($expr)))
end

Base.:/(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:ReComp} = 
    DiffCheck{T, S}(value(x)/y, StaticTuple{T, S, N}(values(derivatives(x))./ y))

Base.:/(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:ReComp} = DiffCheck{T, S}(y/value(x), StaticTuple{T, S, N}( -y/value(x) .* (values(derivatives(x)) ./ value(x))))

@generated function Base.:/(x::DiffCheck{T₁, S, N}, y::DiffCheck{T₂, Q, M}) where {T₁, T₂<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="-1*(x.value/y.value)*y.der[:$z]/y.value+x.der[:$z]*(x.value/y.value), "     
        elseif z in S
           str*="x.der[:$z]/y.value,"
        else 
           str*="-1*(x.value/y.value)*y.der[:$z]/y.value,"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{promote_type($T₁,$T₂), $Z}(value(x) / value(y), StaticTuple{promote_type($T₁,$T₂),$Z, $N}($expr)))
end