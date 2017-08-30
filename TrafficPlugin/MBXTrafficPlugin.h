
#import "MapboxPluginKit.h"
#import <Foundation/Foundation.h>
@import Mapbox;

@interface MBXTrafficPlugin : NSObject <MBXPlugin>

- (void)addToMapView:(MGLMapView *)mapView;

@end
