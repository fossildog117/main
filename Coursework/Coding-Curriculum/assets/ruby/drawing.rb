require 'js'

def drawLine(x1,y1,x2,y2)
  %x{drawLine(#{x1},#{y1},#{x2},#{y2});}
  end

def fillRect(x,y,width,height)
  %x{fillRect(#{x},#{y},#{width},#{height});}
end

def clearCanvas
  %x{clearCanvas();}
end
