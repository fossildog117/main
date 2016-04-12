function drawDungeon()
{
    var c = document.getElementById("trap");
    var ctx = c.getContext("2d");
    ctx.fillStyle = "#FAFAD2";
    ctx.fillRect(0,0,400,400);
}

function drawRobot(x, y)
{
    var c = document.getElementById("trap");
    var ctx = c.getContext("2d");
    ctx.clearRect(0, 0, 400, 400);
    drawDungeon();
    ctx.fillStyle = "#FF1493";
    ctx.fillRect(x,y,80, 80);
}
