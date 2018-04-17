//
//  SettingsViewController.h
//  VVPlayground
//
//  Created by isaced on 2018/2/9.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLFormViewController.h>

static NSString *const kSettingsRTLKey = @"kSettingsRTLKey";
static NSString *const kSettingsHotReloadKey = @"kSettingsHotReloadKey";

@interface SettingsViewController : XLFormViewController

+ (void)configSetValue:(NSObject *)value forKey:(NSString *)key;
+ (id)configValueForKey:(NSString *)key;

@end
