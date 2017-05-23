#import "MapViewController.h"

#import <MapboxPluginKit/MapboxPluginKit.h>

@interface MapViewController ()

@end

@implementation MapViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.pluginClassNames) {
        for (NSString *className in self.pluginClassNames) {
            Class pluginClass = NSClassFromString(className);
            NSAssert(pluginClass, @"%@ not found!", className);
            NSAssert([pluginClass conformsToProtocol:@protocol(MBXPlugin)], @"%@ doesn’t conform to MBXPlugin!", className);
            id <MBXPlugin> plugin = [[pluginClass alloc] init];
            [plugin addToMapView:self.view];
        }
    }
}

#pragma mark - Managing the detail item

- (void)setPluginClassNames:(NSArray<NSString *> *)pluginClassNames {
    if (![_pluginClassNames isEqualToArray:pluginClassNames]) {
        _pluginClassNames = pluginClassNames;
        
        // Update the view.
        [self configureView];
    }
}

@end
