#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (strong, nonatomic) NSArray<NSString *> *pluginClassNames;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

