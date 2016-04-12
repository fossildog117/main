require 'js'

$maze = [[0,0,0,0,1],[0,1,1,0,0],[0,0,1,1,0],[1,0,1,0,0],[0,0,1,0,1]]
$x = 0
$y = 4

def moveUp
    unless ($y == 0 || $maze[$y - 1][$x] == 1)
        $y -= 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveRight
    unless ($x == 4 || $maze[$y][$x + 1] == 1)
        $x += 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveLeft
    unless ($x == 0 || $maze[$y][$x - 1] == 1)
        $x -= 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveDown
    unless ($y == 4 || $maze[$y + 1][$x] == 1)
        $y += 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end
