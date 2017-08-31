#import "MBXLocalizationPlugin.h"

#import "MGLVectorSource+MBXAdditions.h"

@implementation MBXLocalizationPlugin

- (void)addToMapView:(MGLMapView *)mapView {
    [self localizeMapView:mapView intoPreferredLanguage:[MGLVectorSource preferredMapboxStreetsLanguage]];
}

- (void)removeFromMapView:(MGLMapView *)mapView {
    [self localizeMapView:mapView intoPreferredLanguage:nil];
}

- (void)localizeMapView:(MGLMapView *)mapView intoPreferredLanguage:(NSString *)preferredLanguage {
    MGLStyle *style = mapView.style;
    NSMutableDictionary *localizedKeysByKeyBySourceIdentifier = [NSMutableDictionary dictionary];
    for (MGLSymbolStyleLayer *layer in style.layers) {
        if (![layer isKindOfClass:[MGLSymbolStyleLayer class]]) {
            continue;
        }
        
        MGLVectorSource *source = (MGLVectorSource *)[style sourceWithIdentifier:layer.sourceIdentifier];
        if (![source isKindOfClass:[MGLVectorSource class]] || !source.mapboxStreets) {
            continue;
        }
        
        NSDictionary *localizedKeysByKey = localizedKeysByKeyBySourceIdentifier[layer.sourceIdentifier];
        if (!localizedKeysByKey) {
            localizedKeysByKey = localizedKeysByKeyBySourceIdentifier[layer.sourceIdentifier] = [source localizedKeysByKeyForPreferredLanguage:preferredLanguage];
        }
        
        NSString *(^stringByLocalizingString)(NSString *) = ^ NSString * (NSString *string) {
            NSMutableString *localizedString = string.mutableCopy;
            [localizedKeysByKey enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull localizedKey, BOOL * _Nonnull stop) {
                NSAssert([key isKindOfClass:[NSString class]], @"key is not a string");
                NSAssert([localizedKey isKindOfClass:[NSString class]], @"localizedKey is not a string");
                [localizedString replaceOccurrencesOfString:[NSString stringWithFormat:@"{%@}", key]
                                                 withString:[NSString stringWithFormat:@"{%@}", localizedKey]
                                                    options:0
                                                      range:NSMakeRange(0, localizedString.length)];
            }];
            return localizedString;
        };
        
        if ([layer.text isKindOfClass:[MGLConstantStyleValue class]]) {
            NSString *textField = [(MGLConstantStyleValue<NSString *> *)layer.text rawValue];
            layer.text = [MGLStyleValue<NSString *> valueWithRawValue:stringByLocalizingString(textField)];
        }
        else if ([layer.text isKindOfClass:[MGLCameraStyleFunction class]]) {
            MGLCameraStyleFunction *function = (MGLCameraStyleFunction<NSString *> *)layer.text;
            NSMutableDictionary *stops = function.stops.mutableCopy;
            [stops enumerateKeysAndObjectsUsingBlock:^(NSNumber *zoomLevel, MGLConstantStyleValue<NSString *> *stop, BOOL *done) {
                NSString *textField = stop.rawValue;
                stops[zoomLevel] = [MGLStyleValue<NSString *> valueWithRawValue:stringByLocalizingString(textField)];
            }];
            function.stops = stops;
            layer.text = function;
        }
    }
}

@end
