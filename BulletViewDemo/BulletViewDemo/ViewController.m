//
//  ViewController.m
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()

@property(nonatomic,strong)BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.manager = [[BulletManager alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.manager.generrateViewBlock = ^(BulletView *view){
        
        [weakSelf addBarrageView:view];
    };
}


- (IBAction)Stop:(UIButton *)sender {
    [self.manager stop];
}
- (IBAction)start:(UIButton *)sender {
    
    [self.manager start];
    
}

- (void)addBarrageView:(BulletView *)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 150 + view.line * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}


@end
