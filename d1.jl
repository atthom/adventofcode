using CSV, DataFrames

function calculate_distance(left, right)
    if length(left) != length(right)
        error("Lists must have the same length.")
    end
    sorted_left = sort(left)
    sorted_right = sort(right)
    return sum(abs(l - r) for (l, r) in zip(sorted_left, sorted_right))
end

function day1()
    df = CSV.read("data/input.txt", DataFrame, delim="   ", header=["col1", "col2"])

    left_str = df[!, :col1]
    right_str = df[!, :col2]
    
    distance = calculate_distance(left_str, right_str)
    println("Total distance: ", distance)
end

function day12()
    df = CSV.read("data/input.txt", DataFrame, delim="   ", header=["col1", "col2"])
    left = df[!, :col1]
    right = df[!, :col2]
    
    distance = sum(abs(l - r) for (l, r) in zip(sort(left), sort(right)))

    distance = mapreduce(x -> abs(x[1] - x[2]), +, zip(sort(left), sort(right)))
    println("Total distance: ", distance)
end