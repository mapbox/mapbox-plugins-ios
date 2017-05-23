#import <UIKit/UIKit.h>

NSString *DisplayNameForPluginClassName(NSString *pluginClassName);

@interface PluginTableViewController : UITableViewController

@property (copy) NSString *selectedClassName;

@end
