//
//  DropDownView.m
//  DropdownDemo
//
//  Created by shenhua on 2018/9/13.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import "DropDownView.h"

#define kAniDuration 0.3f


@interface  DropDownView()<UITableViewDelegate,UITableViewDataSource>

///被选中的按钮
@property(nonatomic,strong) UIButton * selectedBtn;
///下拉数组
@property(nonatomic,strong)NSMutableArray *downListArray;
///下拉View
@property(nonatomic,strong)UITableView *listTableView;
///蒙板view
@property (nonatomic, strong) UIView *shadow;


@end


@implementation DropDownView



- (instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray *)topTitles downListArray:(NSArray *)downListArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (topTitles.count != downListArray.count) {
            [NSException raise:NSStringFromClass([DropDownView class]) format:@"按钮的数量和下拉的数量不一样"];
        }
        
        [self.downListArray addObjectsFromArray:downListArray];
        [self setupUIWithArray:topTitles];
        
    }
    return self;
}

-(void)setupUIWithArray:(NSArray *)array{
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW   = width/array.count*1.0;
    CGFloat btnH   = self.frame.size.height;
    for (int i=0; i<array.count; i++) {
        
        UIButton * topBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, btnH)];
        [topBtn setTitle:array[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        topBtn.tag = 444 + i ;
        if (i%2==0) {
            [topBtn setBackgroundColor:[UIColor purpleColor]];
        }else{
            [topBtn setBackgroundColor:[UIColor redColor]];
        }
        [self addSubview:topBtn];
        
    }
    
    
    
}

-(void)topBtnClick:(UIButton *)sender{
    
    if ([self.selectedBtn isEqual:sender]) {
        
        [self hidenListViewAnimation:YES];
        
    }else{
        
        self.selectedBtn.selected = NO;
        sender.selected =YES;
        self.selectedBtn = sender;
        
        [self showListViewAnimation];
        
    }
    
}

#pragma mark --点击背景色--
-(void)shadowViewClick{
    
    [self hidenListViewAnimation:YES];
    
}

///显示下拉列表
-(void)showListViewAnimation{
    
    ///添加监听
    UIView *superView = self.superview;
    if ([superView isKindOfClass:[UIScrollView class]]) {
        [superView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    UIWindow * windown = superView.window;
    [windown addSubview:self.shadow];
    [windown addSubview:self.listTableView];
    [self.listTableView reloadData];
    
    ///修改frame
    NSMutableArray *tableviewMsg = [self getTableViewMsg];

    CGFloat tableViewY = [tableviewMsg[0] floatValue];
    CGFloat tableViewH = [tableviewMsg[1] floatValue];
    
    CGRect frame = self.listTableView.frame;
    frame.origin.y = tableViewY;
    self.listTableView.frame=frame;
    
    self.shadow.frame = CGRectMake(self.frame.origin.x, tableViewY, self.frame.size.width, windown.frame.size.height - tableViewY);

    [UIView animateWithDuration:kAniDuration animations:^{
        
        CGRect frame = self.listTableView.frame;
        frame.size.height = tableViewH;
        self.listTableView.frame=frame;
        
        self.shadow.alpha = 1.0;
        
    }];
    
}

///隐藏下拉列表
-(void)hidenListViewAnimation:(BOOL)annimation{
    
    ///添加监听
    UIView *superView = self.superview;
    if ([superView isKindOfClass:[UIScrollView class]]) {
        [superView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    if (annimation) {
      
        [UIView animateWithDuration:kAniDuration animations:^{
            
            CGRect frame = self.listTableView.frame;
            frame.size.height = 0.0;
            self.listTableView.frame=frame;
            
            self.shadow.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self.listTableView removeFromSuperview];
            [self.shadow removeFromSuperview];
            self.selectedBtn.selected = NO;
            self.selectedBtn=nil;
            
        }];
        
    }else{
        
        CGRect frame = self.listTableView.frame;
        frame.size.height = 0.0;
        self.listTableView.frame=frame;
        
        self.shadow.alpha = 0.0;
        [self.listTableView removeFromSuperview];
        [self.shadow removeFromSuperview];
        self.selectedBtn.selected = NO;
        self.selectedBtn=nil;
        
    }
    
    
    
}

-(NSMutableArray *)getTableViewMsg{
    
    NSMutableArray *mutabArray = [NSMutableArray array];
    
    UIView * superView = self.superview;
    UIWindow * windown = superView.window;
    
    NSArray * listCount = self.downListArray[self.selectedBtn.tag-444];
    CGRect originalFrame = [self.superview convertRect:self.frame toView:windown];
    
    CGFloat superHeight = superView.frame.size.height;
    CGFloat downHeight  = superHeight - originalFrame.origin.y - originalFrame.size.height;
    CGFloat totalHeight = listCount.count*44;
    CGFloat finalHeight =  totalHeight > superHeight/3.0*2.0 ?  superHeight/3.0*2.0 : totalHeight;
    CGFloat tableViewH = downHeight > finalHeight  ?  finalHeight:downHeight ;
    
    CGFloat tableViewY = originalFrame.origin.y+originalFrame.size.height;

    [mutabArray addObject:@(tableViewY)];
    [mutabArray addObject:@(tableViewH)];
    
    return mutabArray;
    
}

#pragma mark --UITableViewDataSource--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.downListArray[self.selectedBtn.tag-444];
    return  array.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"RWNDropDownView";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *array = self.downListArray[self.selectedBtn.tag-444];
    cell.textLabel.text = array[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
//    [self hidenListViewAnimation:NO];
    
}

#pragma mark --懒加载--
-(NSMutableArray *)downListArray{
    
    if (!_downListArray) {
        _downListArray =[NSMutableArray array];
    }
    return _downListArray;
    
}

-(UITableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
        _listTableView.delegate=self;
        _listTableView.dataSource=self;
    }
    return _listTableView;
    
}

-(UIView *)shadow{
    
    if (!_shadow) {
        _shadow=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        _shadow.alpha = 0.f;
        _shadow.userInteractionEnabled = YES;
        _shadow.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewClick)];
        [_shadow addGestureRecognizer:tap];
    }
    return _shadow;
}

-(void)viewWillDissAppear{
    
    [self hidenListViewAnimation:NO];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
