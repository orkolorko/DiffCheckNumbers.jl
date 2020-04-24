using SpecialFunctions
import NaNMath
import Calculus


# This implementation is essentially identical to the implementation in DualNumbers.jl


# force use of NaNMath functions in derivative calculations
function to_nanmath(x::Expr)
    if x.head == :call
        funsym = Expr(:.,:NaNMath,Base.Meta.quot(x.args[1]))
        return Expr(:call,funsym,[to_nanmath(z) for z in x.args[2:end]]...)
    else
        return Expr(:call,[to_nanmath(z) for z in x.args]...)
    end
end
to_nanmath(x) = x

for (funsym, exp) in Calculus.symbolic_derivatives_1arg()
    funsym == :exp && continue
    funsym == :abs2 && continue
    funsym == :inv && continue
    
    if isdefined(SpecialFunctions, funsym)
        @eval function SpecialFunctions.$(funsym)(z::DiffCheck{T,S,N}) where {T, S, N}
            x = value(z)
            xp = values(derivatives(z))
            DiffCheck{T, S}($(funsym)(x), StaticTuple{T,S,N}($exp .* xp))
        end
    elseif isdefined(Base, funsym)
        @eval function Base.$(funsym)(z::DiffCheck{T,S,N}) where {T, S, N}
            x = value(z)
            xp = values(derivatives(z))
            DiffCheck{T, S}($(funsym)(x), StaticTuple{T,S,N}($exp .* xp))
        end
    end
    # extend corresponding NaNMath methods
    if funsym in (:sin, :cos, :tan, :asin, :acos, :acosh, :atanh, :log, :log2, :log10,
          :lgamma, :log1p)
        funsym = Expr(:.,:NaNMath,Base.Meta.quot(funsym))
        @eval function $(funsym)(z::DiffCheck{T,S,N}) where {T, S, N}
            x = value(z)
            xp = values(derivatives(z))
            DiffCheck{T, S}($(funsym)(x), StaticTuple{T,S,N}($(to_nanmath(exp)) .*xp))
        end
    end
end

# only need to compute exp/cis once
Base.exp(z::DiffCheck{T,S,N}) where{T,S,N} = (expval = exp(value(z)); DiffCheck{T, S}(expval, StaticTuple{T,S,N}(expval .* values(derivatives(z)))))
Base.cis(z::DiffCheck{T,S,N}) where{T,S,N}= (cisval = cis(value(z)); DiffCheck{T, S}(cisval, StaticTuple{T,S,N}( (cisval*im) .* values(derivatives(z)))))
Base.exp10(z::DiffCheck{T,S,N}) where{T,S,N} = (y = exp10(value(x)); DiffCheck{T, S}(cisval, StaticTuple{T,S,N}( (y*log(10)) .* values(derivatives(z)))))

## TODO: should be generated in Calculus
Base.sinpi(z::DiffCheck{T,S,N}) where{T,S,N} = DiffCheck{T, S}(sinpi(value(z)),StaticTuple{T,S,N}(values(derivatives(z)).*(cospi(value(z))*π)))
Base.cospi(z::DiffCheck{T,S,N}) where{T,S,N} = DiffCheck{T, S}(cospi(value(z)),StaticTuple{T,S,N}(values(derivatives(z)).*(sinpi(value(z))*π)))

Base.checkindex(::Type{Bool}, inds::AbstractUnitRange, i::DiffCheck) = checkindex(Bool, inds, value(i))