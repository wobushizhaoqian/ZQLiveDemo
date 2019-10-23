//
//  VideoCaptureViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "VideoCaptureViewController.h"


#import "AVCaptureSession/AVCaptureSessionViewController.h"
#import "AudioQueue/AudioQueueViewController.h"
#import "AudioUnit/AudioUnitViewController.h"



static NSString *identify = @"TBIdentify1";

@interface VideoCaptureViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation VideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"AVCaptureSession",@"AudioQueue",@"Audio Unit"];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
#pragma mark -- delegate/dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger selectedRow = indexPath.row;
    UIViewController *vc;
    switch (selectedRow) {
        case CaptureSelectedAVCaptureSession:{
            vc = [AVCaptureSessionViewController new];
        }
            break;
        case CaptureSelectedAudioQueue:{
            vc = [AudioQueueViewController new];
        }
            break;
        case CaptureSelectedAudioUnit:{
            vc = [AudioUnitViewController new];
        }
            break;
            
        default:
            break;
    }
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
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





@end
