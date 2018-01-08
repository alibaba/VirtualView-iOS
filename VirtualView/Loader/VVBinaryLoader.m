//
//  VVBinaryLoader.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVBinaryLoader.h"
#import "VVSystemKey.h"
#import "VVVersionModel.h"

#define VVHEAD @"ALIVV"

//****************************************************************

@interface SegmentInfo : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign, readonly) NSUInteger pageID;

@end

@implementation SegmentInfo

- (id)initWithPageID:(NSUInteger)pageid
{
    if (self = [super init]) {
        _pageID = pageid;
    }
    return self;
}

@end

//****************************************************************

@interface VVBinaryLoader ()

@property (nonatomic, strong) NSMutableData *dataResource;
@property (nonatomic, strong) NSMutableDictionary *pagesDic;
@property (nonatomic, strong) NSMutableDictionary *uiTempletDic;
@property (nonatomic, strong) NSMutableDictionary *strTempletDic;

@end

@implementation VVBinaryLoader

+ (id)shareInstance
{
    static VVBinaryLoader *shareInstance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [VVBinaryLoader new];
    });
    return shareInstance_;
}

- (NSData *)getUICodeWithName:(NSString *)keyStr
{
    SegmentInfo *si = [self.uiTempletDic objectForKey:keyStr];
    NSDictionary *pageDetail = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%zd", si.pageID]];
    NSData *dataStream = [pageDetail objectForKey:@"buff"];
    NSData *uiData = [dataStream subdataWithRange:si.range];
    return uiData;
}

- (NSString *)getStrCodeWithType:(int)type
{
    NSString *stringValue = nil;
    NSString *keyString = [NSString stringWithFormat:@"%d",type];
    stringValue = [[VVSystemKey shareInstance].keyDictionary objectForKey:keyString];
    if (stringValue == nil) {
        SegmentInfo *si = [self.strTempletDic objectForKey:@(type)];
        NSDictionary *pageDetail = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%zd", si.pageID]];
        NSData *dataStream = [pageDetail objectForKey:@"buff"];
        NSData *strData = [dataStream subdataWithRange:si.range];
        stringValue = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    }
    return stringValue;
}

- (void)convertIntToLittleEndian:(int *)data
{
    *data = ((*data & 0xff000000) >> 24)
    | ((*data & 0x00ff0000) >> 8)
    | ((*data & 0x0000ff00) << 8)
    | ((*data & 0x000000ff) << 24);
}

- (void)convertShortToLittleEndian:(short *)data
{
    *data = ((*data & 0xff00) >> 8) | ((*data & 0x00ff) << 8);
}

- (VVVersionModel *)loadFromBuffer:(NSData *)buff
{
    if (self.pagesDic == nil) {
        self.pagesDic = [[NSMutableDictionary alloc] init];
    }
    if (self.uiTempletDic == nil) {
        self.uiTempletDic = [[NSMutableDictionary alloc] init];
    }
    if (self.strTempletDic == nil) {
        self.strTempletDic = [[NSMutableDictionary alloc] init];
    }
    
    VVVersionModel *versionModel = nil;
    NSString *vvHead = [[NSString alloc] initWithData:[buff subdataWithRange:NSMakeRange(0, 5)] encoding:NSUTF8StringEncoding];
    if (vvHead != nil && vvHead.length > 0 && [vvHead compare:VVHEAD] == NSOrderedSame) {
        short major = 0;
        short minor = 0;
        short patch = 0;
        [buff getBytes:&major range:NSMakeRange(5, 2)];
        [buff getBytes:&minor range:NSMakeRange(7, 2)];
        [buff getBytes:&patch range:NSMakeRange(9, 2)];
        [self convertShortToLittleEndian:&major];
        [self convertShortToLittleEndian:&minor];
        [self convertShortToLittleEndian:&patch];
        
        versionModel = [[VVVersionModel alloc] initWithMajor:major minor:minor patch:patch];

        int uiOffset, uiSize;
        [buff getBytes:&uiOffset range:NSMakeRange(11, 4)];
        [buff getBytes:&uiSize range:NSMakeRange(15, 4)];
        [self convertIntToLittleEndian:&uiOffset];
        [self convertIntToLittleEndian:&uiSize];
        
        int strOffset, strSize;
        [buff getBytes:&strOffset range:NSMakeRange(19, 4)];
        [buff getBytes:&strSize range:NSMakeRange(23, 4)];
        [self convertIntToLittleEndian:&strOffset];
        [self convertIntToLittleEndian:&strSize];
        
        int exprOffset, exprSize;
        [buff getBytes:&exprOffset range:NSMakeRange(27, 4)];
        [buff getBytes:&exprSize range:NSMakeRange(31, 4)];
        [self convertIntToLittleEndian:&exprOffset];
        [self convertIntToLittleEndian:&exprSize];
        
        int extraOffset, extraSize;
        [buff getBytes:&extraOffset range:NSMakeRange(35, 4)];
        [buff getBytes:&extraSize range:NSMakeRange(39, 4)];
        [self convertIntToLittleEndian:&extraOffset];
        [self convertIntToLittleEndian:&extraSize];
        
        short pageID;
        [buff getBytes:&pageID range:NSMakeRange(43, 2)];
        [self convertShortToLittleEndian:&pageID];
        
        NSString *pageStr = [NSString stringWithFormat:@"%d", pageID];
        NSMutableDictionary *pageDetail = [self.pagesDic objectForKey:pageStr];
        if (pageDetail == nil) {
            pageDetail = [[NSMutableDictionary alloc] init];
        }
        
        // 记录的是 buff 段之前的总长度，用于后面计算数据在 buff 段的总偏移
        NSUInteger segment = 0;
        self.dataResource = [pageDetail objectForKey:@"buff"];
        if (self.dataResource) {
            segment = self.dataResource.length;
            [self.dataResource appendData:buff];
        } else {
            self.dataResource = [NSMutableData dataWithData:buff];
            [pageDetail setObject:self.dataResource forKey:@"buff"];
        }

        short depPageCount, depPageID;
        [buff getBytes:&depPageCount range:NSMakeRange(45, 2)];
        [buff getBytes:&depPageID range:NSMakeRange(47, 2)];
        [self convertShortToLittleEndian:&depPageCount];
        [self convertShortToLittleEndian:&depPageID];
        
        if (uiOffset > 0 && uiSize > 0) {
            // 读取 UI 段
            int uiWidgetCount;
            [buff getBytes:&uiWidgetCount range:NSMakeRange(uiOffset, 4)];
            [self convertIntToLittleEndian:&uiWidgetCount];
            int pos = uiOffset + 4;
            for (int i = 0; i < uiWidgetCount; i++) {
                short keyLength;
                [buff getBytes:&keyLength range:NSMakeRange(pos, 2)];
                [self convertShortToLittleEndian:&keyLength];
                pos += 2;
                
                NSData *keyData = [buff subdataWithRange:NSMakeRange(pos, keyLength)];
                NSString *keyStr = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
                pos += keyLength;
                
                short contentLength;
                [buff getBytes:&contentLength range:NSMakeRange(pos, 2)];
                [self convertShortToLittleEndian:&contentLength];
                pos += 2;
                
                SegmentInfo *si = [[SegmentInfo alloc] initWithPageID:pageID];
                si.range = NSMakeRange(pos + segment, contentLength);
                
                [self.uiTempletDic setObject:si forKey:keyStr];
                pos += contentLength;
            }
        }
        
        if (strOffset > 0 && strSize > 0) {
            // 读取字串段
            int strBlockCount;
            [buff getBytes:&strBlockCount range:NSMakeRange(strOffset, 4)];
            [self convertIntToLittleEndian:&strBlockCount];
            int pos = strOffset + 4;
            for (int i = 0; i < strBlockCount; i++) {
                int index;
                [buff getBytes:&index range:NSMakeRange(pos, 4)];
                [self convertIntToLittleEndian:&index];
                pos += 4;
                
                short len;
                [buff getBytes:&len range:NSMakeRange(pos, 2)];
                [self convertShortToLittleEndian:&len];
                pos += 2;
                
                SegmentInfo *si = [[SegmentInfo alloc] initWithPageID:pageID];
                si.range = NSMakeRange(pos + segment, len);
                
                [self.strTempletDic setObject:si forKey:[NSNumber numberWithInt:index]];
                pos += len;
            }
        }
        
        if (exprOffset > 0 && exprSize > 0) {
            // 表达式段暂时废弃
        }
        
        
        if (extraOffset > 0 || extraSize > 0) {
            // 扩展段暂时废弃
        }
        
        [self.pagesDic setObject:pageDetail forKey:pageStr];
    }
    return versionModel;
}

@end
