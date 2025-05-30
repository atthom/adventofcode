using CSV, DataFrames
using DelimitedFiles
using ImageFiltering
using Chain


function kernel_unpack(buf, TARGET, INDICES)
    count = 0
    for ind in INDICES
        match = true
        for i in 1:4
            @inbounds match &= buf[ind[i]] == TARGET[i]
        end
        count += match
    end
    return count
end

function parse(path)
    open(path) do io
        return reduce(hcat, [UInt8.(codeunits(line)) for line in eachline(io)])
    end
end

function day4()
    TARGET = Int[88, 77, 65, 83]
    asc, desc, static = 4:7, 4:-1:1, fill(4, 4)
    partial_indices = Iterators.take(Iterators.product((asc, desc, static), (asc, desc, static)), 8)
    INDICES = [CartesianIndex.(zip(x, y)) for (x, y) in partial_indices]

    @chain "data/input4.txt" begin
        parse
        mapwindow(buf -> kernel_unpack(buf, TARGET, INDICES), _, (7,7), border=Fill(zero(eltype(_))))
        sum
    end
end