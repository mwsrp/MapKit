# MapKit
## Current Version: 0.0.5

New, new version of MapKit.

MapKit uses Apple Maps on iOS.

## Installation

Installation is done thru Cordova/PhoneGap CLI.

For Cordova:
```
$ cordova plugin rm no.hotdot.mapkit
$ cordova plugin add https://github.com/mwsrp/MapKit/MapKit.git
$ cordova run ios
```

MapKit uses the identifier `no.hotdot.mapkit`

## Usage

MapKit exposes itself thru the global object `MKInterface` that is attached to the `window` object.
This can be accessed globally as just `MKInterface`.

### Example
```
var map = new MKInterface.MKMap('testMap')  //Creates a new map with ID "testMap"
map.createMap()                             //Creates the MapView and shows it on the screen
map.setMapRegion({centerLat: 3.537499, centerLon: 72.933456, spanLat: 0.2, spanLon: 0.2, animated: false}); // Sets Visible Map Region
map.addMapPin({lat: 3.537499, lon: 72.933456, objectID: String(0)}); // Create A Single pin with objectID string, coalescing after each added pin.
map.fitMapToPins();                         // Resizes Map to Fit All Pins (More or Less...)
```

### Multi-Pin Example

```
var map = new MKInterface.MKMap('testMap')  //Creates a new map with ID "testMap"
map.createMap()                             //Creates the MapView and shows it on the screen
map.setMapRegion({centerLat: 3.537499, centerLon: 72.933456, spanLat: 0.2, spanLon: 0.2, animated: false}); // Sets Visible Map Region
map.addMapPins([{lat: 3.537499, lon: 72.933456, objectID: String(0)},
{lat: 3.537360, lon: 72.931085, objectID: String(1)},
{lat: 3.537522, lon: 72.932003, objectID: String(2)},
{lat: 3.537894, lon: 72.933211, objectID: String(3)},
{lat: 3.537011, lon: 72.930123, objectID: String(4)},
{lat: 3.537105, lon: 72.931930, objectID: String(5)},
{lat: 3.539102, lon: 72.931777, objectID: String(6)},
{lat: 3.535334, lon: 72.931555, objectID: String(7)},
{lat: 3.536500, lon: 72.931342, objectID: String(8)},
{lat: 3.537220, lon: 72.932500, objectID: String(9)}]); // Adds 10 pins to map, coalescing after all pins are added.
map.fitMapToPins();                         // Resizes Map to Fit All Pins (More or Less...)
```

If you are adding multiple pins, its best to use addMapPins since the coalescing algorithm runs only once for all the pins.

## License

MapKit is licensed under the HotDot Open Source License. [HotDot Open Source License](http://hotdot.no/hotdot_open-source_license.txt).

In short, you can use MapKit however you want both privately and commerically. You may modify and redistribute MapKit (or if you really want to just redistribute it). If you make useful changes or fix bugs reporting them here is appriciated, but not required.

You may earn 1$ by using it and be nice and credit me or become the next big app-hit and never mention my name (Though I would really appreciate if you do!).

## Credits

* [This MapKit Plugin](https://github.com/imhotep/MapKit) for inspiration (No code borrowed though)
* [Politikontroller](http://www.politikontroller.no) (A Norwegian app) Some of the time devoted to MapKit was done in hours I worked for them. They kindly let me keep all MapKit related code for all purposes.
* Caffeine.
* Uhm Victor Zimmer (Me) @ [HotDot](http://www.hotdot.no) (For making this thing I guess)

Just a few more I want to give a huge "Thank You"
* GitHub for this repo and their Mac Apps ([Atom Editor](https://atom.io) & [GitHub Desktop](https://desktop.github.com))
* [Brackets Editor](http://brackets.io)

_MapKit as a name is somewhat copied of Apple's name for their map integration, same applies to the 'MK'-prefix._

If there is anything I'd be happy to help. I can often be found on IRC #cordova @ irc.freenode.net
