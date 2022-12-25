#Utils & Config
data = JSON.parse Utils.domLoadDataSync 'data/programmeData.json'

hyperSpeed = false
youviewBlue = '#00a6ff'
youviewBlue2 = '#0F5391'
youviewBlue3 = 'rgba(0, 51, 102, 0.8);'
youviewGrey1 = '#b6b9bf'
youviewGrey2 = '#83858a'
darkGrey3 = '#505359'
black = '#000'
white = '#ebebeb'
veryDarkGrey4 = '#171717'
veryDarkGrey5 = '#0D0D0D'
minute = 9.6
document.body.style.cursor = "auto"

#Struan Utils
convertToPixel = (time) ->
	return time*minute

getDate = (modifier) ->
	date = new Date()
	dateInt = date.getUTCDate()
	if (dateInt + modifier) > 31 or (dateInt + modifier) <= 0
		dateInt = (dateInt + modifier)%31
	else
		dateInt+=modifier
	return dateInt

getTime = (modifier) ->
	date = new Date()
	time = date.getHours()
	modifier = modifier + 48*100
	if modifier%2#Odd
		time += ((modifier-1)/2)
		time = time%24
		newTime = String(time) + ":00"
	else#Even
		time += (modifier/2 - 1)
		time = time%24
		newTime = String(time) + ":30"
	return newTime

getDay = (modifier) ->
	if modifier == 0
		day = "Today"
		fontColor = white
		fontOpacity = 1
		fontOpacityDate = 1
		return day
	else
		dayString = ""
		today = new Date()
		dayInt = today.getUTCDay()
		dayInt += modifier
		if dayInt < 0
			dayInt = (dayInt+7)%7
		if dayInt > 6
			dayInt%=7
		switch dayInt
			when 0 then dayString = "Sunday"
			when 1 then dayString = "Monday"
			when 2 then dayString = "Tuesday"
			when 3 then dayString = "Wednesday"
			when 4 then dayString = "Thursday"
			when 5 then dayString = "Friday"
			when 6 then dayString = "Saturday"
		return dayString.substring(0,3)


	
rowEvents = []
eventDivider = []
# eventTextObject = []

for i in [0..data.programmeData.channels.length]
	rowEvents.push( i )
	eventDivider.push( i )

for i in [0..rowEvents.length]
	rowEvents[i] = []
	eventDivider[i] = []

eventTitle = [0,1,2,3,4,5,6]

channelIdent = []
dateTrack = []
rowDivider = []

filterSelection = 0
filterSelected = 0
Framer.Defaults.Animation =
	time: 0.3

channels = []
filterLayer = []
hX = 1
hY = 0
virtualCursor = 300
maxExpansion = 45
tunedChannel = 0
filter = ['All Channels','HD','Entertainment',"Children's",'News','Films','Factual & Lifestyle','Radio','Shopping & Travel','Adult & Dating']
tuned = ['http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4']

Utils.interval 1, ->
	Framer.Device.setDeviceScale( (Canvas.width/Screen.width) * 1, false )

cellHeight = 60
cellLeftPadding = 8

#Static Layers

tvShow = new VideoLayer
	x:0
	width:1280
	height:720
	backgroundColor: black
	video:tuned[tunedChannel]
	index:-1

tvShow.center()
tvShow.player.autoplay = true
tvShow.player.loop = true
tvShow.player.muted = true

background = new Layer
	width:1280
	height:720
	x:0
	backgroundColor:null
	clip:true
background.center()

eventParent = new Layer
	parent:background
	y:260
	width:1280
	height:460
	index:1
	backgroundColor: null
	clip:true

serviceList = new Layer
	parent:eventParent
	x:64
	y:2
	width:224
	height:460
	index:4
	backgroundColor:'rgba(0, 0, 0, 0.5)'

divider = new Layer
	parent:eventParent
	width:1280
	height:2
	y:0
	index:-1
	backgroundColor:veryDarkGrey4

header = new Layer
	parent:background
	x:0
	width:1280
	height:226

dateTrackHeader = new Layer
	parent:header
	width:1280
	height:162
	backgroundColor: 'rgba(0, 48, 109, 0.50)'
	opacity: 0.85

dateTrackContainer = new Layer
	parent:background
	x:40, y:96, index:10
	height:32
	opacity:1
	backgroundColor: "transparent"

dayTrack = []
fillDateTrack = () ->
	dayModifier = -7
	
	for i in [0...15]
		fontColor = youviewGrey1
		fontOpacity = 0.7
		fontOpacityDate = 0.4
		day = getDay(dayModifier)
		
		dateContainer = new Layer
			parent:dateTrackContainer
			width:80, height:48
			x:i*80
			backgroundColor: 'transparent'
		
		newDay = new TextLayer
			name:day+dayModifier
			parent:dateContainer
			width:80, height:32
			text:day, textAlign: "center", textTransform: "uppercase", fontFamily: "GillSans-Bold", fontSize:16, letterSpacing: 1.92, color:fontColor
			opacity: fontOpacity
			dayTrack.push(newDay)
			
		date = getDate(dayModifier)
		newDate = new TextLayer
			parent:dateContainer
			y:24, width:80, height:16
			text:date, textAlign: "center", textTransform: "uppercase", fontFamily: "GillSans-Bold, GillSans-Bold", fontSize:16, letterSpacing: 1.92, color:white
			opacity:fontOpacityDate
		dayModifier++
		dateTrack.push(dateContainer)

expansionTimeout = 0
nowLineTimeout = 0
legendTimeout = 0

unselectedSecondLineOpacity = 0.3
separatorOpacity = 0.2

#Event Handling
fastScroll = 0

captureKeys = () ->
	document.addEventListener 'keydown', (event) ->
		keyCode = event.which
		eventHandler(keyCode)
		expansionTimeout = 0

dumbVariable = 0
eventHandler = Utils.throttle 0.2, (keyCode) ->
	thisY = hY
	thisX = hX
	if fastScroll == 4 and thisY > 0
		engageHyperSpeed(keyCode)
	else if hyperSpeed == false
		switch keyCode
			when 13
				if thisY >= 0
					tune()
				else if thisY == -1
					selectFilter()
			when 39 #Right
				legendTimeout = 0
				hideLegend.start()
				goRight(thisX, thisY)
				fastScroll++
			when 37 #Left
				legendTimeout = 0
				hideLegend.start()
				goLeft(thisX, thisY)
				fastScroll++
			when 40 #Down
				legendTimeout = 0
				hideLegend.start()
				goDown(thisX, thisY)
			when 38 #Up
				legendTimeout = 0
				hideLegend.start()
				goUp(thisX, thisY)
			when 71
				if thisY >= 0
					openGuide()
			when 82 #R
				record(thisX, thisY)

document.addEventListener 'keyup', (event) ->
	keyCode = event.which
	closeHandler(keyCode)
closeHandler = (keyCode) ->
	y = hY
	x = hX
	switch keyCode
		when 39, 37
			fastScroll = 0
			hyperSpeed = false
			disengageHyperSpeed(x,y)

engageHyperSpeed = (keyCode) ->
	if trackChanged == true	
		hideEverything()
	scroll(keyCode)
timeElapsed = 1	

#Scroll Stuff
timeTrack = new Layer
	height:34, width:1280
	y:225
	index:6
	opacity:0.95
	borderColor: 'transparent'
	backgroundColor: 'rgba(4, 44, 94, 0.4)'
timeContainer = new Layer
	parent:timeTrack
	backgroundColor: 'transparent'
timeContainer.states =
	hide:
		opacity:0
	show:
		opacity:0.95

for i in [1..4]
	times = new TextLayer
		name:'time' + i
		parent:timeContainer
		x:convertToPixel(30)*(i), y:8, index:4
		height:18, width:55
		text:getTime(i)
		textAlign:'center'
		fontSize:16, fontFamily:'GillSans-Bold, GillSans-Bold'
		color:white

#Scrolling Time

dateModifier = 0
dayModifier = 0
trackChanged = false
selectedDate = 7

scrollingDay = new TextLayer
	midX:Screen.midX - 27, y:89
	text:'Today', textTransform:'uppercase', fontFamily:"GillSans-Bold", color:white, fontSize:24, textAlign:'center'
	opacity:0

scrollingDate = new TextLayer
	y: 124, midX:Screen.midX - 27, opacity: 0
	text:getDate(0), textTransform:'uppercase', fontFamily:'GillSans-Light', color:white,	fontSize:20, textAlign:'center'

changeDay = (change) ->
	if selectedDate <= 13 and selectedDate >= 0
		dateTrack[selectedDate].children[1].opacity = 0.4
		dateTrack[selectedDate].children[0].opacity = 0.7
		selectedDate += change
		dateTrack[selectedDate].children[1].opacity = 1
		dateTrack[selectedDate].children[0].opacity = 1

		newDay = parseInt(scrollingDate.text)
		scrollingDate.text = newDay + change
		scrollingDay.text = getDay(selectedDate)

scroll = (keyCode) ->
	hyperSpeed = true
	if trackChanged == false
		activeTimeTrack()

	#If right
	if keyCode == 39
		if timeContainer.children[ 1 ].y == -31
			timeElapsed+=1
		if (getTime( timeElapsed+1 ) == '0:00')
			changeDay(1)
	#If left
	else if keyCode == 37
		if timeContainer.children[ 1 ].y == -31
			timeElapsed--
		if(getTime( timeElapsed+1 ) == '0:00')
			dayModifier--
			changeDay(-1)

	forEachTime = -1

	if timeElapsed % 2
		for k in [ 0...timeContainer.children.length ]
			timeContainer.children[ k ].text = getTime( forEachTime + timeElapsed )
			forEachTime++

hideTime = new Animation
	layer:timeContainer
	properties:
		opacity:0
	delay:0.1

showTime = hideTime.reverse()

activeTimeTrack = () ->
	hideTime.start()
	trackChanged = true

disengageHyperSpeed = Utils.throttle 1, (x,y) ->
	hyperSpeed = false
	scrollingDay.animate
		opacity:0
		options:
			time:0.5
	scrollingDate.animate
		opacity:0
# 	scrollingDate.onAnimationStop ->
# 		timeContainer.stateSwitch('hide')
# 		timeTrackDefaults()
# 		showEverything(x,y)
# 		scrollingDate.removeAllListeners
	trackChanged = false
	

timeTrackDefaults = () ->
	for i in [ 0..3 ]
		timeContainer.children[ i ].y = 8
		timeContainer.children[ i ].fontSize = 16
		timeContainer.children[ i ].color = youviewGrey2
	timeContainer.children[ 1 ].opacity = 0.5
	timeTrack.opacity = 0.95
	timeContainer.stateSwitch('show')

hideEverything = Utils.throttle 1, () ->
	nowline.opacity = 0
	for i in [0...channels.length]
		for j in [0...channels[i].children.length]
			channels[i].children[j].animate
				opacity:0
				options:
					time:0.1*i
	dateTrackContainer.animate
		opacity: 0
	filterContainer.animate
		opacity: 0

showEverything = Utils.throttle 1, (x,y) ->
	nowline.opacity = 1
	for i in [channels.length-1..0]
		for j in [channels[i].children.length-1..0]
			channels[i].children[j].animate
				opacity:1
				options:
					time:0.1*j
	styleHighlight(x,y)
	filterDividerBottom.stateSwitch('show')
	dateTrackContainer.animate
		opacity: 1
	filterContainer.animate
		opacity:1

#Fluff
openGuide = () ->
	if background.opacity == 0
		background.opacity = 1
	else	
		background.opacity = 1

tune = () ->
	if background.opacity == 1
		tunedChannel++
		if tunedChannel == tuned.length
			tunedChannel = 0
		tvShow.video = tuned[tunedChannel]
		background.opacity = 0
#Styling & Expansion
styleHighlight = (x,y,xMod,yMod) ->
	if yMod == NaN then yMod = 0
	if xMod == NaN then xMod = 0
	popOutHighlight.shadow2.color = 'rgba(0,0,0,0)'
	channels[selectedRow].backgroundColor = youviewBlue3
	channels[selectedRow].opacity = 1
	channelIdent[y].opacity = 1
	rowEvents[y][x].turnOn()
	rowEvents[y][x].showOn()
	eventDivider[y][x].opacity = 0
	eventDivider[y][x+1].opacity = 0 if eventDivider[y]?[x+1]?
	if xMod == 1 or xMod == -1
		changeVirtualCursor(x,y)
	
	for i in [0...channelIdent.length]
		for j in [0...channels[i].children.length]
			channels[i].children[j].turnOff()
	if rowEvents[y][x].x > serviceList.maxX
		popOutHighlight.x = rowEvents[y][x].x

	else
		popOutHighlight.x = serviceList.maxX
	popOutHighlight.y = rowEvents[y][x].screenFrame.y
	popOutHighlight.width = rowEvents[y][x].width
	popOutHighlight.height = 60
	popOutHighlight.borderRadius = 0

	highlightTitle.x = 8
	highlightTitle.y = 20
	synopsis.visible = false
	highlightStartEnd.visible = false
	
	highlightTitle.text = rowEvents[y][x].children[0].text
	highlightTitle.width = rowEvents[y][x].width - popOutPadding
	synopsis.width = rowEvents[y][x].width - popOutPadding
	highlightStartEnd.width = rowEvents[y][x].width - popOutPadding
	hY = y
	hX = x

popOutPadding = 16
popOutHighlight = new Layer
	backgroundColor: '#0F5391'
	height: 60 #94
	shadow2: 
		y: 5
		blur: 20
		color: 'rgba(0,0,0,0)'
highlightTitle = new TextLayer
	parent: popOutHighlight
	fontFamily: "GillSans"
	fontSize: 20
	truncate: true
	color: '#ebebeb'
	x: 8, y: 20 # 34
	height: 26
highlightStartEnd = new TextLayer
	parent: popOutHighlight
	fontFamily: "GillSans-Bold"
	fontSize: 16
	truncate: true
	color: youviewGrey1
	x: popOutPadding, y: 10
	textTransform: 'uppercase'
	height: 26
	text: '6:00 – 9:00PM'
	visible: false
synopsis = new TextLayer
	parent: popOutHighlight
	fontFamily: "GillSans"
	color: youviewGrey1
	truncate: true
	fontSize: 18
	visible: false
	y: 62, x: popOutPadding
	height: 26
	text: '5/8. Drama about midwives in 1960s London. Lucille must win the trust of a mother who is terrified of giving birth. Nurse Crane and Dr Turner encounter a suspected smallpox case. Also in HD.'
	
# Expansion Rules
expansionCleverness = (x,y) ->
	popOutHighlight.borderRadius = 1
	popOutHighlight.y -= 14
	popOutHighlight.x -= 8
	popOutHighlight.height = 94
	popOutHighlight.shadow2.y = 5
	popOutHighlight.shadow2.blur = 20
	popOutHighlight.shadow2.color = 'rgba(0,0,0,0.4)'
	highlightTitle.x = popOutPadding
	highlightTitle.y = 34
	highlightStartEnd.x = popOutPadding
	synopsis.x = popOutPadding
	synopsis.visible = true
	highlightStartEnd.visible = true
	if popOutHighlight.width < convertToPixel(maxExpansion) + popOutPadding
		popOutHighlight.width = convertToPixel(maxExpansion) + popOutPadding
		highlightTitle.width = convertToPixel(maxExpansion) - popOutPadding
		synopsis.width = convertToPixel(maxExpansion) - popOutPadding
		highlightStartEnd.width = convertToPixel(maxExpansion) - popOutPadding
		
		
		
# 		if rowEvents[y][x].x < serviceList.maxX
# 		#This works perfect
# 			popOutHighlight.width = textWidthComparator.width - (rowEvents[y][x].maxX - serviceList.maxX) + popOutPadding
# 		else
# 		#If event is after service list
# 			if ( (popOutHighlight.width + rowEvents[y][x].width) > convertToPixel(maxExpansion) )
# 			#Full cell width > maxExpansion
# 				popOutHighlight.width = convertToPixel(maxExpansion) - rowEvents[y][x].width
# 				rowEvents[y][x].children[0].width = convertToPixel(maxExpansion) - 10
# 			else
# 				popOutHighlight.width = textWidthComparator.width - rowEvents[y][x].width + 34
				
				
				
# 		extension.height = cellHeight
# 		rowEvents[y][x].children[1].width = rowEvents[y][x].children[0].width + 10
		#HERE BE EXPANSION COLOUR
# 		extension.backgroundColor = youviewBlue2
# 		#093459
# 		extension.shadowColor = 'rgba(0,0,0,0.5)'
# 		extension.shadowBlur = 8
# 		extension.shadowX = 8
# 		extension.shadowY = 0
# 		extension.opacity = 1
# 	textWidthComparator.destroy()

# Navigation & Fixes
goRight = (x,y) ->
	if rowEvents[y]?[x+1]? and y >= 0
		if rowEvents[y][x+1].x < 1280
			deselectCell(x,y)
			fixDividers(x,y)
			x++
			styleHighlight(x,y,1)
	else if y == -1 and filterSelection < filterLayer.length - 1
		filterSelection++
		highlightFilter(-1)
selectedRow = 0
goLeft = (x,y) ->
	if rowEvents[y]?[x-1]?.maxX > 298 and y >=0
		deselectCell(x,y)
		fixDividers(x,y)
		x--
		styleHighlight(x,y,-1)
	else if y == -1 and filterSelection > 0
		filterSelection--
		highlightFilter(1)

goDown = (x,y) ->
	if rowEvents[y+1]?[x]? and y != -1
		deselectCell(x,y)
		channelIdent[y].opacity = 0.5
		y++
		if selectedRow == 5 and y+3 < rowEvents.length
			deselectRow(x,y,selectedRow, -1)
			showNextRow(x,y)
		else
			deselectRow(x,y,selectedRow, -1)
			selectedRow++
			x = checkHighlightPos(x,y)
			styleHighlight(x,y)
	else if y == -1
		y++
		menuHighlight.animateStop()
		menuHighlight.width = 0
		filterLayer[filterSelection].color = youviewGrey1
		filterLayer[filterSelected].color = youviewBlue2
		x = checkHighlightPos(x,y)
		styleHighlight(x,y)

goUp = (x,y) ->
	if rowEvents[y-1]?[x]?
		deselectCell(x,y)
		channelIdent[y].opacity = 0.5
		y--
		if selectedRow == 1 and y != 0
			deselectRow(x,y,selectedRow, 1)
			showPreviousRow(x,y)
		else
			deselectRow(x,y,selectedRow, 1)
			selectedRow--
			x = checkHighlightPos(x,y)
			styleHighlight(x,y)
# 	else if y == 0
# 		deselectCell(x,y)
# 		filterSelection = filterSelected
# 		highlightFilter(0)
# 		y--

highlightFilter = (oldFilterMod) ->
	if filterLayer[filterSelection]?	
		if filterSelection+oldFilterMod != filterSelected
			filterLayer[filterSelection+oldFilterMod].color = '#505359'
		else
			filterLayer[filterSelection+oldFilterMod].color = youviewBlue2
		filterLayer[filterSelection].color = youviewBlue
		menuHighlight.y = 64
		menuHighlight.x = filterLayer[filterSelection].midX
		menuHighlight.width = 0
		menuHighlightGlow.width = 0
		menuHighlight.opacity = 1
		menuHighlight.animationStop
		menuHighlight.animate
			properties:
				width:filterLayer[filterSelection].width
				x:filterLayer[filterSelection].x
			time:0.4

selectFilter = () ->
	y = 0
	filterLayer[filterSelected].color = youviewGrey1
	filterLayer[filterSelection].color = youviewBlue2
	filterSelected = filterSelection
	styleHighlight(x,y)
	menuHighlight.animateStop()
	menuHighlight.width = 0

showNextRow = (x,y) ->
	for i in [0...channelIdent.length]
		channelIdent[i].y = channelIdent[i].y - (cellHeight+2)
#		channelIdent[i].animate
# 			y: channelIdent[i].y - (cellHeight+2)
# 			options:
# 				time:0.3
# 				curve:'ease-in-out'
		for j in [0...channels[i].children.length]
			channels[i].children[j].y -= (cellHeight+2)
#			channels[i].children[j].animate
# 				y: channels[i].children[j].y - (cellHeight+2)
# 				options:
# 					time:0.3
# 					curve:'ease-in-out'
	x = checkHighlightPos(x,y)
	document.removeAllListeners
	lastChannel = channelIdent.length - 1
	lastEvent = channels[lastChannel].children.length - 1
# 	channels[lastChannel].children[lastEvent].onAnimationEnd ->
	styleHighlight(x,y,0,-1)
	captureKeys()
showPreviousRow = (x,y) ->
	for i in [0...channels.length]
		channelIdent[i].y += cellHeight+2
# 		channelIdent[i].animate
# 			y: channelIdent[i].y + (cellHeight+2)
# 			options:
# 				time:0.3
# 				curve:'ease-in-out'
		for j in [0...channels[i].children.length]
			channels[i].children[j].y += cellHeight+2
# 			channels[i].children[j].animate
# 				y: channels[i].children[j].y + (cellHeight+2)
# 				options:
# 					time:0.3
# 					curve:'ease-in-out'
	document.removeAllListeners
# 	Utils.delay 0.4, ->
	x = checkHighlightPos(x,y)
	styleHighlight(x,y)
	captureKeys()

# Actions
record = (x,y) ->
	if hY >= 0
		rowEvents[y][x].children[0].width -= 42
		rowEvents[y][x].children[0].x = 42

deselectCell = (x, y) ->
	for i in [x+1...rowEvents[y].length]
		if rowEvents[y]?[i]?
			rowEvents[y][i].index = 3
	if rowEvents[y]?[x]?.x <= serviceList.maxX
		rowEvents[y][x].children[0].width = rowEvents[y][x].maxX - serviceList.maxX - 14
	else

		rowEvents[y][x].children[0].width = convertToPixel(data.programmeData.channels[y][x].duration) - 14
	extension.opacity = 0


	for i in [0...rowEvents.length]
		for j in [0...rowEvents[i].length]
# 			rowEvents[y]?[x]?.stateSwitch('noHighlight')
			rowEvents[y]?[x]?.turnOff()
			rowEvents[y]?[x]?.showOff()

deselectRow = (x, y, rowIndex, change) ->
	channels[rowIndex].backgroundColor = ''
	for i in [0...eventDivider[ y+change ].length]
		if(rowEvents[ y+change ][ i ].screenFrame.x >= serviceList.maxX + 2)
			rowEvents[ y+change ][ i ].children[ 2 ].opacity = separatorOpacity
		else
			rowEvents[ y+change ][ i ].children[ 2 ].opacity = 0

changeVirtualCursor = (x,y) ->
	if rowEvents[y][x].x <= (serviceList.screenFrame.x + serviceList.width)
		virtualCursor = serviceList.screenFrame.x + serviceList.width + convertToPixel(15)
	else 
		virtualCursor = Utils.round(rowEvents[y][x].x, 0) + 2

checkHighlightPos = (x,y) ->
	for i in [0...rowEvents[y].length]
		if( (virtualCursor >= rowEvents[y][i].x) and (virtualCursor <= rowEvents[y][i].maxX) )
			break
	return i

fixDividers = (x,y) ->
	if(rowEvents[y][x].x > serviceList.maxX+2)
		eventDivider[y][x].opacity = 0.1
	eventDivider[y][x+1].opacity = 0.1 if eventDivider[y]?[x+1]?

#Initial Draw
#Fill rows
nextX = 0
fillRows = () ->
	for i in [0...data.programmeData.channels.length]
		rowContainer = new Layer
			parent:eventParent
			width:1280
			height:cellHeight
			y:i * (cellHeight+2) + 2
			backgroundColor:''
			index:3
		divider = new Layer
			parent:eventParent
			width:1280
			height:2
			index:0
			y:rowContainer.y+cellHeight
			backgroundColor:'rgba(18, 44, 54, 1)'
		service = new Layer
			parent:serviceList
			x:96, midY:rowContainer.midY + 80
			opacity:0.5
			backgroundColor:''
			html: "<div style='display:flex;justify-content:center;align-items:center;width:90px;height:38px;'><img src = 'images/channel_" + (i) + ".png'></div>"
		serviceNumber = new TextLayer
			parent:service
			x:-70, y:8
			text:'00' + (i + 1)
			textAlign:'center'
			fontSize:20
			letterSpacing:0.42
			fontFamily:"GillSans"
			index:4
			color:white
			opacity:0.5
		channelIdent.push( service )
		channels.push( rowContainer )
		rowDivider.push( divider )
		for j in [0...data.programmeData.channels[i].length]
			event = new Layer
				parent:channels[i]
				x:nextX
				width:convertToPixel(data.programmeData.channels[i][j].duration)
				height:cellHeight
				backgroundColor: ''
			
			event.turnOn = ->
				@.isOn = true
			event.turnOff = ->
				@.isOn = false
			event.showOn = ->
				@backgroundColor = youviewBlue2
			event.showOff = ->
				@backgroundColor = ""
			event.toggleHighlight = ->
				if @isOn == true then @isOn = false
				else if @isOn == false then @isOn = true
			
# 			event.states =
# 				highlight:
# 					backgroundColor: youviewBlue2
# 					options:
# 						time:0.2
# 				noHighlight:
# 					backgroundColor: ""
# 					options:
# 						time:0.3
			rowEvents[i].push( event )
			nextX = event.maxX
			if( event.maxX > serviceList.maxX ) # This is problem causer
				title = drawTitle( 1, i, j )
			else
				title = drawTitle( 0, i, j )
			if( event.x > serviceList.maxX + 64 )
				separator = drawSeparator( 0.1, i, j )
			else
				separator = drawSeparator( 0, i, j )
			eventDivider[i].push( separator )
		nextX = 0

drawTitle = (isVisible, i, j) -> #secondLineOpacity
	title = new TextLayer
		parent: rowEvents[i][j]
		fontFamily: "GillSans", fontSize: 20, color: '#ebebeb'
		text: data.programmeData.channels[i][j].title
		opacity: isVisible
		truncate: true
		x: cellLeftPadding, y: 20 #20 
		index: 2
		height: 26, width: rowEvents[i][j].width-14
	status = new Layer
		parent: rowEvents[i][j]
		image: 'images/icon/episode-pending.png'
		height: 20, width: 20
		x: 10, y: 22
		opacity: 0
	if rowEvents[i][j].x < serviceList.maxX and rowEvents[i][j].maxX > serviceList.maxX
		title.x = -( rowEvents[i][j].x - serviceList.maxX ) + cellLeftPadding
		title.width = rowEvents[i][j].maxX - serviceList.maxX - 14
		status.x = title.x

# 	secondLineText = new TextLayer
# 		parent:rowEvents[i][j]
# 		fontFamily:'GillSans-Light, GillSans-Light', fontSize:18, color:'#ebebeb'
# 		text:secondLine[i][j]
# 		x:title.x, index:2, y:42
# 		height:24, width:title.width - 10
# 		opacity: if i == 0 then secondLineOpacity else 0
# 		style:
# 			'display':'block'
# 			'display':'-webkit-box'
# 			'white-space':'nowrap'
# 			'word-break':'break-all'
# 			'overflow':'hidden'
# 			'-webkit-line-clamp':'1'
# 			'-webkit-box-orient':'vertical'
# 	secondLineText.visible = false if isVisible == 0

	return title

drawSeparator = ( isVisible, i, j ) ->
	separator = new Layer
		parent:rowEvents[i][j]
		width:2
		backgroundColor:youviewGrey2
		opacity:separatorOpacity
		height:cellHeight - 23
		x:-2
		y:12
		index:0
	return separator
filters = new Layer
	parent: header
	width:1280
	height:64
	y:162, index:6
	borderColor: 'transparent'
	backgroundColor: ''
filterContainer = new Layer
	parent: filters
	width:1280
	height:64
	backgroundColor: 'rgba(7, 15, 27, 0.88)'
for i in [0...filter.length]
	filterText = new TextLayer
		parent: filterContainer, name: filter[i], text: filter[i]
		autoSize:true
		x:138, y:24
		textTransform:"uppercase",fontFamily:"GillSans-Bold",fontSize:16, color: '#505359'
	if i == 0 
		filterText.color = '#ebebeb'
	filterLayer.push(filterText)
	filterLayer[i].x = (filterLayer[i-1].maxX + 40) if filterLayer[i-1]?
nowline = new Layer
	image:'images/nowline.png'
	x:460
	y:253
	width:99
	height:467
	index:6
filterDividerTop = new Layer
	parent:background
	image:'images/filter-divider.png'
	y:162, index:10
	height:2, width:1280
filterDividerBottom = new Layer
	parent:background
	y:226, index:10
	image:'images/filter-divider.png'
	height:2, width:1280
filterDividerBottom.states =
	show:
		opacity:1
	hide:
		opacity:0
extension = new Layer
	opacity:0, index:1

blackOverlay = new Layer
	width: 1280, height: 720
	backgroundColor: 'rgba(0,0,0,0.9)'
	index: 0

blueOverlay = new Layer
	parent:eventParent
	height:720, width:1280
	opacity:0.8
	index:1
	style:
		'background' : 'linear-gradient(to bottom, rgba(0, 166, 255, 0.4) 0%, rgba(0, 166, 255, 0.1) 100%)'
# 	style:
# 		'background' : '-webkit-linear-gradient( 270deg, rgba(255, 0, 0, 1) 0%, rgba(255, 255, 0, 1) 15%, rgba(0, 255, 0, 1) 30%, rgba(0, 255, 255, 1) 50%, rgba(0, 0, 255, 1) 65%, rgba(255, 0, 255, 1) 80%, rgba(255, 0, 0, 1) 100% )' 

#( 270deg, rgba( 0, 166, 255, 255 ) 0%, rgba( 0, 166, 255, 0 ) 100%  )

menuHighlight = new Layer
	parent:filters
	x:0
	width: 0
	height:2
	backgroundColor: youviewBlue

#10px wider
menuHighlightGlow = new Layer
	parent:menuHighlight
	width:0
	height:4
	blur:7
	backgroundColor: youviewBlue
menuHighlightGlow.bringToFront()

legend = new Layer
	image:'images/legend.png'
	maxY:Screen.height+20
	width:1280
	height:114
	opacity:0

showLegend = new Animation legend,
	opacity:1
	duration:0.5
	maxY:Screen.height

hideLegend = showLegend.reverse()

dumbVariable = 0



init = () ->
	fillRows()
	styleHighlight(1,0)
	fillDateTrack()
	captureKeys()
	blackOverlay.sendToBack()
	tvShow.sendToBack()
	nowline.bringToFront()
init()

Utils.interval 0.5, ->
	thisY = hY
	thisX = hX
	
	nowLineTimeout++
	if nowLineTimeout == 6
		nowline.x += 1
		nowLineTimeout = 0
	expansionTimeout = expansionTimeout + 1
	if expansionTimeout == 2 and thisY >= 0
		expansionCleverness(thisX,thisY)
	
	legendTimeout++
	if legendTimeout == 4
		showLegend.start()
Canvas.image = 'https://struanfraser.co.uk/images/youview-back.jpg'