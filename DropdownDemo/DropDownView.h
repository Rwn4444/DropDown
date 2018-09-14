//
//  DropDownView.h
//  DropdownDemo
//
//  Created by shenhua on 2018/9/13.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface DropDownView : UIView


/**
 初始化方法

 @param frame 位置
 @param topTitles 顶部标题
 @param downListArray 下拉标题
 @return 当前对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    topTitles:(NSArray *)topTitles
                downListArray:(NSArray *)downListArray;

/**
 页面消失的时候把弹框销毁
 */
-(void)viewWillDissAppear;


@end
