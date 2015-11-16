local widget = require("widget")
require("sample11")
local function init()
	distance = 0.0
    distanceOld = 0.0
    farthestPtX = 0
    farthestPtY = 0
    isCircle = -1
    space = 0
    nodes = {}
    propertyNode = {}
    strokeCircle = {}
    verticeList = {}
    i = -1
    s = -1
    v = 0
    ptr = -1
    shapePreference = 0
    background = display.newGroup()
	foreground = display.newGroup()
	dynamicPtX = {0,0,0,0}
    dynamicPtY = {0,0,0,0}
    coorX = 0
    coorY = 0
    endX = 0
    endY = 0
    strokeCircleWidth = 10
    rectWidth = display.viewableContentWidth/3
    rectHeight =  display.viewableContentWidth/6
    circleRadius = display.viewableContentWidth/7
    globalStrokeWidth = display.viewableContentWidth/60
end
init()

local function reset(  )
       distance = 0.0
       distanceOld = 0.0
       distanceNew = 0.0
       farthestPtX = 0
       farthestPtY = 0
end 

local function shapePrefCircle( event )
    print("In circle pref")
    shapePreference = 1
    return true
end 

local function shapePrefRoundRect( event )
    print("In round Rect")
    shapePreference = 2
    return true
end 

local function shapePrefEllipse( event )
    print("In Ellipse")
    shapePreference = 3
    return true
end 

local function onCollision( event )
    if(event.phase == "began") then
        print ("collision at"..event.x..","..event.y)
        isCircle = 1

    elseif (event.phase == "ended") then
        --print ("collision at"..event.x..","..event.y)
        --print("Is a circle")
        isCircle = 1

    end
end

local function isLineTouchCircle( x1,y1,x2,y2 )
    print("In isLineTouchCircle")
    print("coorX,coorY = "..x1..","..y1)
    print("endX,endY = "..x2..","..y2)
    for x=1, table.maxn(verticeList) do
        print(verticeList[x][1]..","..verticeList[x][2])
    end
    for x =1,table.maxn(verticeList) do
        local t1 = verticeList[x][1]
        local t2 = verticeList[x][2]
        print("t1,t2 ="..t1..","..t2)
        local vertice1 =  math.sqrt(math.pow((x1 - t1)/2,2) + math.pow((y1 - t2)/2,2) )
        local vertice2 =  math.sqrt(math.pow((x2 - t1)/2,2) + math.pow((y2 - t2)/2,2) )  
        if(vertice1 < 25) or (vertice2 < 25) then
            return true
        elseif(x == table.maxn(verticeList)) then
            return false
        end
    end
        
end


local function circle_autoComplete(x1,x2,rad )
	print("In circle_autoComplete")	
	local circleNode = display.newCircle(x1,x2,circleRadius)   
	circleNode.stroke= {0,1,0}
    circleNode.strokeWidth = globalStrokeWidth
	i = i + 1
	nodes[i] = circleNode
	foreground:insert(nodes[i])
	reset()
	return true
end 

local function roundRect_autoComplete(x1,x2)
    print("In roundRect_autoComplete") 
    local circleNode = display.newRoundedRect(x1,x2,rectWidth,rectHeight,20)  
    circleNode.stroke= {0,1,0}
    circleNode.strokeWidth = globalStrokeWidth
    i = i + 1
    nodes[i] = circleNode
    foreground:insert(nodes[i])
    reset()
    return true
end 

local function ellipse_autoComplete(x1,x2)
    print("In ellipse_autoComplete") 
--[[    local ellipseButton = widget.newButton
    {
    x = x1,
    y = x2,
    width = display.viewableContentWidth/4,
    height = display.viewableContentWidth/6,
    defaultFile = "ellipse.png"
    }
]]--
    local ellipseButton = display.newImage("ellipse.png")
    ellipseButton.x = x1
    ellipseButton.y = x2
    ellipseButton.width = display.viewableContentWidth/4
    ellipseButton.height = display.viewableContentWidth/6
    i = i + 1
    nodes[i] = ellipseButton
    foreground:insert(nodes[i])
    reset()
    return true
end 

local function doWeHaveAcircle( x1,y1,x2,y2 )
    local space = math.sqrt(math.pow((x1 - x2)/2,2) + math.pow((y1 - y2)/2,2) )
    if(space < 4*strokeCircleWidth) then
        isCircle = 1
        print("Is a circle")
    else
        isCircle = 0
    end
end 


local function myTouchListener( event )    
local tempGroup = display.newGroup()

    if ( event.phase == "began" ) then
        coorX = event.x
        coorY = event.y      
    elseif ( event.phase == "moved" ) then
        local paint = { 1, 0, 0.5 }
        s = s+1
   strokeCircle[s] = display.newCircle(event.x,event.y,5) -- Draw circle at each point touched
   strokeCircle[s]:setFillColor(1,0,0.5)

       distanceNew = math.sqrt(math.pow((event.x - coorX),2) + math.pow((event.y - coorY),2) )
        if((distanceOld)  <= (distanceNew)) then
            distance = distanceNew
            farthestPtX = event.x
            farthestPtY = event.y
            distanceOld = distanceNew
        end


    elseif ( event.phase == "ended" ) then  
        endX = event.x
        endY = event.y  	

        doWeHaveAcircle(coorX,coorY,endX,endY)
        print("farthestPtX , farthestPtY"..farthestPtX..","..farthestPtY)
        print("coorX , coorY"..coorX..","..coorY)
       
    
     		if(isCircle == 1) and (shapePreference ==1) then
        	   radius = math.sqrt(math.pow((farthestPtX - coorX)/2,2) + math.pow((farthestPtY - coorY)/2,2) )
               centerX = (farthestPtX + coorX) /2
               centerY = (farthestPtY + coorY) /2
               v = v+1
               verticeList[v] = {centerX,centerY}
               print("Center is "..centerX..","..centerY)
        	   local centerCircle = display.newCircle(centerX,centerY,5)
        	   centerCircle:setFillColor( 0, 0, 1 )
        	   circle_autoComplete(centerX,centerY,radius)  --Draw a circle at centerX,Y      	
               isCircle = -1               
            end

            if(isCircle == 1) and (shapePreference ==2) then
               radius = math.sqrt(math.pow((farthestPtX - coorX)/2,2) + math.pow((farthestPtY - coorY)/2,2) )
               centerX = (farthestPtX + coorX) /2
               centerY = (farthestPtY + coorY) /2
               v = v+1
               verticeList[v] = {centerX,centerY}
               print("Center is "..centerX..","..centerY)
               local centerCircle = display.newCircle(centerX,centerY,5)
               centerCircle:setFillColor( 0, 0, 1 )
               roundRect_autoComplete(centerX,centerY)  --Draw a circle at centerX,Y        
               isCircle = -1               
            end

            if(isCircle == 1) and (shapePreference ==3) then
               radius = math.sqrt(math.pow((farthestPtX - coorX)/2,2) + math.pow((farthestPtY - coorY)/2,2) )
               centerX = (farthestPtX + coorX) /2
               centerY = (farthestPtY + coorY) /2
               v = v+1
               verticeList[v] = {centerX,centerY}
               print("Center is "..centerX..","..centerY)
               local centerCircle = display.newCircle(centerX,centerY,5)
               centerCircle:setFillColor( 0, 0, 1 )
               ellipse_autoComplete(centerX,centerY)  --Draw a circle at centerX,Y        
               isCircle = -1               
            end

            if(isCircle ==0) then
                local rectLength = math.sqrt(math.pow((coorX - endX)/2,2) + math.pow((coorY - endY)/2,2) )
                centerX = (farthestPtX + coorX) /2
                centerY = (farthestPtY + coorY) /2

                print("Center is "..centerX..","..centerY)
                
                local edgeLine = display.newLine(coorX,coorY,endX,endY)               
                print("coorX,coorY = "..coorX..","..coorY)
                print("endX,endY = "..endX..","..endY)
                local x1 = coorX
                local y1 = coorY
                local x2 = endX
                local y2 = endY
                local validity = isLineTouchCircle(x1,y1,x2,y2)
                print(validity)
                edgeLine:setStrokeColor(0,0,0)
                isCircle = -1
                
                if(validity == true) then
                    local directedEdge = display.newLine(coorX,coorY,endX,endY)
                    directedEdge:setStrokeColor(0,0,0)
                    local directedEdgeEnd = display.newRect(endX,endY,20,20)                  
                    directedEdgeEnd:setFillColor(0,0,1)

                    directedEdge.strokeWidth = globalStrokeWidth

                    display.remove(edgeLine)
                else
                    display.remove(edgeLine)
                    reset()
                end
            end

 	for x =0,table.maxn(strokeCircle ) do --Remove user drawn strokes
        display.remove(strokeCircle[x])
    end
    s = -1
    ptr = -1
    isCircle = -1
    end   
  --  return true  --prevents touch propagation to underlying objects
    
end

    
local myButton = display.newRect( display.contentCenterX,display.contentCenterY - display.contentCenterY/8,display.viewableContentWidth, display.viewableContentHeight - display.viewableContentHeight/8 )
myButton:addEventListener( "touch", myTouchListener ) 

local roundRectButton = widget.newButton
{
x = display.viewableContentWidth/5,
y = display.viewableContentHeight/1.07,
width = display.viewableContentWidth/4,
height = display.viewableContentWidth/6,
defaultFile = "roundedRect.png",
overFile = "roundedRectPress.png"
}

roundRectButton:addEventListener("touch",shapePrefRoundRect)

local circleButton = widget.newButton
{
    x = display.viewableContentWidth/5 + roundRectButton.width,
    y = display.viewableContentHeight/1.07,
    width = display.viewableContentWidth/5,
    height = display.viewableContentWidth/5,
    defaultFile = "circleImg.png",
    overFile = "circleImgPress.png"
}

circleButton:addEventListener("touch",shapePrefCircle)

local ellipseButton = widget.newButton
{
    x = display.viewableContentWidth/5 + 2* roundRectButton.width,
    y = display.viewableContentHeight/1.07,
    width = display.viewableContentWidth/4,
    height = display.viewableContentWidth/6,
    defaultFile = "ellipseImg.png",
    overFile = "ellipseImgPress.png"
}


local questionButton = widget.newButton
{
    x = display.viewableContentWidth/5 + 2.8* roundRectButton.width,
    y = display.viewableContentHeight/1.07,
    width = display.viewableContentWidth/6,
    height = display.viewableContentWidth/6,
    defaultFile = "question.png",
    overFile = "question.png"
}

ellipseButton:addEventListener("touch",shapePrefEllipse)
  
background = display.newGroup()
foreground = display.newGroup()
--Runtime:addEventListener("collision",onCollision)
--background:insert(myButton)  
--foreground:insert(roundRectButton)
