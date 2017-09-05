# mapbox-plugins-ios
Experimental plugins to supercharge your maps ⚡️

## Installing Plugins

There are main three ways to install Mapbox Maps Plugins:

1. CocoaPods
  To install all Mapbox Maps Plugins, add the following to your Podfile:
  `pod MapboxMapsPlugins`
  To install the Mapbox Traffic Plugin, add
  `pod MapboxMapsPlugins/Traffic`
  Note that the CocoaPod does include Mapbox iOS SDK v3.6.x as a dependency, and should update to the latest patch release of v3.6 when you run `pod update`.
2. Carthage 🤷
3. If you prefer not to use either Carthage or CocoaPods, copy the files for the plugin that you would like to use into your project. You will need to use a bridging header if your project is written in Swift.

## Using Test App

Test out Mapbox Maps Plugins in the TestApp.

1.  Run `carthage bootstrap` to install the Mapbox iOS SDK.

2. Create a text file called `mapbox_access_token` and add your [Mapbox Access token](https://www.mapbox.com/help/how-access-tokens-work/) to it.

## Getting Started with the Traffic Plugin

Once you have added the plugins library to your project, import it to your project. The traffic layers will start to become visible at zoom level 10.

Because these methods use the Runtime Styling API, the earliest that they can be called is in `[-mapView:didFinishLoadingStyle:](https://www.mapbox.com/ios-sdk/api/3.6.2/Protocols/MGLMapViewDelegate.html#/c:objc(pl)MGLMapViewDelegate(im)mapView:didFinishLoadingStyle:)`.

    - (void)addToMapView:(MGLMapView *)mapView;

Add traffic to a MGLMapView. This method inserts the traffic layer below places of interest with a scale rank of 3 (POIs that either have a small area or are generally acknowledged to cover large areas, i.e. hospitals and universities). See the [Mapbox Vector Tile Source layer reference](https://www.mapbox.com/vector-tiles/mapbox-streets-v7/#layer-reference) for more information about vector tile layers.

    - (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)symbolLayer;

Insert the traffic layers below a specific layer that has already been added to your map’s style.

    - (void)removeFromMapView:(MGLMapView *)mapView;

Removes all traffic layers from the map.


## Examples

### Swift
```swift
    import Mapbox
    import MapboxMapsPlugins

    class ViewController: UIViewController, MGLMapViewDelegate {

        override func viewDidLoad() {
            super.viewDidLoad()

            // This example is pinned to a style version because it accesses underlying style data.
            let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
            mapView.setCenter(CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), zoomLevel: 11, animated: false)
            mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(mapView)
            mapView.delegate = self
        }

        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            let traffic = MBXTrafficPlugin()
            traffic.add(to: mapView)

            // Removes the traffic layers after 10 seconds.
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                traffic.remove(from: mapView)
            })
        }
    }
```

### Objective-C

```objc
#import "ViewController.h"
#import <MapboxMapsPlugins/MBXTrafficPlugin.h>

@interface ViewController () <MGLMapViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame: self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    [mapView setCenterCoordinate: CLLocationCoordinate2DMake(39.9612, -82.9988) zoomLevel:11 animated:NO];
    mapView.delegate = self;
    [self.view addSubview: mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    MBXTrafficPlugin *traffic = [[MBXTrafficPlugin alloc] init];
    [traffic addToMapView:mapView];
}
```
