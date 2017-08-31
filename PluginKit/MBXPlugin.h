#import <Foundation/Foundation.h>

@class MGLMapView;

@protocol MBXPlugin <NSObject>

- (void)addToMapView:(MGLMapView *)mapView;

- (void)removeFromMapView:(MGLMapView *)mapView;

@end
