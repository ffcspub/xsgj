//
//  TreeViewCell.m
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TreeViewCell.h"

#define LevelWidth  20

@implementation TreeViewData

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}

@end

@implementation TreeData

- (id)init
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation TreeViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIDepthLevel:(int)iDepthLevel
{
    // reset
    self.btnExpand.frame = CGRectMake(10, 12, 20, 20);
    self.btnSelected.frame = CGRectMake(35, 0, 44, 44);
    self.lbName.frame = CGRectMake(87, 10, 120, 26);
    
    CGRect frame = self.btnExpand.frame;
    if(frame.origin.x == 10)
    {
        frame.origin.x += LevelWidth * iDepthLevel;
        self.btnExpand.frame = frame;
        
        frame = self.btnSelected.frame;
        frame.origin.x += LevelWidth * iDepthLevel;
        self.btnSelected.frame = frame;
        
        frame = self.lbName.frame;
        frame.origin.x += LevelWidth * iDepthLevel;
        self.lbName.frame = frame;
    }
    

}

- (IBAction)handlebtnSelected:(id)sender
{
    self.btnSelected.selected = !self.btnSelected.selected;
    if(_delegate && [_delegate respondsToSelector:@selector(onbtnSelectedClicked:)])
    {
        [_delegate onbtnSelectedClicked:self];
    }
}

@end
