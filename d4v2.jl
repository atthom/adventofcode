using CSV, DataFrames
using DelimitedFiles
using ImageFiltering
using Chain

function kernel(indices, buf)
    return mapreduce(ind -> buf[ind] == [88, 77, 65, 83], +, indices)
end

function day4()
    asc, desc, static = 4:7, 4:-1:1, fill(4, 4)
    partial_indices = Iterators.product((asc, desc, static), (asc, desc, static))
    partial_indices = Iterators.take(partial_indices, 8)
    indices = [CartesianIndex.(zip(x, y)) for (x, y) in partial_indices]

    @chain "data/input4.txt" begin
        readlines
        map(collect, _)
        hcat(_...) 
        Int.(_)
        mapwindow(buf -> kernel(indices, buf), _, (7,7), border=Fill(zero(eltype(_))))
        sum
    end
end