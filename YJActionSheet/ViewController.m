//
//  ViewController.m
//  YJActionSheet
//
//  Created by Jake on 16/9/20.
//  Copyright © 2016年 Hu.Jake. All rights reserved.
//

#import "ViewController.h"
#import "YJActionSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)tapShowBtn:(UIButton *)sender {
    UIImage *img = [UIImage imageNamed:@"avatar2.jpeg"];
    switch (sender.tag) {
        case 100:
            [YJActionSheetView addToSuperView:self.view withTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] imageArray:@[img, img, img, img, img, img] headerString:@"分享" completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
            break;
        case 101:
            [YJActionSheetView addToSuperView:self.view withTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] imageArray:@[img, img, img, img, img, img] headerString:nil completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
            break;
        case 102:
            [YJActionSheetView addToSuperView:self.view withTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] headerString:@"分享" completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
            break;
        case 103:
            [YJActionSheetView addToSuperView:self.view withTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] headerString:nil completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
