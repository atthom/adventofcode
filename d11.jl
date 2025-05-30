using Chain
using DelimitedFiles
using Caching

using Memoize
make_number(li) = foldr((a, b) -> muladd(10, b, a), li, init=0)


function update(s, nb)
    if nb == 0
        return s
    end  
    
    if s == 0
        return update(1, nb-1)
    elseif length(digits(s)) % 2 == 0
        all_digits = digits(s)
        half = div(length(all_digits), 2)

        left = make_number(all_digits[1:half])
        right = make_number(all_digits[half+1:end])

        return update(right, nb-1), update(left, nb-1)
    else 
        return update(s * 2024, nb-1)
    end
end


using LRUCache

@memoize function update(s)
    if s == 0
        return [1]
    elseif length(digits(s)) % 2 == 0
        all_digits = digits(s)
        half = div(length(all_digits), 2)

        left = all_digits[1:half]
        right = all_digits[half+1:end]

        return [make_number(right), make_number(left)]
    else 
        return [s * 2024]
    end
end

function blink(stones, n) 
    if n == 0
        return stones
    end  
    
    return @chain stones begin
        update.(_)
        vcat(_...)
        blink(_, n-1)
    end
end

function batch_blink()

    for batch in [25, 25, 25]


    end
end

input = [8069, 87014, 98, 809367, 525, 0, 9494914, 5]

[1] = blink([0], 4)
[2, 0, 2, 4] == blink([20, 24], 1) == blink([2024], 2) == blink([1], 3) == blink([0], 4)
[4, 0, 4, 8] == blink([40, 48], 1) == blink([4048], 2) == blink([2], 3)
[6, 0, 7, 2] == blink([60, 72], 1) == blink([6072], 2) == blink([3], 3)
[8, 0, 9, 6] == blink([80, 96], 1) == blink([8096], 2) == blink([4], 3)
[2, 0, 4, 8, 2, 8, 8, 0] == blink([20, 48, 28, 80], 1) == blink([2048, 2880], 2) == blink([20482880], 3) == blink([10120], 4) == blink([5], 5)
[2, 4, 5, 7, 9, 4, 5, 6] == blink([24, 57, 94, 56], 1) == blink([2457, 9456], 2) == blink([24579456], 3) == blink([12144], 4) == blink([6], 5)
[2, 8, 6, 7, 6, 0, 3, 2] == blink([28, 67, 60, 32], 1) == blink([2867, 6032], 2) == blink([28676032], 3) == blink([14168], 4) == blink([7], 5)

[3, 2, 7, 7, 2, 6, blink([8], 2)] = blink([32, 77, 26, 8], 1) == blink([3277, 2608], 2) == blink([32772608], 3) == blink([16192], 4) == blink([8], 5)
[3, 6, 8, 6, 9, 1, 8, 4] == blink([36, 86, 91, 84], 1) == blink([3686, 9184], 2) == blink([36869184], 3) == blink([18216], 4) == blink([9], 5)




@memoize function count_stones(d, nb_steps, stone_counter)
    if nb_steps == 0
        return stone_counter + 1
    elseif d > 9
        if length(digits(d)) % 2 == 0
            all_digits = digits(d)
            half = div(length(all_digits), 2)

            left = make_number(all_digits[1:half])
            right = make_number(all_digits[half+1:end])
            
            return count_stones(right, nb_steps-1) + count_stones(left, nb_steps-1)
        else 
            return count_stones(d * 2024, nb_steps-1, stone_counter)
        end
    elseif d == 0
        return count_stones(1, nb_steps-1, stone_counter)
    elseif d < 5 && nb_steps < 3
        return nb_steps
    elseif 5 <= d < 10 && nb_steps < 5
        return ifelse(nb_steps % 3 == 1, nb_steps, nb_steps-1)
    end
    
    return digit_map[d](nb_steps, stone_counter)
end

count_stones(d, nb_steps) = count_stones(d, nb_steps, 0)

digit_map = Dict(
    0 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-4) for e in [2, 0, 2, 4]),
    1 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-3) for e in [2, 0, 2, 4]),
    2 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-3) for e in [4, 0, 4, 8]),
    3 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-3) for e in [6, 0, 7, 2]),
    4 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-3) for e in [8, 0, 9, 6]),
    5 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-5) for e in [2, 0, 4, 8, 2, 8, 8, 0]),
    6 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-5) for e in [2, 4, 5, 7, 9, 4, 5, 6]),
    7 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-5) for e in [2, 8, 6, 7, 6, 0, 3, 2]),
    8 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-5) for e in [3, 2, 7, 7, 2, 6, 16192]),
    9 => (nb_steps, stone_counter) -> stone_counter + sum(count_stones(e, nb_steps-5) for e in [3, 6, 8, 6, 9, 1, 8, 4]),
)



# 0 1 2 3 4 5 6 7 8 9 10
# 1 1 2 4 4 7 14 16 20 39 62


for i in 0:9
    all_size = [length(blink([i], j)) for j in 1:20]
    println("digit=$i")
    println(all_size)
    println(diff(all_size))
end

function normal_update(s, nb)

    if length(digits(s)) % 2 == 0
        all_digits = digits(s)
        half = div(length(all_digits), 2)

        left = make_number(all_digits[1:half])
        right = make_number(all_digits[half+1:end])

        return (right, nb-1), (left, nb-1)
    else 
        return s * 2024, nb-1
    end
end


# 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
# 1, 1, 2, 4, 4, 7, 14, 16, 20, 39, 62

# 15458147


if false
    step11 = blink([1], 11)
    step12 = blink.(step11, Ref(1))
    step12_recount = count_stones.(step11, Ref(1), 0)
end


0.002, 4, 264, 18000, 1300000,