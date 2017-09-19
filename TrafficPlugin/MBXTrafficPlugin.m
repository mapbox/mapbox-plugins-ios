
#import "MBXTrafficPlugin.h"

static MGLStyleValue *_trafficColor;

@interface MBXTrafficPlugin ()

@property (nonatomic) MGLVectorSource *source;
@property (nonatomic) NSString *bundleIdentifier;
@end

@implementation MBXTrafficPlugin

// Default method to add traffic layers.
- (void)addToMapView:(MGLMapView *)mapView {
    for (MGLStyleLayer *layer in mapView.style.layers.reverseObjectEnumerator) {
        if (![layer isKindOfClass:[MGLSymbolStyleLayer class]]) {
            [self addToMapView:mapView above:layer];
            break;
        }
    }
}

// Insert layers below a specific layer.
// TODO: Consolidate to one layer once lineWidth supports DDS.
- (void)addToMapView:(MGLMapView *)mapView below:(MGLStyleLayer *)layer {
    
    [self setupPropertiesFor:mapView];
    
    [mapView.style insertLayer:[self styleMotorwayLayer] belowLayer:layer];
    [mapView.style insertLayer:[self stylePrimaryLayer] belowLayer:layer];
    [mapView.style insertLayer:[self styleStreetLayer] belowLayer:layer];
}

- (void)addToMapView:(MGLMapView *)mapView above:(MGLStyleLayer *)layer {
    [self setupPropertiesFor:mapView];
    
    [mapView.style insertLayer:[self styleMotorwayLayer] aboveLayer:layer];
    [mapView.style insertLayer:[self stylePrimaryLayer] aboveLayer:layer];
    [mapView.style insertLayer:[self styleStreetLayer] aboveLayer:layer];
}

- (void) setupPropertiesFor:(MGLMapView *)mapView {
    // Add traffic source to map style.
    if (_source == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[MBXTrafficPlugin class]];
        _bundleIdentifier = [bundle bundleIdentifier];
        NSString *sourceIdentifier = [NSString stringWithFormat:@"%@-traffic-source", _bundleIdentifier];
        _source = [[MGLVectorSource alloc] initWithIdentifier:sourceIdentifier configurationURL:[NSURL URLWithString:@"mapbox://mapbox.mapbox-traffic-v1"]];
        [mapView.style addSource:_source];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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

// MARK: Style three traffic layers.
// Styles the motorway, motorway_link, and trunk layer.
- (MGLStyleLayer *)styleMotorwayLayer {
    MGLLineStyleLayer *motorwayLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-traffic-motorway-layer", _bundleIdentifier] source:_source];
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
    
    return motorwayLayer;
}

// Styles the primary, secondary, and tertiary road layer.
- (MGLStyleLayer *)stylePrimaryLayer {
    MGLLineStyleLayer *primaryLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-traffic-primary-layer", _bundleIdentifier] source:_source];
    primaryLayer.sourceLayerIdentifier = @"traffic";
    primaryLayer.predicate = [NSPredicate predicateWithFormat:@"class IN {'primary', 'secondary', 'tertiary'}"];
    
    NSDictionary *primaryLineStopsDictionary = @{
                                                 @11 : [MGLStyleValue valueWithRawValue:@1.25],
                                                 @14 : [MGLStyleValue valueWithRawValue:@2.5],
                                                 @17 : [MGLStyleValue valueWithRawValue:@5.5],
                                                 @20 : [MGLStyleValue valueWithRawValue:@15.5]
                                                 };
    
    primaryLayer.lineColor = _trafficColor;
    primaryLayer.lineWidth = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential
                                                           cameraStops:primaryLineStopsDictionary
                                                               options:@{
                                                                         MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:@3],
                                                                         MGLStyleFunctionOptionInterpolationBase : @1.5}];

    return primaryLayer;
}

// Styles the street, service road, and link layer.
- (MGLStyleLayer *)styleStreetLayer {
    MGLLineStyleLayer *streetLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"%@-traffic-street-layer", _bundleIdentifier] source:_source];
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
    
    return streetLayer;
}

// MARK: Traffic Layer Removal
- (void)removeFromMapView:(MGLMapView *)mapView {
    NSString *sourceIdentifier = [NSString stringWithFormat:@"%@-traffic-source", _bundleIdentifier];
    for (MGLStyleLayer *layer in mapView.style.layers) if ([layer isKindOfClass:[MGLLineStyleLayer class]] && [((MGLLineStyleLayer *)layer).sourceIdentifier isEqualToString:sourceIdentifier]) {
        [mapView.style removeLayer:layer];
    }
    
}

@end

