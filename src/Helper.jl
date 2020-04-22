# helper functions
value(z::DiffCheck) = z.value
value(x::Number) = x

derivatives(z::DiffCheck) = z.der
derivatives(x::Number) = Set{Symbol}()