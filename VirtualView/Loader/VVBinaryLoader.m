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
static VVBinaryLoader* _shareLoader;
@interface SegmentInfo : NSObject
@property(assign, nonatomic)NSRange range;
@property(readonly, nonatomic)NSUInteger pageID;
@end

@implementation SegmentInfo
- (id)initWithPageID:(NSUInteger)pageid{
    self = [super init];
    if (self) {
        _pageID = pageid;
    }
    return self;
}
@end



@interface VVBinaryLoader ()
{
    
}
@property(strong, nonatomic)NSMutableData* dataResource;
@property(strong, nonatomic)NSMutableArray* arrayWidget;
@property(strong, nonatomic)NSMutableArray* arrayString;
@property(strong, nonatomic)NSMutableArray* arrayExpress;
@property(strong, nonatomic)NSMutableArray* arrayExtend;
@property(strong, nonatomic)NSMutableDictionary* pagesDic;
@property(strong, nonatomic)NSMutableDictionary* uiTempletDic;
@property(strong, nonatomic)NSMutableDictionary* strTempletDic;
@end

@implementation VVBinaryLoader

+ (id)shareInstance{
    if (_shareLoader==nil) {
        _shareLoader = [[VVBinaryLoader alloc] init];
        _shareLoader.dataCacheDic = [[NSMutableDictionary alloc] init];
    }
    return _shareLoader;
}

- (NSString*)getMajorWithPageID:(short)pageid{
    NSDictionary* pageDic = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%d",pageid]];
    return [pageDic objectForKey:@"major"];
}


- (NSString*)getMinorWithPageID:(short)pageid{
    NSDictionary* pageDic = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%d",pageid]];
    return [pageDic objectForKey:@"minor"];
}

- (NSString*)getPatchWithPageID:(short)pageid{
    NSDictionary* pageDic = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%d",pageid]];
    return [pageDic objectForKey:@"patch"];
}

- (NSDictionary*)getPageWithType:(NSUInteger)type{
    NSUInteger pageid = type/1024;
    NSDictionary* pageDic = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)pageid]];
    return pageDic;
}

- (NSData*)getUICodeWithName:(NSString*)keyStr{
    
    SegmentInfo* si  = [self.uiTempletDic objectForKey:keyStr];
    NSDictionary* pageDetail = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)si.pageID]];
    NSData* dataStream = [pageDetail objectForKey:@"buff"];
    NSData* uiData   = [dataStream subdataWithRange:si.range];
    
    return uiData;
}

- (NSData*)getUICodeWithType:(NSUInteger)type{
    
    NSDictionary* pageDic = [self getPageWithType:type];
    NSUInteger index = type%1024;
    NSArray* uiArray = [pageDic objectForKey:@"ui"];
    SegmentInfo* si  = [uiArray objectAtIndex:index];
    NSData* uiData   = [self.dataResource subdataWithRange:si.range];
    
    return uiData;
}

- (NSString*)getStrCodeWithType:(int)type{
    
//    NSDictionary* pageDic = [self getPageWithType:type];
//    NSUInteger index  = type%1024;
//    NSArray* strArray = [pageDic objectForKey:@"st"];
//    SegmentInfo* si   = [strArray objectAtIndex:index];
    NSString* stringValue = nil;
    NSString* keyString = [NSString stringWithFormat:@"%d",type];
    stringValue = [[VVSystemKey shareInstance].keyDictionary objectForKey:keyString];
    if(stringValue==nil){
        //strValueVar = [_binaryLoader getStrCodeWithType:value];
        SegmentInfo* si = [self.strTempletDic objectForKey:[NSNumber numberWithInt:type]];
        NSDictionary* pageDetail = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)si.pageID]];
        NSData* dataStream = [pageDetail objectForKey:@"buff"];
        NSData* strData    = [dataStream subdataWithRange:si.range];
        stringValue = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    }
    
//    SegmentInfo* si = [self.strTempletDic objectForKey:[NSNumber numberWithUnsignedInteger:type]];
//    NSDictionary* pageDetail = [self.pagesDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)si.pageID]];
//    NSData* dataStream = [pageDetail objectForKey:@"buff"];
//    NSData* strData    = [dataStream subdataWithRange:si.range];
    
    return stringValue;
}

- (NSData*)getExtraCodeWithType:(NSUInteger)type{
    
    NSDictionary* pageDic = [self getPageWithType:type];
    NSUInteger index  = type%1024;
    NSArray* extArray = [pageDic objectForKey:@"ext"];
    SegmentInfo* si   = [extArray objectAtIndex:index];
    NSData* extData   = [self.dataResource subdataWithRange:si.range];
    
    return extData;
}

- (void)convertIntToLittleEndian:(int *)data
{
    *data = ((*data & 0xff000000) >> 24)
    | ((*data & 0x00ff0000) >>  8)
    | ((*data & 0x0000ff00) <<  8)
    | ((*data & 0x000000ff) << 24);
}

- (void)convertShortToLittleEndian:(short *)data
{
    *data = ((*data & 0xff00) >> 8) | ((*data & 0x00ff) << 8);
}

- (VVVersionModel *)loadFromBuffer:(NSData*)buff{
    
    if (self.pagesDic==nil) {
        self.pagesDic = [[NSMutableDictionary alloc] init];
    }
    if (self.uiTempletDic==nil) {
        self.uiTempletDic = [[NSMutableDictionary alloc] init];
    }
    
    if (self.strTempletDic==nil) {
        self.strTempletDic = [[NSMutableDictionary alloc] init];
    }
    
    VVVersionModel *versionModel = nil;
    
    NSString* vvHead = [[NSString alloc] initWithData:[buff subdataWithRange:NSMakeRange(0, 5)] encoding:NSUTF8StringEncoding];
    if (vvHead!=nil && vvHead.length>0) {
        if([vvHead compare:VVHEAD]==NSOrderedSame){
            short major = 0;
            short minor = 0;
            short patch = 0;
            [buff getBytes:&major range:NSMakeRange(5, 2)];
            [buff getBytes:&minor range:NSMakeRange(7, 2)];
            [buff getBytes:&patch range:NSMakeRange(9, 2)];
            [self convertShortToLittleEndian:&major];
            [self convertShortToLittleEndian:&minor];
            [self convertShortToLittleEndian:&patch];
            
            int uiOffset, uiSize;
            int strOffset, strSize;
            int exprOffset, exprSize;
            int extraOffset, extraSize;
            short pageID;
            [buff getBytes:&uiOffset range:NSMakeRange(11, 4)];
            [buff getBytes:&uiSize range:NSMakeRange(15, 4)];
            [self convertIntToLittleEndian:&uiOffset];
            [self convertIntToLittleEndian:&uiSize];
            
            [buff getBytes:&strOffset range:NSMakeRange(19, 4)];
            [buff getBytes:&strSize range:NSMakeRange(23, 4)];
            [self convertIntToLittleEndian:&strOffset];
            [self convertIntToLittleEndian:&strSize];
            
            [buff getBytes:&exprOffset range:NSMakeRange(27, 4)];
            [buff getBytes:&exprSize range:NSMakeRange(31, 4)];
            [self convertIntToLittleEndian:&exprOffset];
            [self convertIntToLittleEndian:&exprSize];
            
            [buff getBytes:&extraOffset range:NSMakeRange(35, 4)];
            [buff getBytes:&extraSize range:NSMakeRange(39, 4)];
            [self convertIntToLittleEndian:&extraOffset];
            [self convertIntToLittleEndian:&extraSize];
            
            
            
            [buff getBytes:&pageID range:NSMakeRange(43, 2)];
            [self convertShortToLittleEndian:&pageID];
            
            NSString* pageStr = [NSString stringWithFormat:@"%d",pageID];
            NSMutableDictionary* pageDetail =[self.pagesDic objectForKey:pageStr];
            if (pageDetail==nil) {
                pageDetail = [[NSMutableDictionary alloc] init];
            }
            NSUInteger segment=0;
            self.dataResource = [pageDetail objectForKey:@"buff"];
            if (self.dataResource) {
                segment = self.dataResource.length;
                [self.dataResource appendData:buff];
            }else{
                self.dataResource = [NSMutableData dataWithData:buff];
                [pageDetail setObject:self.dataResource forKey:@"buff"];
            }
            
            [pageDetail setObject:[NSString stringWithFormat:@"%d",major] forKey:@"major"];
            [pageDetail setObject:[NSString stringWithFormat:@"%d",minor] forKey:@"minor"];
            [pageDetail setObject:[NSString stringWithFormat:@"%d",patch] forKey:@"patch"];

            versionModel = [[VVVersionModel alloc] initWithMajor:major minor:minor patch:patch];

            short depPageCount, depPageID;
            [buff getBytes:&depPageCount range:NSMakeRange(45, 2)];
            [buff getBytes:&depPageID range:NSMakeRange(47, 2)];
            [self convertShortToLittleEndian:&depPageCount];
            [self convertShortToLittleEndian:&depPageID];
            
            
            if (uiOffset==0 || uiSize==0) {
                #ifdef VV_DEBUG
                    NSLog(@"ui parse failed");
                #endif
            }else{
                int uiWidgetCount;
                [buff getBytes:&uiWidgetCount range:NSMakeRange(uiOffset, 4)];
                [self convertIntToLittleEndian:&uiWidgetCount];
                int pos = uiOffset+4;
                for (int i=0; i<uiWidgetCount; i++) {
                    short keyLength,contentLength;
                    
                    [buff getBytes:&keyLength range:NSMakeRange(pos, 2)];
                    [self convertShortToLittleEndian:&keyLength];
                    pos+=2;
                    
                    NSData* keyData   = [buff subdataWithRange:NSMakeRange(pos, keyLength)];
                    NSString* keyStr  = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
                    pos+=keyLength;
                    
                    [buff getBytes:&contentLength range:NSMakeRange(pos, 2)];
                    [self convertShortToLittleEndian:&contentLength];
                    pos+=2;
                    
                    SegmentInfo* si = [[SegmentInfo alloc] initWithPageID:pageID];
                    si.range = NSMakeRange(pos+segment, contentLength);
                    
                    [self.uiTempletDic setObject:si forKey:keyStr];
                    pos+=contentLength;
                }
            }
            
            if (strOffset==0 || strSize==0) {
                #ifdef VV_DEBUG
                    NSLog(@"string parse failed");
                #endif
            }else{
                //
                int strBlockCount;
                [buff getBytes:&strBlockCount range:NSMakeRange(strOffset, 4)];
                [self convertIntToLittleEndian:&strBlockCount];
                int pos = strOffset+4;
                //NSMutableArray* arrayString = [[NSMutableArray alloc] initWithCapacity:strBlockCount];
                for (int i=0; i<strBlockCount; i++) {
                    
                    int index;
                    
                    [buff getBytes:&index range:NSMakeRange(pos, 4)];
                    [self convertIntToLittleEndian:&index];
                    pos+=4;
                    
                    short len;
                    [buff getBytes:&len range:NSMakeRange(pos, 2)];
                    [self convertShortToLittleEndian:&len];
                    pos+=2;
                    SegmentInfo* si = [[SegmentInfo alloc] initWithPageID:pageID];
                    si.range = NSMakeRange(pos+segment, len);
                    
                    #ifdef VV_DEBUG
                        NSData* strData   = [buff subdataWithRange:NSMakeRange(pos, len)];
                        NSString* str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
                        NSLog(@"@@@@@@@index:%d,%@",index,str);
                    #endif
                    
                    [self.strTempletDic setObject:si forKey:[NSNumber numberWithInt:index]];
                    //[arrayString addObject:si];
                    pos+=len;
                    
                }
                
                //[pageDetail setObject:arrayString forKey:@"st"];
            }
            
            
            if (exprOffset==0 || exprSize==0) {
                #ifdef VV_DEBUG
                    NSLog(@"express parse failed");
                #endif
            }else{
                //
                int exprBlockCount;
                [buff getBytes:&exprBlockCount range:NSMakeRange(strOffset, 4)];
                [self convertIntToLittleEndian:&exprBlockCount];
                int pos = strOffset+4;
                NSMutableArray* arrayExpr = [[NSMutableArray alloc] initWithCapacity:exprBlockCount];
                for (int i=0; i<exprBlockCount; i++) {
                    short len;
                    [buff getBytes:&len range:NSMakeRange(pos, 2)];
                    [self convertShortToLittleEndian:&len];
                    pos+=2;
                    SegmentInfo* si = [[SegmentInfo alloc] initWithPageID:pageID];
                    si.range = NSMakeRange(pos+segment, len);
                    [arrayExpr addObject:si];
                    pos+=len;
                }
                
                [pageDetail setObject:arrayExpr forKey:@"exp"];

            }
            
            
            if (extraOffset==0 || extraSize==0) {
                #ifdef VV_DEBUG
                    NSLog(@"extra parse failed");
                #endif
            }else{
                //
                int extraBlockCount;
                [buff getBytes:&extraBlockCount range:NSMakeRange(strOffset, 4)];
                [self convertIntToLittleEndian:&extraBlockCount];
                int pos = strOffset+4;
                NSMutableArray* arrayExtra = [[NSMutableArray alloc] initWithCapacity:extraBlockCount];
                for (int i=0; i<extraBlockCount; i++) {
                    short len;
                    [buff getBytes:&len range:NSMakeRange(pos, 2)];
                    [self convertShortToLittleEndian:&len];
                    pos+=2;
                    SegmentInfo* si = [[SegmentInfo alloc] initWithPageID:pageID];
                    si.range = NSMakeRange(pos+segment, len);
                    [arrayExtra addObject:si];
                    pos+=len;
                }
                
                [pageDetail setObject:arrayExtra forKey:@"ext"];

            }
            
            [self.pagesDic setObject:pageDetail forKey:pageStr];
        }
    }
    
    return versionModel;
}

- (void)clear{
    [self.pagesDic removeAllObjects];
    [self.uiTempletDic removeAllObjects];
    [self.strTempletDic removeAllObjects];
    [self.dataResource resetBytesInRange:NSMakeRange(0, _dataResource.length)];
}
@end
