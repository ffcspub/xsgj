//
//  TreeViewCell.h
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeViewData : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL bSelected;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end

@interface TreeData : NSObject

@property (assign, nonatomic) BOOL bSelected;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) id dataInfo;
@property (strong, nonatomic) NSMutableArray *children;

@end


@protocol TreeViewCellDelegate;

@interface TreeViewCell : UITableViewCell

@property (weak, nonatomic) id<TreeViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) TreeData *treeData;
@property (weak, nonatomic) TreeViewData *treeViewData;
@property (assign, nonatomic) int iDepthLevel;

- (IBAction)handlebtnSelected:(id)sender;

@end

@protocol TreeViewCellDelegate <NSObject>

- (void)onbtnSelectedClicked:(TreeViewCell *)cell;

@end
