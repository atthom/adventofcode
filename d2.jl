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


function is_safe(levels)
    n = length(levels)
    if n == 1
        return true
    end
    diffs = diff(levels)
    if any(d == 0 for d in diffs)
        return false
    end
    first_sign = sign(diffs[1])
    if all(sign(d) == first_sign for d in diffs)
        if all(1 <= abs(d) <= 3 for d in diffs)
            return true
        end
    end
    return false
end

function day2()
    # Read input reports
    #df = CSV.read("data/input2.txt", DataFrame, delim=" ", header=false)
    # Convert each report to an array of integers

    parsed_reports = [parse.(Int, split(report)) for report in readlines("data/input2.txt")]

    # Count safe reports
    safe_count = 0
    for report in parsed_reports
        if is_safe(report)
            safe_count += 1
        end
    end

    # Output the number of safe reports
    println(safe_count)
end
#main()


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

function count_xmas(word_search)
    word = "XMAS"
    rows, cols = size(word_search)
    count = 0

    directions = [
        (1, 0),  # down
        (0, 1),  # right
        (-1, 0), # up
        (0, -1), # left
        (1, 1),  # down-right diagonal
        (-1, -1),# up-left diagonal
        (1, -1), # down-left diagonal
        (-1, 1)  # up-right diagonal
    ]

    for r in 1:rows
        for c in 1:cols
            for (dr, dc) in directions
                match = true
                for i in 1:length(word)
                    nr, nc = r + (i - 1) * dr, c + (i - 1) * dc
                    if nr < 1 || nr > rows || nc < 1 || nc > cols || word_search[nr, nc] != word[i]
                        match = false
                        break
                    end
                end
                count += match
            end
        end
    end

    return count
end


function all_kernels()
    kernels = [
        pattern,                        # Right (same pattern)
        reverse(pattern),               # Left (flipped horizontally)
        transpose(pattern),              # Down (flipped vertically)
        reverse(transpose(pattern)),    # Up (flipped both horizontally and vertically)
        diag_pattern(pattern),          # Down-Right diagonal
        reverse(diag_pattern(pattern)), # Up-Left diagonal
        flipud(diag_pattern(pattern)),  # Down-Left diagonal
        reverse(flipud(diag_pattern(pattern)))  # Up-Right diagonal
    ]

end
using DelimitedFiles
using ImageFiltering
using Chain

function kernel(indices, buf)
    return mapreduce(ind -> buf[ind] == [88, 77, 65, 83], +, indices)
end


function kernel2(buf)
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

# 2458 no

