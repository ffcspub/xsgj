//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, SortColumnType) {
    SortColumnTypeInteger,
    SortColumnTypeFloat,
    SortColumnTypeDate,
};

@protocol XCMultiTableViewDataSource;

@interface XCMultiTableView : UIView

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@property (nonatomic, assign) CGFloat leftHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat boldSeperatorLineWidth;
@property (nonatomic, assign) CGFloat normalSeperatorLineWidth;

@property (nonatomic, strong) UIColor *boldSeperatorLineColor;
@property (nonatomic, strong) UIColor *normalSeperatorLineColor;
@property (nonatomic, strong) UIColor *cellTextColor;
@property (nonatomic, strong) UIColor *headerTextColor;

@property (nonatomic, assign) BOOL leftHeaderEnable; // 左侧是否固定
@property (nonatomic, assign) BOOL shouldShowSection; // 是否显示分区视图
@property (nonatomic, assign) BOOL shouldSortEnable; // 是否开启点击标题排序，默认为NO
@property (nonatomic, assign) BOOL isExpandable; // 是否开启点击左侧标题伸缩，默认为NO

@property (nonatomic, weak) id<XCMultiTableViewDataSource> datasource;

- (void)reloadData;

@end

@protocol XCMultiTableViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;
- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;

@optional
- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView;
- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column;
- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView;
- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column;
- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column;
- (NSString *)titleForHeaderInTableView:(XCMultiTableView *)tableView;

@end
