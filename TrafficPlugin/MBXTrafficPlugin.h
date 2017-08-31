
#import "MapboxPluginKit.h"
#import <Foundation/Foundation.h>
@import Mapbox;

@interface MBXTrafficPlugin : NSObject <MBXPlugin>


/**
 Add traffic to a MGLMapView. This method inserts the traffic layer below places of interest with a scale rank of 3 (POIs that either have a small area or are generally acknowledged to cover large areas, i.e. hospitals and universities). See the Mapbox Vector Tile Source layer reference (https://www.mThapbox.com/vector-tiles/mapbox-streets-v7/#layer-reference) for more information about vector tile layers.
 The earliest that this method can be called is in `-mapView:didFinishLoadingStyle:`

 @param mapView The map view that traffic will be displayed on.
 */
- (void)addToMapView:(MGLMapView *)mapView;

/**
 Insert the traffic layers below a specific layer that has already been added to your map’s style.
 
The earliest that this method can be called is in `-mapView:didFinishLoadingStyle:`

 @param mapView The map view that traffic will be displayed on.
 @param layer The style layer that traffic will be inserted below. Use the `layers` property on a style to verify layer identifiers.
 */
- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)layer;


/**
 <#Description#>

 @param mapView <#mapView description#>
 @param layer <#layer description#>
 */
- (void)addToMapView:(MGLMapView *)mapView above:(MGLStyleLayer *)layer;

/**
 Remove the traffic layers from your map view. The earliest that this method can be called is in `-mapView:didFinishLoadingStyle:`

 @param mapView The map view that traffic will be removed from.
 */
- (void)removeFromMapView:(MGLMapView *)mapView;
@end
