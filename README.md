# YJActionSheet
#### 单选控件，可以支持纯文字和带图+文字两种样式

## 示例

![gif](http://o8ajh91ch.bkt.clouddn.com/YJActionSheet.gif)

## 使用方法

1. 把`YJActionSheetView` 的接口和实现文件复制到项目
2. 初始化控件对象，对标题数组和内容数组进行赋值
3. 控件提供两个工厂方法以调用
	* 图片 + 文字 的列表

			[YJActionSheetView showWithTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] imageArray:@[img, img, img, img, img, img] headerString:@"分享" completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
   		
	* 纯文字的列表
	
			[YJActionSheetView showWithTitleArray:@[@"网易", @"阿里", @"腾讯", @"百度", @"微信支付", @"支付宝支付"] headerString:nil completionHandle:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
__两个工厂方法中的headerString可以为空__

## 更新日志
* 2016.09.21 首次提交
* 2016.10.14 修改方法去除传入的superView，直接添加到window
