//
//  XCMultiTableViewBGScrollView.m
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

@implementation XCMultiTableViewBGScrollView {
    NSMutableArray *lines;
}

@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reDraw
{
    /*
    if (lines == nil) lines = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (UIView *view in lines) {
        [view removeFromSuperview];
    }
    
    [lines removeAllObjects];

    
    UIView *hidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f - parent.normalSeperatorLineWidth, 0, parent.normalSeperatorLineWidth, self.bounds.size.height)];
    hidView.backgroundColor = parent.normalSeperatorLineColor;
    hidView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self addSubview:hidView];
    [lines addObject:hidView];

    UIView *line = nil;
    CGFloat x = 0.0f;
    CGFloat height = 0.f;
    
    if ([parent.datasource respondsToSelector:@selector(topHeaderHeightInTableView:)]) {
        height = [parent.datasource topHeaderHeightInTableView:parent];
    }
    NSLog(@"height:%f", height);
    
    // 这里应该遍历所有的分区，由于我们的项目需求默认只需要一个分区，所以暂时不管这些
    int rows = 0;
    if ([parent.datasource respondsToSelector:@selector(arrayDataForContentInTableView:InSection:)]) {
        rows = [parent.datasource arrayDataForContentInTableView:parent InSection:0].count;
    }
    NSLog(@"rows:%d", rows);
    height += rows *40.f;
    
    NSUInteger columnCount = [parent.datasource arrayDataForTopHeaderInTableView:parent].count;
    for (int i = 0; i < columnCount; i++) {
        CGFloat width;
        if ([parent.datasource respondsToSelector:@selector(tableView:contentTableCellWidth:)]) {
            width = [parent.datasource tableView:parent contentTableCellWidth:i];
        }else {
            width = parent.cellWidth;
        }
        
        x += width + parent.normalSeperatorLineWidth;

        line = [self addVerticalLineWithWidth:parent.normalSeperatorLineWidth height:height bgColor:parent.normalSeperatorLineColor atX:x];
        [lines addObject:line];
    }
    */
}

- (void)dealloc
{
    lines = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, parent.normalSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    
    NSUInteger columnCount = [parent.headData count];
    for (int i = 0; i <= columnCount; i++) {
        CGFloat x = i * parent.cellWidth;
        CGContextMoveToPoint(context, x, 0.0f);
        CGContextAddLineToPoint(context, x, self.bounds.size.height);
    }
    
    CGContextStrokePath(context);

}
 */

@end
