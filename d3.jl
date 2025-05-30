using CSV, DataFrames

function day3()

    # Example usage
    sol = @chain "data/input3.txt" begin
        read(_, String)
        eachmatch(r"mul\((\d+),(\d+)\)", _)
        map(x -> parse.(Int, x.captures), _)
        mapreduce(x -> x[1] * x[2], +, _)
    end
    println(result)
    
end
