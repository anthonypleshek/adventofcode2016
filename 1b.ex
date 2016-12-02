#elixir parser

#AOC1pt2.findHQ("R5, R4, R2, L3, R1, R1, L4, L5, R3, L1, L1, R4, L2, R1, R4, R4, L2, L2, R4, L4, R1, R3, L3, L1, L2, R1, R5, L5, L1, L1, R3, R5, L1, R4, L5, R5, R1, L185, R4, L1, R51, R3, L2, R78, R1, L4, R188, R1, L5, R5, R2, R3, L5, R3, R4, L1, R2, R2, L4, L4, L5, R5, R4, L4, R2, L5, R2, L1, L4, R4, L4, R2, L3, L4, R2, L3, R3, R2, L2, L3, R4, R3, R1, L4, L2, L5, R4, R4, L1, R1, L5, L1, R3, R1, L2, R1, R1, R3, L4, L1, L3, R2, R4, R2, L2, R1, L5, R3, L3, R3, L1, R4, L3, L3, R4, L2, L1, L3, R2, R3, L2, L1, R4, L3, L5, L2, L4, R1, L4, L4, R3, R5, L4, L1, L1, R4, L2, R5, R1, R1, R2, R1, R5, L1, L3, L5, R2")

defmodule AOC1pt2 do
    require MapSet

    def findHQ(directions) do
        locations = MapSet.new()

        locations = MapSet.put(locations, {0,0})

        step({0,0}, 0, 0, String.split(directions, ", "), locations)
    end

    def step(cur_loc, cur_or, cur_steps_left, directions, locations) do
        orientations = [{0,1},{1,0},{0,-1},{-1,0}]

        if(cur_steps_left < 1) do
            next_dir = String.split_at(hd(directions), 1)
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

            cur_steps_left = elem(Integer.parse(elem(next_dir,1)),0)

            cur_or = next_or

            directions = tl(directions)
        end

        next_x = elem(cur_loc,0)+elem(Enum.at(orientations,cur_or),0)
        next_y = elem(cur_loc,1)+elem(Enum.at(orientations,cur_or),1)

        next_loc = {next_x, next_y}

        IO.inspect(next_loc)

        if(MapSet.member?(locations, next_loc)) do
            next_loc
        else
            steps_left = cur_steps_left - 1
            step(next_loc, cur_or, steps_left, directions, MapSet.put(locations,next_loc))
        end

    end

    def step(cur_loc, cur_dir, 0, [], locations) do
        "Nope"
    end
end
