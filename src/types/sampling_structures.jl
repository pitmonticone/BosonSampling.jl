
"""
        PartitionSamplingParameters

Type holding info on a numerical experiment simulating the probability distributions of photon counting in partitions, used for comparing two input types `T1`,`T2`.

        Fields:
                n::Int
                m::Int
                interf::Interferometer = RandHaar(m)

                T1::Type{T} where {T<:InputType} = Bosonic
                T2::Type{T} where {T<:InputType} = Distinguishable
                mode_occ_1::ModeOccupation = first_modes(n,m)
                mode_occ_2::ModeOccupation = first_modes(n,m)

                i1::Input = Input{T1}(mode_occ_1)
                i2::Input = Input{T1}(mode_occ_2)

                n_subsets::Int = 2
                part::Partition = equilibrated_partition(m, n_subsets)

                o::OutputMeasurementType = PartitionCountsAll(part)
                ev1::Event = Event(i1,o,interf)
                ev2::Event = Event(i2,o,interf)
"""
@with_kw mutable struct PartitionSamplingParameters

    n::Int
    m::Int = m
    interf::Interferometer = RandHaar(m)

    T1::Type{T} where {T<:InputType} = Bosonic
    T2::Type{T} where {T<:InputType} = Distinguishable
    mode_occ_1::ModeOccupation = first_modes(n,m)
    mode_occ_2::ModeOccupation = first_modes(n,m)

    i1::Input = Input{T1}(mode_occ_1)
    i2::Input = Input{T1}(mode_occ_2)

    n_subsets::Int = 2
    part::Partition = equilibrated_partition(m, n_subsets)

    o::OutputMeasurementType = PartitionCountsAll(part)
    ev1::Event = Event(i1,o,interf)
    ev2::Event = Event(i2,o,interf)

end


"""
    LoopSamplingParameters(...)

Container for sampling parameters with a LoopSampler. Parameters are set by default as defined, and you can change only the ones needed, for instance to sample `Distinguishable` particles instead, just do

    LoopSamplingParameters(input_type = Distinguishable)

and to change the number of photons with it

    LoopSamplingParameters(n = 10 ,input_type = Distinguishable)

To be used with [`get_sample_loop`](@ref).

By default it applies a random phase at each optical line.
"""
@with_kw mutable struct LoopSamplingParameters

    n::Int = 4
    m::Int = n
    x::Union{Real, Nothing} = nothing
    input_type::Type{T} where {T<:InputType} = Bosonic
    i::Input = begin
        if input_type in [Bosonic, Distinguishable]
            i =  Input{input_type}(first_modes(n,m))
        elseif input_type == OneParameterInterpolation
            if x == nothing
                error("x not given")
            else
                i = Input{input_type}(first_modes(n,m), x)
            end
        end
    end


    η::Union{T, Vector{T}}  where {T<:Real} = 1/sqrt(2) .* ones(m-1)
    η_loss_bs::Union{Nothing, T, Vector{T}}   where {T<:Real} = 1 .* ones(m-1)
    η_loss_lines::Union{Nothing, T, Vector{T}}   where {T<:Real} = 1 .* ones(m)
    d::Union{Nothing, Real, Distribution} = Uniform(0, 2pi)
    ϕ::Union{Nothing, T, Vector{T}}   where {T<:Real} = rand(d, m)

    p_dark::Real = 0.0
    p_no_count::Real = 0.0

end
