## Arithmetics

Base.:+(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:Number} = DiffCheck{T, S, N}(value(x) + y, derivatives(x))
Base.:+(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:Number} = Base.:+(x, y)

@generated function Base.:+(x::DiffCheck{T, S, N}, y::DiffCheck{T, Q, M}) where {T<:ReComp, S, Q, N, M}
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
    return :(DiffCheck{T, $Z, $N}(value(x) + value(y), NamedTuple{$Z}($expr)))
end

Base.:-(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:Number} = DiffCheck{T, S, N}(value(x) - y, derivatives(x))
Base.:-(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:Number} = 
    DiffCheck{T, S, N}(y - value(x), NamedTuple{S, NTuple{N,T}}(-1 .* values(derivatives(x))))

@generated function Base.:-(x::DiffCheck{T, S, N}, y::DiffCheck{T, Q, M}) where {T<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="x.der[:$z]-y.der[:$z], "     
        elseif z in S
           str*="x.der[:$z],"
        else 
           str*="y.der[:$z],"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{T, $Z, $N}(value(x) - value(y), NamedTuple{$Z}($expr)))
end

Base.:*(x::DiffCheck{T, S, N}, y::U) where {T<:ReComp, S, N, U<:Number} = 
    DiffCheck{T, S, N}(y*value(x), NamedTuple{S, NTuple{N,T}}(y .* values(derivatives(x))))

Base.:*(y::U, x::DiffCheck{T, S, N}) where {T<:ReComp, S, N, U<:Number} = x*y


@generated function Base.:*(x::DiffCheck{T, S, N}, y::DiffCheck{T, Q, M}) where {T<:ReComp, S, Q, N, M}
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
    return :(DiffCheck{T, $Z, $N}(value(x) * value(y), NamedTuple{$Z}($expr)))
end

@generated function Base.:/(x::DiffCheck{T, S, N}, y::DiffCheck{T, Q, M}) where {T<:ReComp, S, Q, N, M}
   Z = Tuple(union(Set(S), Set(Q)))
   N = length(Z)
   str = "("
   for z in Z
        if (z in S && z in Q) # Since Z is the union both cannot be false 
           str*="(-1*(x.value/y.value)*y.der[:$z]/y.value+x.der[:$z]*(x.value/y.value), "     
        elseif z in S
           str*="x.der[:$z]/y.value,"
        else 
           str*="-1*(x.value/y.value)*y.der[:$z]/y.value,"
        end
    end
    str*= ")"
    expr = Meta.parse(str)
    return :(DiffCheck{T, $Z, $N}(value(x) / value(y), NamedTuple{$Z}($expr)))
end