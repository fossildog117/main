function drawLine(x1,y1,x2,y2)
{
    var c = document.getElementById("drawing");
    var ctx = c.getContext("2d");
    ctx.moveTo(x1,y1);
    ctx.lineTo(x2,y2);
    ctx.stroke();
}

function fillRect(x,y,width,height)
{
    var c = document.getElementById("drawing");
    var ctx = c.getContext("2d");
    ctx.fillRect(x,y,width,height);
}

function clearCanvas()
{
    var c = document.getElementById("drawing");
    var ctx = c.getContext("2d");
    ctx.clearRect(0, 0, 400, 400);
    ctx.fillStyle = "#FAEBD7";
    ctx.fillRect(0,0,400,400);
    ctx.fillStyle = "#000000";
}
