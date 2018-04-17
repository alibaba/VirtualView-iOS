//
//  HotReloadService.h
//  VirtualViewDemo
//
//  Created by isaced on 2018/1/31.
//

#import <Foundation/Foundation.h>

typedef void(^HotReloadServiceDataBlock)(NSData * data);
typedef void(^HotReloadServiceDictBlock)(NSDictionary * dict);
typedef void(^HotReloadServiceArrayBlock)(NSArray * array);
typedef void(^HotReloadServiceTemplateBlock)(NSArray<NSData *> *templates, NSDictionary *params);

@interface HotReloadService : NSObject

+ (NSString *)hostIP;
+ (NSURL *)hostURL;
+ (NSString *)hostURLString;

/**
 根据模版名从 Host 加载 data.json
 */
+ (void)fetchTemplateByName:(NSString *)templateName callback:(HotReloadServiceTemplateBlock)callback;

/**
 根据扫描来的 URL 加载模版
 */
+ (void)fetchTemplateByDataJsonURL:(NSURL *)fetchTemplateByDataJsonURL callback:(HotReloadServiceTemplateBlock)callback;

/**
 获取 VVTool 模版名列表
 */
+ (void)fetchTemplateNameListWithCallback:(HotReloadServiceArrayBlock)callback;

@end
