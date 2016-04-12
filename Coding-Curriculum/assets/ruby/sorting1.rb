$arr = [[5,3,7,3,7,3,99,32,2],[8,45,3,2,4],[1,7,4,3,2],[4,6,4,23,6,3,6,3]]

def printOutput
    output = ""
    $arr.each { |array|
    output = output + array.inspect + "  ->  " + bubbleSort(array).inspect + "\n"
    }
    %x{document.getElementById('output').innerHTML = #{output};}
end
