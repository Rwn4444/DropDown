//
//  ViewController.m
//  DropdownDemo
//
//  Created by shenhua on 2018/9/13.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import "ViewController.h"
#import "DropDownView.h"
#import "TableViewHeaderView.h"
#import "HomeViewController.h"

#define kScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight    [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) DropDownView *dropView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TableViewHeaderView *header =[[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    header.backgroundColor=[UIColor yellowColor];
    self.tableview.tableHeaderView = header;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.dropView viewWillDissAppear];
    
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    DropDownView *drop = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) topTitles:@[@"年级",@"等级",@"科目"] downListArray:@[@[@"一年级",@"二年级",@"三年级"],@[@"初级",@"中级",@"高级"],@[@"语文",@"数学",@"英语",@"地理"]]];
    self.dropView = drop;
    return drop;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeViewController * home = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:home animated:YES];
    
}


@end
