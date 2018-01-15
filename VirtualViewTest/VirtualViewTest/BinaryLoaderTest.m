//
//  BinaryLoaderTest.m
//  VirtualViewTest
//
//  Created by HarrisonXi on 2018/1/12.
//

#import <XCTest/XCTest.h>
#import <VirtualView/VVTemplateBinaryLoader.h>
#import <OCHamcrest/OCHamcrest.h>
#import <VirtualView/VVVersionModel.h>

@interface BinaryLoaderTest : XCTestCase

@end

@implementation BinaryLoaderTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadIconTemplate {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"icon" ofType:@"out"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    VVTemplateBinaryLoader *loader = [VVTemplateBinaryLoader new];
    assertThatBool([loader loadTemplateData:data], isTrue());
    assertThat([loader.lastVersion stringValue], equalTo(@"1.0.2"));
    assertThat(loader.lastType, equalTo(@"icon"));
}

@end
