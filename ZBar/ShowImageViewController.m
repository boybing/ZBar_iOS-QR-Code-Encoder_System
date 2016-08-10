//
//  ShowImageViewController.m
//  ZBar
//
//  Created by Tony on 16/7/12.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ShowImageViewController.h"
#define layout self.view.frame.size.width / 320

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 二维码图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50 *layout, 220 *layout, 200 *layout)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    // 返回按钮
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    buttonBack.frame = CGRectMake(200 * layout, self.view.frame.size.height - 100, 80 * layout, 40 *layout);
    [self.view addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 此部分为保存到相册不要求完成
    UIButton *buttonSave = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    buttonSave.frame = CGRectMake(40 *layout, self.view.frame.size.height - 100, 80 *layout, 40 *layout);
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 返回按钮
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存到相册
- (void)save
{
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message;
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
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
