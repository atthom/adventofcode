using CSV, DataFrames

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