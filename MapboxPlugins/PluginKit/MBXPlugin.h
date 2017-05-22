#import <Foundation/Foundation.h>

@protocol MBXPlugin <NSObject>

- (void)addToMapView:(UIView *)view;

- (void)removeFromMapView:(UIView *)view;

@end
