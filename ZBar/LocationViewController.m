//
//  LocationViewController.m
//  ZBar
//
//  Created by Tony on 16/7/14.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "LocationViewController.h"
#import "ShowViewController.h"
#import "ZBarReaderController.h"

@interface LocationViewController () <ZBarReaderDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImage *image;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.selectIndex) {
        case 4:
            [self selfDevice];
            break;
        case 5:
            [self photoBrown];
            break;
        default:
            break;
    }
    
    
    
}

// 识别相册中的二维码
- (void)photoBrown
{
    ZBarReaderController *reader = [ZBarReaderController new];
    
    reader.allowsEditing = NO   ;
    
    reader.showsHelpOnFail = NO;
    
    reader.readerDelegate = self;
    
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:reader animated:YES completion:nil];
}

// 识别本app中的二维码
- (void)selfDevice
{
    self.image = [UIImage imageNamed:@"123"];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
}

#pragma mark ButtonAction
- (void)buttonAction:(UIButton *)button
{
    ZBarReaderController *reader = [ZBarReaderController new];
    
    id<NSFastEnumeration> results = [reader scanImage:self.image.CGImage];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
    NSString *code = [NSString stringWithString:symbol.data];
    
    ShowViewController *showVC  = [[ShowViewController alloc] init];
    showVC.info = code;
    [self presentViewController:showVC animated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
    NSString *code = [NSString stringWithString:symbol.data];
    
    ShowViewController *showVC  = [[ShowViewController alloc] init];
    showVC.info = code;
    [self presentViewController:showVC animated:YES completion:nil];
}



#pragma mark GET
- (UIButton *)button
{
    if (_button == nil) {
        UIButton *tmp = [UIButton buttonWithType:UIButtonTypeSystem];
        [tmp setTitle:@"识别" forState:UIControlStateNormal];
        tmp.frame = CGRectMake(110, 300, 100, 100);
        [tmp addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button = tmp;
    }
    return _button;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *tmp = [[UIImageView alloc] initWithImage:self.image];
        tmp.frame = CGRectMake(60, 80, 200, 200);
        
        _imageView = tmp;
    }
    return _imageView;
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
