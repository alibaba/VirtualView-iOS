//
//  SettingsViewController.m
//  VVPlayground
//
//  Created by isaced on 2018/2/9.
//

#import "SettingsViewController.h"
#import "XLForm.h"
#import "AppDelegate.h"
#import "HotReloadService.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Settings"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor * hotReloadRTL = [XLFormRowDescriptor formRowDescriptorWithTag:@"HotReload" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"List HotReload"];
    hotReloadRTL.value = [SettingsViewController configValueForKey:kSettingsHotReloadKey];
    hotReloadRTL.onChangeBlock = ^(id  _Nullable oldValue, id  _Nullable newValue, XLFormRowDescriptor * _Nonnull rowDescriptor) {
        [SettingsViewController configSetValue:newValue forKey:kSettingsHotReloadKey];
    };
    [section addFormRow:hotReloadRTL];
    
    
    XLFormSectionDescriptor *section2 = [XLFormSectionDescriptor formSection];
    XLFormRowDescriptor *serverIPRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"serverIP" rowType:XLFormRowDescriptorTypeInfo title:@"Server IP"];
    serverIPRow.value = [HotReloadService hostIP];
    [section2 addFormRow:serverIPRow];
    
    XLFormRowDescriptor *versionRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"appversion" rowType:XLFormRowDescriptorTypeInfo title:@"Version"];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    NSString *versionString = [NSString stringWithFormat:@"%@ (%@)", version, build];
    versionRow.value = versionString;
    [section2 addFormRow:versionRow];
    [form addFormSection:section2];
    
    self.form = form;
}

#pragma mark Userdefaults

+ (void)configSetValue:(NSObject *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (id)configValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
