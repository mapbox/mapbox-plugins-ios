#import "MBXLocalizationPlugin.h"

@implementation MBXLocalizationPlugin

- (void)addToMapView:(UIView *)view {
    NSLog(@"Adding %@ to %@", self, view);
}

- (void)removeFromMapView:(UIView *)view {
    NSLog(@"Removing %@ from %@", self, view);
}

@end
