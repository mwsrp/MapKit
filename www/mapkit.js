Number.isFinite = Number.isFinite || function(value) {
    return typeof value === "number" && isFinite(value);
}

var cordovaRef = window.PhoneGap || window.Cordova || window.cordova || window.phonegap;

var MapArray = ['nullProtector']
var MapDict = {}

var that;

function isPlainObject(o) {
   return ((o === null) || Array.isArray(o) || typeof o == 'function') ?
           false
          :(typeof o == 'object');
}

var MKPin = function (map, lat, lon, objectID) {
  this.map = map
  this.lat = lat
  this.lon = lon
  this.objectID = objectID
  this.execSuccess = function (data) {
    console.log("#MKPin(${that.title}) Executed native command successfully")
    console.log(data)
  }
  this.execFailure = function (err) {
    console.warn("#MKPin(${that.title}) MapKit failed to execute native command:")
    console.warn(err)
  }
  this.createPin = function () {
    that = this
    console.log("Creating pin: ${[this.map.mapArrayId, this.lat, this.lon, this.title, this.description].join(" - ")}")
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'consoleLog', 'CreatePin')
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'addMapPin', [this.map.mapArrayId, this.lat, this.lon, this.objectID])
  }
  this.createPinArray = function () {
    return [this.lat, this.lon, this.objectID]
  }
}

var MKMap = function (mapId) {
  if (mapId != undefined)
  {
    this.mapId = mapId
  }
  else
  {
    this.mapId = "map_" + MapArray.length
  }

  if (MapDict[this.mapId] != undefined)
  {
    MapDict[this.mapId].destroyMap()
  }

  MapDict[this.mapId] = this;
  this.mapArrayId = MapArray.push(this) - 1

  this.created = false
  this.destroyed = false
  this.options = {}
  this.options.xPos = 0
  this.options.yPos = 0
  this.options.height = window.innerHeight || 100
  this.options.width = window.innerWidth || 100
  this.options.mapScale = false
  this.options.mapTraffic = false
  this.options.mapCompass = false
  this.options.mapBuildings = false
  this.options.mapPointsOfInterest = true
  this.options.mapUserLocation = false
  this.getCenterCallback = function () { console.warn("Get map center called without valid callback!") }
  this.PinsArray = []
  this.Pins = {}
  this.setBounds = function (data) {
    if (Number.isFinite(arguments[0]) && Number.isFinite(arguments[1]))
    {
      height = arguments[0]
      width = arguments[1]
    }
    else if (data.height != undefined || data.width != undefined) {
      height = data.height
      width = data.width
    }
    else {
      console.warn("#MKMap(" + this.mapId + ") setBounds was called with neither object nor numeric values")
      return "ERR_INVALID_VALUES"
    }

    if (this.created)
    {
      if (height != null && width != null)
      {
        this.options.height = height
        this.options.width = width
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapBounds', [this.mapArrayId, height, width])
      }
      else if (height != null) {
        this.options.height = height
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapHeight', [this.mapArrayId, height])
      }
      else if (width != null) {
        this.options.width = width
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapWidth', [this.mapArrayId, width])
      }
      else {
        console.warn("#MKMAP(" + this.mapId + ") setBounds called with null-like parameters")
      }
    }
    else
    {
      if (height == null && width == null)
      {
        console.warn("#MKMAP(" + this.mapId + ") setBounds called with null-like parameters")
      }
      this.options.height = height || this.options.height
      this.options.width = width || this.options.width
    }
  }
  this.setPosition = function (data) {
    if (Number.isFinite(arguments[0]) && Number.isFinite(arguments[1]))
    {
      xPos = arguments[0]
      yPos = arguments[1]
    }
    else if (data.height != undefined || data.width != undefined) {
      height = data.height
      width = data.width
    }
    else {
      console.warn("#MKMap(" + this.mapId + ") setPosition was called with neither object nor numeric values")
      return "ERR_INVALID_VALUES"
    }

    if (this.created)
    {
      if (xPos != null && yPos != null)
      {
        this.options.xPos = xPos
        this.options.yPos = yPos
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapPosition', [this.mapArrayId, xPos, yPos])
      }
      else if (xPos != null) {
        this.options.xPos = xPos
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapXPos', [this.mapArrayId, xPos])
      }
      else if (yPos != null) {
        this.options.yPos = yPos
        that = this
        cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'changeMapYPos', [this.mapArrayId, yPos])
      }
      else {
        console.warn("#MKMAP(" + this.mapId + ") setPosition called with null-like parameters")
      }
    }
    else
    {
      if (xPos == null && yPos == null)
      {
        console.warn("#MKMAP(" + this.mapId + ") setPosition called with null-like parameters")
      }
      this.options.xPos = xPos || this.options.xPos
      this.options.yPos = yPos || this.options.yPos
    }
  }
  this.execSuccess = function (data) {
    console.log("#MKMap(" + that.mapId + ") Executed native command successfully")
    console.log(data)
  }
  this.execFailure = function (err) {
    console.warn("#MKMap(" + that.mapId + ") MapKit failed to execute native command:")
    console.warn(err)
  }
  this.createMap = function (c) {
    if (!this.created)
    {
      console.log("#MKMap(" + this.mapId + ") Creating map")
      this.created = true
      that = this
      cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'createMapView', [this.mapArrayId, this.options.height, this.options.width, this.options.xPos, this.options.yPos])
    }
  }
  this.destroyMap = function () {
    if (!this.destroyed)
    {
      console.log("#MKMap(" + this.mapId + ") Destroying map")
      this.destroyed = true
      that = this
      cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'removeMapView', [this.mapArrayId])
    }
  }
  this.showMap = function () {
    console.log("#MKMap(" + this.mapId + ") Showing map")
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapView', [this.mapArrayId])
  }
  this.hideMap = function () {
    console.log("#MKMap(" + this.mapId + ") Hiding map")
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapView', [this.mapArrayId])
  }

  this.showMapScale = function () {
    this.options.mapScale = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapScale', [this.mapArrayId])
  }
  this.hideMapScale = function () {
    this.options.mapScale = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapScale', [this.mapArrayId])
  }

  this.showMapCompass = function () {
    if (!this.locationManager.canUseLocation)
    {
      console.warn("Attempt was made to use Location#Compass without system location access. MapKit will automatically attempt to ask for WhenInUse authorization.")
      this.locationManager.requestLocationWhenInUsePermission()
    }
    this.options.mapCompass = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapCompass', [this.mapArrayId])
  }
  this.hideMapCompass = function () {
    this.options.mapCompass = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapCompass', [this.mapArrayId])
  }

  this.showMapTraffic = function () {
    this.options.mapTraffic = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapTraffic', [this.mapArrayId])
  }
  this.hideMapTraffic = function () {
    this.options.mapTraffic = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapTraffic', [this.mapArrayId])
  }

  this.showMapBuildings = function () {
    this.options.mapBuildings = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapBuildings', [this.mapArrayId])
  }
  this.hideMapBuildings = function () {
    this.options.mapBuildings = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapBuildings', [this.mapArrayId])
  }

  this.showMapUserLocation = function () {
    if (!this.locationManager.canUseLocation)
    {
      console.warn("Attempt was made to use Location#UserLocation without system location access. MapKit will automatically attempt to ask for WhenInUse authorization.")
      this.locationManager.requestLocationWhenInUsePermission()
    }
    this.options.mapUserLocation = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapUserLocation', [this.mapArrayId])
  }
  this.hideMapUserLocation = function () {
    this.options.mapUserLocation = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapUserLocation', [this.mapArrayId])
  }
  this.userLocationVisible = function (callback) {
    cordovaRef.exec(callback, this.execFailure, 'MapKit', 'isShowingUserLocation', [this.mapArrayId])
  }

  this.showMapPointsOfInterest = function () {
    this.options.mapPointsOfInterest = true
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'showMapPointsOfInterest', [this.mapArrayId])
  }
  this.hideMapPointsOfInterest = function () {
    this.options.mapPointsOfInterest = false
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'hideMapPointsOfInterest', [this.mapArrayId])
  }
  this.setMapCenter = function (data) {
    that = this
    centerLat = data.centerLat || 1
    centerLon = data.centerLon || 1
    animated = data.animated !== false

    cordova.exec(this.execSuccess, this.execFailure, 'MapKit', 'setMapCenter', [this.mapArrayId, centerLat, centerLon, animated])
  }
  this.setMapRegion = function (data) {
    that = this
    centerLat = data.centerLat || 1
    centerLon = data.centerLon || 1
    spanLat = data.spanLat || 1
    spanLon = data.spanLon || 1
    animated = data.animated !== false

    cordova.exec(this.execSuccess, this.execFailure, 'MapKit', 'setMapRegion', [this.mapArrayId, centerLat, centerLon, spanLat, spanLon, animated])
  }

  this.setMapOpacity = function (opacity) {
    that = this
    cordova.exec(this.execSuccess, this.execFailure, 'MapKit', 'setMapOpacity', [this.mapArrayId, opacity])
  }

  this.addMapPin = function (data) {
    console.log(isPlainObject(data))
      lat = 0.0
      lon = 0.0
      objectID = 0
    if (data != undefined && isPlainObject(data))
    {
      lat = data.lat
      lon = data.lon
      objectID = data.objectID
    }
    else
    {
      lat = arguments[0]
      lon = arguments[1]
      objectID = arguments[2]
    }
    if (this.Pins[title] != undefined)
    {
      this.Pins[title].removePin()
    }
    Pin = new MKPin(this, lat, lon, objectID)
    this.Pins[title] = Pin
    this.PinsArray.push(Pin)
    Pin.createPin()
  }
  this.addMapPins = function (pinArr) {
    PinsToAdd = []
    for (var i in pinArr)
    {
      pin = pinArr[i]
      lat = pin.lat || 58
      lon = pin.lon || 11
      objectID = pin.objectID

      if (this.Pins[title] != undefined)
      {
        this.Pins[title].removePin()
      }
      Pin = new MKPin(this, lat, lon, objectID)
      this.Pins[title] = Pin
      this.PinsArray.push(Pin)

      PinsToAdd.push(Pin.createPinArray())
    }
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'addMapPins', [this.mapArrayId, PinsToAdd])
  }
  this.removeAllMapPins = function () {
    that = this
    cordovaRef.exec(this.execSuccess, this.execFailure, 'MapKit', 'removeAllMapPins', [this.mapArrayId])
  }
}

function handlePinInfoClickCallback(mapId, title)
{
  console.log("Got info click on Map: ${parseInt(mapId)} on Pin: ${title}")
  Pin = MapArray[parseInt(mapId)].Pins[title]
  Pin.infoClickCallback(Pin)
}

function handlePinClickCallback(mapId, title)
{
  console.log("Got pin click on Map: ${parseInt(mapId)} on Pin: ${title}")
  Pin = MapArray[parseInt(mapId)].Pins[title]
  Pin.pinClickCallback(Pin)
}

window.MKInterface = {}
window.MKInterface.MKMap = MKMap
window.MKInterface.getMapByArrayId = function (aid) { return MapArray[aid] }
window.MKInterface.getMapByMapId = function (mid) { return MapDict[mid] }
window.MKInterface.__objc__ = {}
window.MKInterface.__objc__.pinInfoClickCallback = handlePinInfoClickCallback
window.MKInterface.__objc__.pinClickCallback = handlePinClickCallback
