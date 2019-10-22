//
//  ViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell/Custom1TableViewCell.h"

#define KCellHeight 60
static NSString *identiify = @"TBIdentify";


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *titles;
@property (nonatomic, strong)NSMutableDictionary *controllerNameDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = [@[] mutableCopy];
    self.controllerNameDic = [@{} mutableCopy];
    [self initilizeDatas];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"直播-技术总结";
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
}

#pragma mark -- private mehods

- (void)initilizeDatas{
    [self addCellWithTitle:@"音视频采集" ControllerName:@"VideoCaptureViewController"];
    [self addCellWithTitle:@"音视频处理" ControllerName:@"VideoProcessingViewController"];
    [self addCellWithTitle:@"音视频编码" ControllerName:@"VideoCodingViewController"];
    [self addCellWithTitle:@"音视频推流" ControllerName:@"VideoPushStreamingViewController"];
    [self addCellWithTitle:@"音视频分流" ControllerName:@"VideoPullStreamingViewController"];
    [self addCellWithTitle:@"音视频播放" ControllerName:@"VideoPlaybackViewController"];
    
}

- (void)addCellWithTitle:(NSString *)title ControllerName:(NSString *)controllerName{
    [self.titles addObject:title];
    [self.controllerNameDic setObject:controllerName forKey:title];
}


#pragma mark -- lazy loading
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}


#pragma mark -- delegate/dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Custom1TableViewCell *cell = (Custom1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:identiify];
    if (!cell) {
        cell = [[Custom1TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identiify parentSize:CGSizeMake(self.view.bounds.size.width, KCellHeight)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = [self.titles objectAtIndex:indexPath.row];
    cell.headrImageView.image = [UIImage imageNamed:[self.titles objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString([self.controllerNameDic objectForKey:[self.titles objectAtIndex:indexPath.row]]);
    UIViewController *vc = [class new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = [self.titles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES]; 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCellHeight;
}

@end
