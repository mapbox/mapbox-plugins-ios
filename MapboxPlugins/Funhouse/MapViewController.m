#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.pluginClassNames) {
        self.detailDescriptionLabel.text = [self.pluginClassNames componentsJoinedByString:@"+"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - Managing the detail item

- (void)setPluginClassNames:(NSArray<NSString *> *)pluginClassNames {
    if ([_pluginClassNames isEqualToArray:pluginClassNames]) {
        _pluginClassNames = pluginClassNames;
        
        // Update the view.
        [self configureView];
    }
}

@end
