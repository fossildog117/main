$arr = [[5,28,6,3,6,3,66,5,45],[6,3,9],[45,35,55,25,65,15],[999,0,33,6,4096]]

def printOutput
    output = ""
    $arr.each { |array|
    output = output + array.inspect + "  ->  " + shuttleSort(array).inspect + "\n"
    }
    %x{document.getElementById('output').innerHTML = #{output};}
end
