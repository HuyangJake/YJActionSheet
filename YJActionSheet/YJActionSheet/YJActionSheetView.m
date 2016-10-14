//
//  YJActionSheetView.m
//  YJActionSheet
//
//  Created by Jake on 16/9/21.
//  Copyright © 2016年 Hu.Jake. All rights reserved.
//

#import "YJActionSheetView.h"
#import "AppDelegate.h"
#define kRootWindow  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window

static const CGFloat tableViewMaxHeight = 300;
static const CGFloat imageBorder = 25;
static const CGFloat rowHeight = 45;

@interface YJSheetPicCell : UITableViewCell

/**
 必须晚于title赋值
 */
@property (nonatomic, strong) UIImage *img;

/**
 必须得先被赋值
 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation YJSheetPicCell

- (void)setImg:(UIImage *)img {
    _img = img;
    if (!_picView) {
        _picView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _picView.image = img;
        _picView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_picView];
        _picView.translatesAutoresizingMaskIntoConstraints = NO;
         NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_picView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
         NSLayoutConstraint *trail = [NSLayoutConstraint constraintWithItem:_picView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-5];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_picView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:imageBorder];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_picView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:imageBorder];
        NSArray *constraintArr = @[centerY, trail, width, height];
        [self addConstraints:constraintArr];
        
    } else {
        self.picView.image = img;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (!_label) {
        _label = [[UILabel alloc]init];
        [_label setFont:[UIFont systemFontOfSize:15]];
        [_label setText:title];
        [_label setTextColor:[UIColor darkGrayColor]];
        [self addSubview:_label];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        CGFloat lableWidth = _label.frame.size.width;
        CGFloat contentWidth = lableWidth + imageBorder + 5;
        CGFloat distance = (contentWidth - lableWidth)/2;
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:distance];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-(imageBorder + 35)];
        [self addConstraint:centerX];
        [self addConstraint:centerY];
        [self addConstraint:width];
    } else {
        self.label.text = title;
    }
}

@end

@interface YJSheetCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *label;
@end

@implementation YJSheetCell

- (void)setTitle:(NSString *)title {
    _title = title;
    if (!_label) {
        _label = [[UILabel alloc]init];
        [_label setFont:[UIFont systemFontOfSize:15]];
        [_label setText:title];
        [_label setTextColor:[UIColor darkGrayColor]];
        [self addSubview:_label];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
         NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-(imageBorder + 30)];
        [self addConstraint:centerX];
        [self addConstraint:centerY];
        [self addConstraint:width];
    } else {
        self.label.text = title;
    }

}

@end

@interface YJActionSheetView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *headerString;
@property (nonatomic, strong) UILabel *headerTitleLabel;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSLayoutConstraint *bottomViewHeight;
@property (nonatomic, strong) NSLayoutConstraint *headerTitleHeight;

@end

@implementation YJActionSheetView

+ (YJActionSheetView * _Nonnull)showWithTitleArray:(NSArray *_Nonnull)array headerString:(NSString *_Nullable)headerString completionHandle:(CompleteSelection)handle{
    return [YJActionSheetView showWithTitleArray:array imageArray:nil headerString:headerString completionHandle:handle];
}

+ (YJActionSheetView * _Nonnull)showWithTitleArray:(NSArray *_Nonnull)titleArray imageArray:(NSArray *_Nullable)imgArray headerString:(NSString *_Nullable)headerString completionHandle:(CompleteSelection)handle{
    if (titleArray && imgArray) {
        NSAssert(titleArray.count == imgArray.count, @"传入的标题数量与图片数量不等！");
    }
    YJActionSheetView *view = [[YJActionSheetView alloc] initWithFrame:kRootWindow.bounds];
    [kRootWindow addSubview:view];
    view.completeSelection = handle;
    view.titleArray = [titleArray copy];
    view.imageArray = [imgArray copy];
    view.headerString = headerString;
    
    
    [view.tableView registerClass:[YJSheetPicCell class] forCellReuseIdentifier:@"PicCell"];
    [view.tableView registerClass:[YJSheetCell class] forCellReuseIdentifier:@"Cell"];
    [view.tableView reloadData];
    
    view.tableViewHeight.constant = view.tableView.contentSize.height > tableViewMaxHeight? tableViewMaxHeight :  view.tableView.contentSize.height;
    view.tableView.separatorStyle = NO;
    view.tableView.bounces = view.tableViewHeight.constant == tableViewMaxHeight ? YES : NO;
    view.bottomViewHeight.constant = view.tableViewHeight.constant + rowHeight + view.headerTitleHeight.constant + 0.5;
    [view layoutIfNeeded];
    [view showView:view];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView:)];
        [bgView addGestureRecognizer:tap];
        self.bgView = bgView;
        [self addSubview:bgView];
        [self triggerInitlaze];
        [self addSubview:self.bottomView];
    }
    return self;
}

#pragma mark - TableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.imageArray) {
        YJSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.title = self.titleArray[indexPath.row];
        return cell;
    } else {
        YJSheetPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"];
        cell.title = self.titleArray[indexPath.row];
        cell.img = self.imageArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.completeSelection(indexPath.row);
    [self closeView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark - Action

- (void)tapCancleBtn:(UIButton *)sender {
    [self closeView:self];
}

- (void)tapBgView:(UITapGestureRecognizer *)sender {
    [self closeView:self];
}

- (void)showView:(YJActionSheetView *)view {
    view.bgView.alpha = 0;
    view.bottomConstraint.constant = CGRectGetHeight(self.bottomView.frame);
    [view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        view.bottomConstraint.constant = 0;
        view.bgView.alpha = 0.7;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeView:(YJActionSheetView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        view.bottomConstraint.constant = CGRectGetHeight(self.bottomView.frame);
        view.bgView.alpha = 0;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - Initlating

- (void)triggerInitlaze {
    self.bottomView.alpha = 1;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.headerTitleLabel.alpha = 1;
    [self.bottomView addSubview:self.headerTitleLabel];
    [self.bottomView addSubview:self.cancelBtn];
    [self.bottomView addSubview:self.line];
    [self.bottomView addSubview:self.tableView];
}

- (void)setHeaderString:(NSString *)headerString {
    _headerString = headerString;
    self.headerTitleLabel.text = headerString;
    CGFloat topSpacing = headerString ? 40 : 0;
    self.headerTitleHeight.constant = topSpacing;
    [self updateConstraintsIfNeeded];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        self.bottomConstraint = bottom;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:rowHeight + tableViewMaxHeight];
        self.bottomViewHeight = height;
        NSArray *constantArr = @[bottom, left, right, height];
        [self addConstraints:constantArr];
       
    }
    return _bottomView;
}

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc]init];
        _headerTitleLabel.text = self.headerString;
        _headerTitleLabel.textColor = [UIColor lightGrayColor];
        _headerTitleLabel.font = [UIFont systemFontOfSize:15];
        _headerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_headerTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_headerTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_headerTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_headerTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:_bottomView attribute:NSLayoutAttributeWidth multiplier:1 constant:-30];
        self.headerTitleHeight = height;
        NSArray *constantArr = @[top, centerX, height, width];
        [_bottomView addConstraints:constantArr];
    }
    return _headerTitleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.line attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:250];
        self.tableViewHeight = height;
        NSArray *constantArr = @[top, bottom, left, right, height];
        [_bottomView addConstraints:constantArr];
    }
    return _tableView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tapCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_line attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:rowHeight];
        NSArray *constantArr = @[top, bottom, left, right, height];
        [_bottomView addConstraints:constantArr];
    }
    return _cancelBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cancelBtn attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5];
        NSArray *constantArr = @[bottom, left, right, height];
        [_bottomView addConstraints:constantArr];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

@end
