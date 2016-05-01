function drawSmallMaze()
{
    var c = document.getElementById("maze");
    var ctx = c.getContext("2d");
    ctx.fillStyle = "#FAFAD2";
    ctx.fillRect(0,0,400,400);
    ctx.fillStyle = "#000000";
    ctx.fillRect(0,240,80,80);
    ctx.fillRect(80,80,160,80);
    ctx.fillRect(160,160,160,80);
    ctx.fillRect(160,240,80,160);
    ctx.fillRect(320,0,80,80);
    ctx.fillRect(320,320,80,80);
    ctx.fillStyle = "#ADFF2F";
    ctx.fillRect(240,320,80,80);
}

function drawRobot(x, y)
{
    var c = document.getElementById("maze");
    var ctx = c.getContext("2d");
    ctx.clearRect(0, 0, 400, 400);
    drawSmallMaze();
    ctx.fillStyle = "#FF1493";
    ctx.fillRect(x,y,80, 80);
}
