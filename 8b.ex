# AOC.doit("./8-test.txt")
# AOC.doit("./8-input.txt")

defmodule AOC do

    def doit(inputFilename) do
        inputFileStr = File.read!(inputFilename)
        inputArray = String.split(inputFileStr,"\n", trim: true)

    end

end
