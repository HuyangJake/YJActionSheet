//
//  YJActionSheetView.h
//  YJActionSheet
//
//  Created by Jake on 16/9/21.
//  Copyright © 2016年 Hu.Jake. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompleteSelection)(NSInteger index);

@interface YJActionSheetView : UIView


@property (nonatomic, copy, nonnull) void (^completeSelection)(NSInteger index);

/**
 纯文字的单选列表

 @param superView    父视图
 @param array        列表数组
 @param headerString 标题名字（可选）
 @param handle       选择回调Bolck

 @return YJActionSheetView对象
 */
+ (YJActionSheetView * _Nonnull)addToSuperView:(UIView *_Nonnull)superView withTitleArray:(NSArray *_Nonnull)array headerString:(NSString *_Nullable)headerString completionHandle:(CompleteSelection _Nonnull)handle;


/**
 带图片单选列表

 @param superView    父视图
 @param titleArray   列表文字数组
 @param imgArray     列表图片数组
 @param headerString 标题名字（可选）
 @param handle       选择回调Block

 @return YJActionSheetView对象
 */
+ (YJActionSheetView * _Nonnull)addToSuperView:(UIView *_Nonnull)superView withTitleArray:(NSArray *_Nonnull)titleArray imageArray:(NSArray *_Nullable)imgArray headerString:(NSString *_Nullable)headerString completionHandle:(CompleteSelection _Nonnull)handle;

@end
