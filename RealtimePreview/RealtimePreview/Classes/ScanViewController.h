//
//  ScanViewController.h
//  VVPlayground
//
//  Created by isaced on 2018/2/7.
//

#import <UIKit/UIKit.h>

@protocol ScanViewControllerDelegate

- (void)scanViewController:(UIViewController *)scanViewController didScanContent:(NSString *)content;

@end

@interface ScanViewController : UIViewController

@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;

@end
