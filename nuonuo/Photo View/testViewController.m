//
//  testViewController.m
//  nuonuo
//
//  Created by LXX on 2019/12/2.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "testViewController.h"
#import "GKCycleScrollView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GKCycleScrollView *cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 130)];
    cycleScrollView.dataSource = self;
    [self.view addSubview:cycleScrollView];
    
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return 1;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
    }
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
    cell.imageView.image = [UIImage imageNamed:@"top"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}



@end
