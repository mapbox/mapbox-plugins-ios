
#import "MBXTrafficPlugin.h"
@interface MBXTrafficPlugin ()

@property (nonatomic, retain) MGLVectorSource *source;
@property (nonatomic, retain) MGLStyleValue const *trafficColor;
@property (nonatomic, retain) NSMutableArray *trafficLayerIdentifiers;
@end

@implementation MBXTrafficPlugin

// Default method to add traffic layers
- (void)addToMapView:(MGLMapView *)mapView {
    for (MGLStyleLayer *layer in mapView.style.layers.reverseObjectEnumerator) {
        if (![layer isKindOfClass:[MGLSymbolStyleLayer class]]) {
            [self addToMapView:mapView above:layer];
            break;
        }
    }
}

// Insert layers below a specific layer.
- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)layer {
    
    [self setupPropertiesFor:mapView];
    
    // Consolidate to one layer once lineWidth supports DDS.
    [self addMotorwayLayerTo:mapView below:YES style:layer];
    [self addPrimaryLayerTo:mapView below:YES style:layer];
    [self addStreetLayerTo:mapView below:YES style:layer];
    //
}

- (void)addToMapView:(MGLMapView *)mapView above:(MGLStyleLayer *)layer {
    [self setupPropertiesFor:mapView];
    
    // Consolidate to one layer once lineWidth supports DDS.
    [self addMotorwayLayerTo:mapView below:NO style:layer];
    [self addPrimaryLayerTo:mapView below:NO style:layer];
    [self addStreetLayerTo:mapView below:NO style:layer];
}

- (void) setupPropertiesFor:(MGLMapView *)mapView {
    // Add traffic source to map style.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
    });
}

// MARK: Add three traffic layers
// Adds motorway, motorway-link, and trunk layer.
- (void)addMotorwayLayerTo:(MGLMapView *)mapView below:(BOOL)below style:(MGLStyleLayer *)layer {
    
    MGLLineStyleLayer *motorwayLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"traffic-motorway-layer" source:_source];
    motorwayLayer.sourceLayerIdentifier = @"traffic";
    motorwayLayer.predicate = [NSPredicate predicateWithFormat:@"class IN {'motorway', 'motorway_link', 'trunk'}"];
    
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
    
    if (below) {
        [mapView.style insertLayer:motorwayLayer belowLayer:layer];
    } else {
        [mapView.style insertLayer:motorwayLayer aboveLayer:layer];
    }
    [_trafficLayerIdentifiers addObject:motorwayLayer.identifier];
}

// Adds primary, secondary, and tertiary road layer.
- (void)addPrimaryLayerTo:(MGLMapView *)mapView below:(BOOL)below style:(MGLStyleLayer *)layer {
    MGLLineStyleLayer *primaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"traffic-primary-layer" source:_source];
    primaryLayer.sourceLayerIdentifier = @"traffic";
    primaryLayer.predicate = [NSPredicate predicateWithFormat:@"class IN {'primary', 'secondary', 'tertiary'}"];
    
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
    
    if (below) {
        [mapView.style insertLayer:primaryLayer belowLayer:layer];
    } else {
        
        [mapView.style insertLayer:primaryLayer aboveLayer:layer];
    }
    [_trafficLayerIdentifiers addObject:primaryLayer.identifier];
}

// Adds street, service road, and link layer.
- (void)addStreetLayerTo:(MGLMapView *)mapView below:(BOOL)below style:(MGLStyleLayer *)layer {
    MGLLineStyleLayer *streetLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"traffic-street-layer" source:_source];
    streetLayer.sourceLayerIdentifier = @"traffic";
    streetLayer.predicate = [NSPredicate predicateWithFormat:@"class IN {'street', 'link', 'service'}"];
    
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
    if (below) {
        [mapView.style insertLayer:streetLayer belowLayer:layer];
    } else {
        [mapView.style insertLayer:streetLayer aboveLayer:layer];
    }
    [_trafficLayerIdentifiers addObject:streetLayer.identifier];
}

// MARK: Traffic Layer Removal
- (void)removeFromMapView:(MGLMapView *)mapView {
    for (NSString *identifier in _trafficLayerIdentifiers) {
        MGLStyleLayer *layer = [mapView.style layerWithIdentifier:identifier];
        [mapView.style removeLayer:layer];
    }
    _trafficLayerIdentifiers = [NSMutableArray new];
    
    //    NSArray *trafficLayers = [mapView.style.layers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sourceIdentifier == 'traffic-source'"]];
    //    for (MGLStyleLayer *layer in trafficLayers) { [mapView.style removeLayer:layer]; }
}

@end
