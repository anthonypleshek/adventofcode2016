# AOC.doorPassword("abc")
# AOC.doorPassword("wtnhxymk")

defmodule AOC do

    def doorPassword(doorId) do
        getPassword(doorId, "", 0)
    end

    def getPassword(doorId, password, counter) do
        if(rem(counter, 1000000) == 0) do
            IO.puts(counter)
        end

        if(String.length(password) == 8) do
            password
        else
            hash = :crypto.hash(:md5, doorId <> Integer.to_string(counter)) |> Base.encode16(case: :lower)
            if(String.slice(hash,0,5) == "00000") do
                password = password <> String.at(hash,5)
                IO.puts(password)
            end

            getPassword(doorId, password, counter + 1)
        end
    end

end
