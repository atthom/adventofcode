using DelimitedFiles
using Chain

all_good(rules, li, current) = all(!in(e, li) for e in rules[current])

all_good(rules, li) = all(all_good(rules, li[1:idx_pivot-1], li[idx_pivot]) for idx_pivot in length(li):-1:1)

function day5()
    rules = readdlm("./data/input5.1.txt", '|', Int)
    dict_rules = Dict(e => Int[] for e in unique(rules))
    [push!(dict_rules[x], y) for (x, y) in zip(rules[:, 1], rules[:, 2])]

    return @chain "./data/input5.2.txt" begin
        readlines
        split.(_, ',')
        map(row -> parse.(Int, row), _)
        filter(li -> all_good(dict_rules, li), _)
        map(li -> li[div(length(li), 2) + 1], _)
        sum
    end
    # 6260
end


function count_guard_positions(filename)
    # Read the map from the file
    map = readlines(filename)
    rows = length(map)
    cols = length(map[1])
    
    # Parse the initial position and direction of the guard
    directions = Dict('^' => (-1, 0), '>' => (0, 1), 'v' => (1, 0), '<' => (0, -1))
    rotation = Dict('^' => '>', '>' => 'v', 'v' => '<', '<' => '^')
    initial_pos = (0, 0)
    facing = ' '
    
    for r in 1:rows
        for c in 1:cols
            if map[r][c] in keys(directions)
                initial_pos = (r, c)
                facing = map[r][c]
                break
            end
        end
    end
    
    # Guard's current state
    pos = initial_pos
    visited = Set([pos])
    
    # Check if the guard is within bounds
    function is_within_bounds(pos)
        r, c = pos
        r > 0 && r <= rows && c > 0 && c <= cols
    end
    
    # Simulate the patrol
    while is_within_bounds(pos)
        # Compute the position directly in front
        dr, dc = directions[facing]
        #println(pos, dr, dc)
        next_pos = (pos[1] + dr, pos[2] + dc)
        
        if is_within_bounds(next_pos) && map[next_pos[1]][next_pos[2]] == '.'
            # Move forward
            pos = next_pos
            push!(visited, pos)
        else
            # Turn right
            facing = rotation[facing]
        end
    end
    
    # Return the count of distinct positions visited
    return length(visited)
end


function count_guard_positions()
    directions = Dict('^' => (-1, 0), '>' => (0, 1), 'v' => (1, 0), '<' => (0, -1))
    rotation = Dict('^' => '>', '>' => 'v', 'v' => '<', '<' => '^')
end

function update(dataset, position, direction, all_direction)
    if dataset[position+direction] == '#'
        direction, _ = iterate(all_direction)
    else
        dataset[position] = 'X'
        position += direction
    end
    return position, direction
end

function day6()
    # Call the function with the filename
    dataset = @chain "./data/input6.txt" begin
        readlines
        map(collect, _)
        hcat(_...)
    end

    current_position = findfirst(x-> x == '^', dataset)

    all_direction = @chain begin
        [CartesianIndex(0, -1), CartesianIndex(1, 0), 
         CartesianIndex(0, 1), CartesianIndex(-1, 0)]
        Iterators.cycle
        Iterators.Stateful
    end
    current_direction, _ = iterate(all_direction)

    while checkbounds(Bool, dataset, current_position + current_direction)
        current_position, current_direction = update(dataset, current_position, current_direction, iter_direction)
    end

    sol = @chain dataset begin
        findall(x-> x=='X', _)
        length
        _+1
        println
    end

    # 4778
end


using Combinatorics


# part 2
concat_numbers(a, b) = @chain begin
    digits(b), digits(a)
    vcat(_...)
    foldr((a, b) -> muladd(10, b, a), _, init=0)
end

count_op(op, left) = 0
count_op(op, expr::Expr) = ifelse(expr.args[1] == op, 1, 0) + count_op(op, expr.args[2])

function is_expected(expected_return, values, op)
    #sum_v, prod_v = sum(values), prod(values)
    #if (sum_v == expected_return) || (prod_v == expected_return)
    #    return true
    #end
    #if (sum_v > expected_return) || (prod_v < expected_return)
    #    return false
    #end
    
    all_expr = @chain begin
        values
        length(_) - 1
        repeat([op], _)
        Iterators.product(_...)
        vcat(_...)
        zip.(_, repeat([values[2:end]], length(_)))
        #foldl.((x, y) -> Expr(:call, Symbol(y[1]), x, y[2]), _, init=values[1])
        foldl.((x, y) -> ifelse(x < expected_return, y[1](x, y[2]), y), _, init=values[1])
        #sort(_, by = x-> count_op(:*, x))
    end

end



function binary_search_faulty(all_expr, expected_return)
    low, mid, high = 0, 0, length(all_expr)

    while low <= high
        mid = low + div(high - low, 2)

        val = eval(all_expr[mid])
        println(mid, " ", val)

        if val == expected_return
            return true, mid
        elseif val > expected_return
            high = mid - 1
        else
            low = mid + 1
        end
    end

    return false, mid
end


function binary_search_faulty(all_expr, expected_return)
    next = div(length(all_expr), 2)
    val = eval(all_expr[next]) 

    while val != expected_return
        if val > expected_return
            next = div(next, 2) 
        else
            next = next + div() 
        end
    end
end


function day7()
    # Call the function with the filename
    results, list_values = @chain "./data/input7.txt" begin
        readdlm
        _[:, 1], _[:, 2:end]
    end

    list_values = @chain list_values begin
        eachrow
        filter.(x -> x != "", _)
    end

    op = [+, *] # part1
    #op = [:+, :*, :concat_numbers] # part2

    sol = @chain results begin
        parse.(Int, [e[1:end-1] for e in _])
        zip(_, list_values)
        collect
        filter(x -> is_expected(x[1], x[2], op), _)
        map(x -> x[1], _)
        sum
    end
    # 14711933466277
end


