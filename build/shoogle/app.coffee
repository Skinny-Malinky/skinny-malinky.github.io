# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Get Jiggy Wid It"
	author: "Struan Fraser"
	twitter: "@struanfraser"
	description: "Keep on Jigglin'"

Screen.backgroundColor = '#282828'

fraser = new Layer
	width: 249
	height: 367
	image: "images/fraser.png"

fraser.center()

fraser.onMouseOver (event, layer) ->
	jiggle()

fraser.onMouseOut (event, layer) ->
	stopJiggling()

jiggle = () ->
	Utils.interval 0.1, ->
		fraser.x += Utils.randomNumber(-10, 10)
		fraser.y += Utils.randomNumber(-10, 10)

stopJiggling = () ->
	fraser.center()