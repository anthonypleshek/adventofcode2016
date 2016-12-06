# AOC.doorPassword("abc")
# AOC.doorPassword("wtnhxymk")

defmodule AOC do

    def doorPassword(doorId) do

        getPassword(doorId, %{}, 0, 0)
    end

    def getPassword(doorId, password, passwordCount, counter) do
        if(rem(counter, 1000000) == 0) do
            IO.puts(counter)
        end

        if(passwordCount == 8) do
            password
        else
            hash = :crypto.hash(:md5, doorId <> Integer.to_string(counter)) |> Base.encode16(case: :lower)
            if(String.slice(hash,0,5) == "00000") do
                index = String.at(hash,5)
                passwordChar = String.at(hash,6)
                if(index >= "0" && index <= "7") do
                    if(Map.has_key?(password, index) == false) do
                        password = Map.put(password, index, passwordChar)
                        IO.inspect(password)
                        passwordCount = passwordCount + 1
                    end
                end
            end

            getPassword(doorId, password, passwordCount, counter + 1)
        end
    end

end
