class Game
    def initialize
        @guessing = Guessing.new
    end

    def guess(attempt)
        result = @guessing.guess(attempt)
        if (result == 0)
            %x{ document.getElementById('output').innerHTML = "Correct!";
            }
        elsif (result == -1)
            %x{ document.getElementById('output').innerHTML = "Too low!"; }
        else
            %x{ document.getElementById('output').innerHTML = "Too high!"; }
        end
    end
end
