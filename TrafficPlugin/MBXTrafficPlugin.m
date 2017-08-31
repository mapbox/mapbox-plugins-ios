
#import "MBXTrafficPlugin.h"
@interface MBXTrafficPlugin ()

@property (nonatomic, retain) MGLVectorSource *source;
@property (nonatomic, retain) MGLStyleValue *trafficColor;
@property (nonatomic, retain) NSMutableArray *trafficLayerIdentifiers;
@end

@implementation MBXTrafficPlugin

// TODO: Break up into layers based on class.
// TODO: Add a method so users can select which layer this is inserted under.

// Default method to add traffic layers
- (void)addToMapView:(MGLMapView *)mapView {
    
    // TODO: Allow user to set which layer it is inserted under.
    MGLSymbolStyleLayer *symbolLayer = [mapView.style layerWithIdentifier:@"poi-scalerank3"];
    
    [self addToMapView:mapView below:symbolLayer];
    
}

// Insert layers below a spec
- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)layer {
    // Add traffic source to map style.
    _source = [[MGLVectorSource alloc] initWithIdentifier:@"traffic-source" configurationURL:[NSURL URLWithString:@"mapbox://mapbox.mapbox-traffic-v1"]];
    [mapView.style addSource:_source];
    
    _trafficLayerIdentifiers = [NSMutableArray new];
    
    // TODO: Set line width based on road type.
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
    // JK - Can I consolidate these methods? Need to adapt lineWidth for different layers.
    [self addMotorwayLayerTo:mapView below:layer];
    [self addPrimaryLayerTo:mapView below:layer];
    [self addSecondaryLayerTo:mapView below:layer];
    [self addTertiaryLayerTo:mapView below:layer];
    [self addLinkLayerTo:mapView below:layer];
    [self addStreetLayerTo:mapView below:layer];
    [self addServiceLayerTo:mapView below:layer];
}

// MARK: Individual layers
// Adds motorway, motorway-link, and trunk layer
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

- (void)addPrimaryLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *primaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"primary-layer" source:_source];
    primaryLayer.sourceLayerIdentifier = @"traffic";
    primaryLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'primary'"];
    
    NSDictionary *primaryLineStopsDictionary = @{
                                               @7 : [MGLStyleValue valueWithRawValue:@1],
                                               @18 : [MGLStyleValue valueWithRawValue:@24]
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

- (void)addSecondaryLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *secondaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"secondary-layer" source:_source];
    secondaryLayer.sourceLayerIdentifier = @"traffic";
    secondaryLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'secondary'"];
    
    NSDictionary *secondaryLineStopsDictionary = @{
                                                 @7 : [MGLStyleValue valueWithRawValue:@1],
                                                 @18 : [MGLStyleValue valueWithRawValue:@24]
                                                 };
    
    secondaryLayer.lineColor = _trafficColor;
    
    //TODO: Adjust line width.
    secondaryLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                           cameraStops:secondaryLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:secondaryLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:secondaryLayer.identifier];
}

- (void)addTertiaryLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *tertiaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"tertiary-layer" source:_source];
    tertiaryLayer.sourceLayerIdentifier = @"traffic";
    tertiaryLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'tertiary'"];
    
    NSDictionary *tertiaryLineStopsDictionary = @{
                                                 @7 : [MGLStyleValue valueWithRawValue:@1],
                                                 @18 : [MGLStyleValue valueWithRawValue:@24]
                                                 };
    
    tertiaryLayer.lineColor = _trafficColor;
    tertiaryLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                           cameraStops:tertiaryLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:tertiaryLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:tertiaryLayer.identifier];
}

- (void)addLinkLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *linkLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"link-layer" source:_source];
    linkLayer.sourceLayerIdentifier = @"traffic";
    linkLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'link'"];
    
    NSDictionary *linkLineStopsDictionary = @{
                                                 @7 : [MGLStyleValue valueWithRawValue:@1],
                                                 @18 : [MGLStyleValue valueWithRawValue:@24]
                                                 };
    
    linkLayer.lineColor = _trafficColor;
    linkLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                           cameraStops:linkLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:linkLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:linkLayer.identifier];
}

- (void)addStreetLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *streetLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"street-layer" source:_source];
    streetLayer.sourceLayerIdentifier = @"traffic";
    streetLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'street'"];
    
    NSDictionary *streetLineStopsDictionary = @{
                                                 @7 : [MGLStyleValue valueWithRawValue:@1],
                                                 @18 : [MGLStyleValue valueWithRawValue:@24]
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

- (void)addServiceLayerTo:(MGLMapView *)mapView below:(MGLStyleLayer *)layer  {
    MGLLineStyleLayer *serviceLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"service-layer" source:_source];
    serviceLayer.sourceLayerIdentifier = @"traffic";
    serviceLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'service'"];
    
    NSDictionary *serviceLineStopsDictionary = @{
                                                 @7 : [MGLStyleValue valueWithRawValue:@1],
                                                 @18 : [MGLStyleValue valueWithRawValue:@24]
                                                 };
    
    serviceLayer.lineColor = _trafficColor;
    serviceLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                           cameraStops:serviceLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:serviceLayer belowLayer:layer];
    [_trafficLayerIdentifiers addObject:serviceLayer.identifier];
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
