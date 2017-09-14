#import "MapViewController.h"

#import "MapboxPluginKit.h"
#import <Mapbox/Mapbox.h>

@interface MapViewController () <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;

@end

@implementation MapViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.pluginClassNames) {
        NSMutableArray<id <MBXPlugin>> *plugins = [NSMutableArray arrayWithCapacity:self.pluginClassNames.count];
        for (NSString *className in self.pluginClassNames) {
            Class pluginClass = NSClassFromString(className);
            NSAssert(pluginClass, @"%@ not found!", className);
            NSAssert([pluginClass conformsToProtocol:@protocol(MBXPlugin)], @"%@ doesn’t conform to MBXPlugin!", className);
            id <MBXPlugin> plugin = [[pluginClass alloc] init];
            [plugins addObject:plugin];
        }
        
        for (id <MBXPlugin> plugin in plugins) {
            [plugin removeFromMapView:self.mapView];
        }
        for (id <MBXPlugin> plugin in plugins) {
            [plugin addToMapView:self.mapView];
        }
    }
}

#pragma mark - UIStateRestoring methods

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.mapView.camera forKey:@"camera"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    self.mapView.camera = [coder decodeObjectForKey:@"camera"];
}

#pragma mark - MGLMapViewDelegate methods

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self configureView];
}

@end
