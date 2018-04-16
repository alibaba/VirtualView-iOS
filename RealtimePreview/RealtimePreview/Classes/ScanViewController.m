//
//  ScanViewController.m
//  VVPlayground
//
//  Created by isaced on 2018/2/7.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Scan";
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(inputBaseURL)];
    
    #if TARGET_OS_SIMULATOR
    #else
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Privacy - Camera Usage" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self startReading];
    }
    #endif
}

- (void)inputBaseURL {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手动输入 BaseURL" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"http://127.0.0.1:7788/helloworld/";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [alert.textFields firstObject];
        NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([text length] > 3) {
            [self.delegate scanViewController:self didScanContent:text];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startReading {
    // 链接输入输出
    if ([self.session canAddInput:self.input]){
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]){
        [self.session addOutput:self.output];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    }
    
    // 添加扫描画面
    [self.view.layer addSublayer:self.preview];
    [self.session startRunning];
}

#pragma mark - lazyMethod
- (AVCaptureDevice *)device
{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}
- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)preview
{
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame =self.view.layer.bounds;
    }
    return _preview;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0){
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"------------%@-----------",stringValue);
        
        [self.delegate scanViewController:self didScanContent:stringValue];
    }
}

@end
