//
//  QRViewController.m
//  ZBar
//
//  Created by Tony on 16/7/12.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "QRViewController.h"
#import "ShowImageViewController.h"
#import "QRCodeGenerator.h"


@interface QRViewController ()
@property (nonatomic, strong) UITextView *textViewMain;

@property (nonatomic, strong) UIImage *image; // 生成的二维码
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textViewMain = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.textViewMain.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_textViewMain];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"生成" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showImage
{
    // 合成二维码
    
    switch (self.selectedIndex) {
        case 2:
            // QR合成
            
            self.image = [QRCodeGenerator qrImageForString:self.textViewMain.text imageSize:200];
            
            
            break;
        case 3:
            // 系统合成法
            [self systemMakeImage];
            break;
        default:
            break;
    }
    
    
    
    
    
    
    ShowImageViewController *show = [[ShowImageViewController alloc] init];
    show.image = self.image;
    [self presentViewController:show animated:YES completion:nil];
}



#pragma mark 系统合成法
- (void)systemMakeImage
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = self.textViewMain.text;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
#warning 如果要更清楚则需要打开84行注释
    // 5.显示二维码
    self.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
