$x = 0
$y = 0

def moveUp
    unless $y == 0
        $y -= 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveRight
    unless $x == 4
        $x += 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveLeft
    unless $x == 0
        $x -= 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def moveDown
    unless $y == 4
        $y += 1
        %x{drawRobot(#{$x} * 80, #{$y} * 80);}
    end
end

def canMoveUp?
    if $y == 0
        false
    else
        true
    end
end

def canMoveDown?
    if $y == 4
        false
    else
        true
    end
end

def canMoveLeft?
    if $x == 0
        false
    else
        true
    end
end

def canMoveRight?
    if $x == 4
        false
    else
        true
    end
end

def atExit?
    if ($x == 3 && $y == 2)
        true
    else
        false
    end
end

def check
    if atExit?
        %x{alert("Congratulations you found the exit!");}
    else
        %x{alert("Better luck next time"); drawRobot(0,0);}
        $x = 0
        $y = 0
    end
end
