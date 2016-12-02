#elixir parser

#AOC1.findHQ("R5, R4, R2, L3, R1, R1, L4, L5, R3, L1, L1, R4, L2, R1, R4, R4, L2, L2, R4, L4, R1, R3, L3, L1, L2, R1, R5, L5, L1, L1, R3, R5, L1, R4, L5, R5, R1, L185, R4, L1, R51, R3, L2, R78, R1, L4, R188, R1, L5, R5, R2, R3, L5, R3, R4, L1, R2, R2, L4, L4, L5, R5, R4, L4, R2, L5, R2, L1, L4, R4, L4, R2, L3, L4, R2, L3, R3, R2, L2, L3, R4, R3, R1, L4, L2, L5, R4, R4, L1, R1, L5, L1, R3, R1, L2, R1, R1, R3, L4, L1, L3, R2, R4, R2, L2, R1, L5, R3, L3, R3, L1, R4, L3, L3, R4, L2, L1, L3, R2, R3, L2, L1, R4, L3, L5, L2, L4, R1, L4, L4, R3, R5, L4, L1, L1, R4, L2, R5, R1, R1, R2, R1, R5, L1, L3, L5, R2")

defmodule AOC1 do
    def findHQ(directions) do
        step({0,0}, 0, String.split(directions, ", "))
    end

    def step(cur_loc, cur_or, [next_dir_str|directions]) do
        orientations = [{0,1},{1,0},{0,-1},{-1,0}]
        next_dir = String.split_at(next_dir_str, 1)
        next_or = cur_or
        if(elem(next_dir, 0) == "L") do
            next_or = cur_or - 1
            if(next_or < 0) do
                next_or = next_or+4
            end
        else
            next_or = cur_or + 1
            if(next_or >= 4) do
                next_or = next_or-4
            end
        end

        dist = elem(Integer.parse(elem(next_dir,1)),0)
        x_mult = elem(Enum.at(orientations,next_or),0)

        next_x = elem(cur_loc,0)+elem(Enum.at(orientations,next_or),0)*dist
        next_y = elem(cur_loc,1)+elem(Enum.at(orientations,next_or),1)*dist

        next_loc = {next_x, next_y}

        step(next_loc,next_or,directions)
    end

    def step(cur_loc, cur_dir, []) do
        cur_loc
    end
end
