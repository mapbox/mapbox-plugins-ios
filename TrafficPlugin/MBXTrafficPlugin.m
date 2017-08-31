
#import "MBXTrafficPlugin.h"
@interface MBXTrafficPlugin ()

@property (nonatomic, retain) MGLVectorSource *source;
@property (nonatomic, retain) MGLStyleValue *trafficColor;
@property (nonatomic, retain) NSMutableArray *trafficLayerIdentifiers;
@end

@implementation MBXTrafficPlugin

// TODO: Add methods to insert traffic above layer. - Change layer group methods to have a placement parameter, then call them in the addToMapView above/below methods

// Default method to add traffic layers
- (void)addToMapView:(MGLMapView *)mapView {
    MGLSymbolStyleLayer *symbolLayer = [mapView.style layerWithIdentifier:@"poi-scalerank3"];
    
    [self addToMapView:mapView below:symbolLayer];
}

// Insert layers below a spec
- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)layer {
    // Add traffic source to map style.
    _source = [[MGLVectorSource alloc] initWithIdentifier:@"traffic-source" configurationURL:[NSURL URLWithString:@"mapbox://mapbox.mapbox-traffic-v1"]];
    [mapView.style addSource:_source];
    
    _trafficLayerIdentifiers = [NSMutableArray new];
    
    NSDictionary *stopsDictionary = @{
                                      @"low" : [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:88.0/255.0
                                                                                                green:195.0/255.0
                                                                                                 blue:35.0/255.0
                                                                                                alpha:1]],
                                      @"moderate" : [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:88.0/255.0
                                                                                                     green:195.0/255.0
                                                                                                      blue:35.0/255.0
                                                                                                     alpha:1]],
                                      @"heavy" : [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:242.0/255.0
                                                                                                  green:185.0/255.0
                                                                                                   blue:15.0/255.0
                                                                                                  alpha:1]],
                                      @"severe" : [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:204.0/255.0
                                                                                                   green:0
                                                                                                    blue:0
                                                                                                   alpha:1]]
                                      };
    _trafficColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeCategorical sourceStops:stopsDictionary attributeName:@"congestion" options:@{MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:[UIColor greenColor]]}];
    
    // Consolidate to one layer once lineWidth supports DDS.
    // TODO: JK - Rename these methods
    [self addMotorwayLayerTo:mapView below:layer];
    [self addPrimaryLayerTo:mapView below:layer];
    [self addStreetLayerTo:mapView below:layer];
}

// MARK: Individual layers
// Adds motorway, motorway-link, and trunk layer.
- (void)addMotorwayLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    
    MGLLineStyleLayer *motorwayLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"motorway-layer" source:_source];
    motorwayLayer.sourceLayerIdentifier = @"traffic";
    motorwayLayer.predicate = [NSPredicate predicateWithFormat:@"class IN %@", @[@"motorway", @"motorway-link", @"trunk"]];
    
    motorwayLayer.lineColor = _trafficColor;
    
    NSDictionary *motorwayLineWidthDictionary =  @{
                                                   @7 : [MGLStyleValue valueWithRawValue:@1],
                                                   @18 : [MGLStyleValue valueWithRawValue:@24]
                                                   };
    
    motorwayLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                            cameraStops:motorwayLineWidthDictionary
                                                                options:@{
                                                                          MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                          MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:motorwayLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:motorwayLayer.identifier];
}

// Adds primary, secondary, and tertiary road layer.
- (void)addPrimaryLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *primaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"primary-layer" source:_source];
    primaryLayer.sourceLayerIdentifier = @"traffic";
    primaryLayer.predicate = [NSPredicate predicateWithFormat:@"class IN %@", @[@"primary", @"secondary", @"tertiary"]];
    
    NSDictionary *primaryLineStopsDictionary = @{
                                               @11 : [MGLStyleValue valueWithRawValue:@1.25],
                                               @14 : [MGLStyleValue valueWithRawValue:@2.5],
                                               @17 : [MGLStyleValue valueWithRawValue:@5.5],
                                               @20 : [MGLStyleValue valueWithRawValue:@15.5]
                                               };
    
    primaryLayer.lineColor = _trafficColor;
    primaryLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                         cameraStops:primaryLineStopsDictionary
                                                             options:@{
                                                                       MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                       MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:primaryLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:primaryLayer.identifier];
}

// Adds street, service road, and link layer.
- (void)addStreetLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *streetLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"street-layer" source:_source];
    streetLayer.sourceLayerIdentifier = @"traffic";
    streetLayer.predicate = [NSPredicate predicateWithFormat:@"class IN { 'street', 'link', 'service' }"];
    
    NSDictionary *streetLineStopsDictionary = @{
                                                 @11 : [MGLStyleValue valueWithRawValue:@1],
                                                 @14 : [MGLStyleValue valueWithRawValue:@2],
                                                 @17 : [MGLStyleValue valueWithRawValue:@4],
                                                 @20 : [MGLStyleValue valueWithRawValue:@13.5]
                                                 };
    
    streetLayer.lineColor = _trafficColor;
    streetLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                           cameraStops:streetLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:streetLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:streetLayer.identifier];
}

// MARK: Traffic Layer Removal
- (void)removeFromMapView:(MGLMapView *)mapView {
    for (NSString *id in _trafficLayerIdentifiers) {
        MGLStyleLayer *layer = [mapView.style layerWithIdentifier:id];
        [mapView.style removeLayer:layer];
    }
    _trafficLayerIdentifiers = [NSMutableArray new];
}

@end
