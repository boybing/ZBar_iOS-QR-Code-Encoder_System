//
//  ViewController.m
//  ZBar
//
//  Created by Tony on 16/7/12.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ViewController.h"
#import "ZBarViewController.h"
#import "QRViewController.h"
#import "LocationViewController.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = @[@"ZBar识别",@"系统默认识别",@"QREncoder生成",@"系统默认生成",@"识别本地图片",@"读取相册中的二维码"];
    [self.view addSubview:self.tableViewList];
    
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        // ZBar识别与系统默认识别
        ZBarViewController *zbar = [[ZBarViewController alloc] init];
        zbar.title = self.dataSource[indexPath.row];
        zbar.selectIndex = indexPath.row;
        [self.navigationController pushViewController:zbar animated:YES];
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        // QR生成二维码与系统默认生成二维码
        QRViewController *QR = [[QRViewController alloc] init];
        QR.title = self.dataSource[indexPath.row];
        QR.selectedIndex = indexPath.row;
        [self.navigationController pushViewController:QR animated:YES];
    } else {
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        locationVC.selectIndex = indexPath.row;
        [self.navigationController pushViewController:locationVC animated:YES];
    }
   
}


#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark GET
-(UITableView *)tableViewList
{
    if (_tableViewList == nil) {
        UITableView *temp = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        temp.delegate = self;
        temp.dataSource = self;
        _tableViewList = temp;
    }
    return _tableViewList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
