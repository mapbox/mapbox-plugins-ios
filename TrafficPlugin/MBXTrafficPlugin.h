
#import "MapboxPluginKit.h"
#import <Foundation/Foundation.h>
@import Mapbox;

@interface MBXTrafficPlugin : NSObject <MBXPlugin>

- (void)addToMapView:(MGLMapView *)mapView;

- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)symbolLayer;

- (void)addToMapView:(MGLMapView *)mapView above:(MGLStyleLayer *)layer;

- (void)removeFromMapView:(MGLMapView *)mapView;
@end
