//
//  HotReloadService.m
//  VirtualViewDemo
//
//  Created by isaced on 2018/1/31.
//

#import "HotReloadService.h"

static NSString *const kKeyInPlistHostIP = @"ASC_HOST_IP";

@implementation HotReloadService

+ (NSString *)hostIP {
    NSString *ip = [[NSBundle mainBundle] objectForInfoDictionaryKey:kKeyInPlistHostIP];
    if (!ip) {
        ip = @"127.0.0.1";
    }
    return ip;
}

+ (NSURL *)hostURL {
    return [NSURL URLWithString:[self hostURLString]];
}

+ (NSString *)hostURLString {
    return [NSString stringWithFormat:@"http://%@:7788/", [self hostIP]];
}

+ (void)requestWithURL:(NSURL *)url completionHandler:(HotReloadServiceDataBlock)completionHandler {
    if (!url) {
        completionHandler(nil);
        return;
    }

    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    conf.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(data);
            });
        }else{
            completionHandler(data);
        }
    }] resume];
}

+ (void)fetchTemplateByName:(NSString *)templateName callback:(HotReloadServiceTemplateBlock)callback {
    if (![self hostIP] || ! templateName) {
        callback(nil, nil);
        return;
    }
    
    NSURL *url = [[[self hostURL] URLByAppendingPathComponent:templateName] URLByAppendingPathComponent:@"data.json"];
    [self fetchTemplateByDataJsonURL:url callback:callback];
}

+ (void)fetchTemplateByDataJsonURL:(NSURL *)fetchTemplateByDataJsonURL callback:(HotReloadServiceTemplateBlock)callback {
    if (!fetchTemplateByDataJsonURL) {
        callback(nil, nil);
        return;
    }
    
    [self requestWithURL:fetchTemplateByDataJsonURL completionHandler:^(NSData *data) {
        NSDictionary *dict;
        if (data) {
            dict = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:nil];
        }
        
        // 模版
        NSMutableArray *templates = [NSMutableArray array];
        if (dict) {
            for (NSString *templateBase64String in dict[@"templates"]) {
                NSData *templateData = [[NSData alloc] initWithBase64EncodedString:templateBase64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [templates addObject:templateData];
            }
        }
        
        // 数据
        NSDictionary *params = dict[@"data"];
        if (callback) {
            callback(templates, params);
        }
    }];
}

+ (void)fetchTemplateNameListWithCallback:(HotReloadServiceArrayBlock)callback {
    NSURL *url = [[self hostURL] URLByAppendingPathComponent:@".dir"];
    [self requestWithURL:url completionHandler:^(NSData *data) {
        NSArray *array;
        if (data) {
            array = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:nil];
        }
        callback(array);
    }];
}

@end
