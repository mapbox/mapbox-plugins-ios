#import "MasterViewController.h"
#import "MapViewController.h"
#import "PluginTableViewController.h"
#import "AppDelegate.h"

#import <Mapbox/Mapbox.h>

@interface MasterViewController ()

@property NSMutableArray *pluginClassNames;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.mapViewController = (MapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.pluginClassNames = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    if (![MGLAccountManager accessToken].length) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Access Token" message:@"Enter your Mapbox access token to load Mapbox-hosted tiles and styles:" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeURL;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alertController.textFields.firstObject;
            NSString *accessToken = textField.text;
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:MBXMapboxAccessTokenDefaultsKey];
            [MGLAccountManager setAccessToken:accessToken];
        }];
        [alertController addAction:OKAction];
        
        if ([alertController respondsToSelector:@selector(setPreferredAction:)]) {
            alertController.preferredAction = OKAction;
        }
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController *controller = (MapViewController *)[[segue destinationViewController] topViewController];
        controller.pluginClassNames = self.pluginClassNames;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (IBAction)unwindToMasterViewController:(UIStoryboardSegue *)sender {
    if ([sender.identifier isEqualToString:@"selectPlugin"]) {
        PluginTableViewController *tableViewController = (PluginTableViewController *)sender.sourceViewController;
        if (tableViewController.selectedClassName && ![self.pluginClassNames containsObject:tableViewController.selectedClassName]) {
            [self.pluginClassNames addObject:tableViewController.selectedClassName];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pluginClassNames.count - 1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pluginClassNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = DisplayNameForPluginClassName(self.pluginClassNames[indexPath.row]);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.pluginClassNames removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.pluginClassNames exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

@end
