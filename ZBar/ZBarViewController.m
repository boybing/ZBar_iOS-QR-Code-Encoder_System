//
//  ZBarViewController.m
//  ZBar
//
//  Created by Tony on 16/7/12.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ZBarViewController.h"
#import "ShowViewController.h"
#import <AVFoundation/AVFoundation.h> // 系统默认读取二维码所需库文件, 以及协议
#import "ZBarSDK.h"

@interface ZBarViewController () <AVCaptureMetadataOutputObjectsDelegate,ZBarReaderDelegate>

@end

@implementation ZBarViewController
{
    AVCaptureSession *session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    switch (self.selectIndex) {
        case 0:
            [self ZbarQR];
            break;
        case 1:
            // 系统识别法
            [self systemReaderQR];
            break;
            
        default:
            break;
    }
    
    // Do any additional setup after loading the view.
}


#pragma mark ZBar
- (void)ZbarQR
{
    ZBarReaderViewController *reader = [[ZBarReaderViewController alloc] init];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = UIInterfaceOrientationLandscapeLeft;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentViewController:reader
                       animated:YES
                     completion:^{
                     }];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
    NSString *code = [NSString stringWithString:symbol.data];
    NSLog(@"%@",code);
    ShowViewController *showVC  = [[ShowViewController alloc] init];
    showVC.info = code;
    [self presentViewController:showVC animated:YES completion:nil];
}

#pragma mark 系统识别二维码
- (void)systemReaderQR
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        ShowViewController *showVC  = [[ShowViewController alloc] init];
        showVC.info = metadataObject.stringValue;
        [self presentViewController:showVC animated:YES completion:nil];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
