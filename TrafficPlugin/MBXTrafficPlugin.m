
#import "MBXTrafficPlugin.h"
@interface MBXTrafficPlugin ()

@property (nonatomic, retain) MGLVectorSource *source;
@property (nonatomic, retain) MGLStyleValue *trafficColor;

@end

@implementation MBXTrafficPlugin

// TODO: Break up into layers based on class.
// TODO: Add a method so users can select which layer this is inserted under.
- (void)addToMapView:(MGLMapView *)mapView {
    
    // Add traffic source to map style.
    _source = [[MGLVectorSource alloc] initWithIdentifier:@"traffic-source" configurationURL:[NSURL URLWithString:@"mapbox://mapbox.mapbox-traffic-v1"]];
    [mapView.style addSource:_source];
    
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
    
    // TODO: Allow user to set which layer it is inserted under.
    MGLSymbolStyleLayer *symbolLayer = [mapView.style layerWithIdentifier:@"poi-scalerank3"];
    
    // Consolidate to one layer once lineWidth supports DDS.
    [self addMotorwayLinkLayerTo:mapView below:symbolLayer];
    [self addMotorwayLayerTo:mapView below:symbolLayer];
    [self addTrunkLayerTo:mapView below:symbolLayer];
    [self addPrimaryLayerTo:mapView below:symbolLayer];
    [self addSecondaryLayerTo:mapView below:symbolLayer];
    [self addTertiaryLayerTo:mapView below:symbolLayer];
    [self addLinkLayerTo:mapView below:symbolLayer];
    [self addStreetLayerTo:mapView below:symbolLayer];
    [self addServiceLayerTo:mapView below:symbolLayer];
    
}

// MARK: Individual layers

- (void)addMotorwayLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
    
    MGLLineStyleLayer *motorwayLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"motorway-layer" source:_source];
    motorwayLayer.sourceLayerIdentifier = @"traffic";
    motorwayLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'motorway'"];
    
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
    [mapView.style insertLayer:motorwayLayer belowLayer:symbolLayer];
}

- (void)addMotorwayLinkLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer {
    NSDictionary *motorwayLinkLineWidthDictionary = @{
                                                      @7 : [MGLStyleValue valueWithRawValue:@1],
                                                      @18 : [MGLStyleValue valueWithRawValue:@24]
                                                      };
    MGLLineStyleLayer *motorwayLinkLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"motorway-link-layer" source:_source];
    motorwayLinkLayer.sourceLayerIdentifier = @"traffic";
    motorwayLinkLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'motorway_link'"];
    motorwayLinkLayer.lineColor = _trafficColor;
    motorwayLinkLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential
                                                                cameraStops:motorwayLinkLineWidthDictionary
                                                                    options: @{
                                                                               MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                               MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:motorwayLinkLayer belowLayer:symbolLayer];
    
}

- (void)addTrunkLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
    MGLLineStyleLayer *trunkLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"trunk-layer" source:_source];
    trunkLayer.sourceLayerIdentifier = @"traffic";
    trunkLayer.predicate = [NSPredicate predicateWithFormat:@"class == 'trunk'"];
    
    NSDictionary *trunkLineStopsDictionary = @{
                                               @7 : [MGLStyleValue valueWithRawValue:@1],
                                               @18 : [MGLStyleValue valueWithRawValue:@24]
                                               };
    
    trunkLayer.lineColor = _trafficColor;
    trunkLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode: MGLInterpolationModeExponential
                                                         cameraStops:trunkLineStopsDictionary
                                                             options:@{
                                                                       MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                       MGLStyleFunctionOptionInterpolationBase : @1.5}];
    [mapView.style insertLayer:trunkLayer belowLayer:symbolLayer];
}

- (void)addPrimaryLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:primaryLayer belowLayer:symbolLayer];
}

- (void)addSecondaryLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:secondaryLayer belowLayer:symbolLayer];
}

- (void)addTertiaryLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:tertiaryLayer belowLayer:symbolLayer];
}

- (void)addLinkLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:linkLayer belowLayer:symbolLayer];
}

- (void)addStreetLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:streetLayer belowLayer:symbolLayer];
}

- (void)addServiceLayerTo:(MGLMapView *)mapView below:(MGLSymbolStyleLayer *)symbolLayer  {
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
    [mapView.style insertLayer:serviceLayer belowLayer:symbolLayer];
}
// MARK: Traffic Layer Removal
- (void)removeFromMapView:(MGLMapView *)mapView {
    
}


@end
