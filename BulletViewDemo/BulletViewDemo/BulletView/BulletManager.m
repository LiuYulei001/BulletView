//
//  BarrageManager.m
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

@property(nonatomic,strong)NSMutableArray *dataSource;//资源来源

@property(nonatomic,strong)NSMutableArray *bulletComments;//临时资源

@property(nonatomic,strong)NSMutableArray *bulletViews;//弹幕view资源

@property(nonatomic,assign)BOOL isStop;//是否是停止状态判断

@end

@implementation BulletManager

-(instancetype)init
{
    if (self = [super init]) {
        
        self.isStop = YES;//初始化停止状态
    }
    return self;
}

- (void)start {
    
    if (!self.isStop) {
        return;
    }
    self.isStop = NO;
    
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}
- (void)initBulletComment {
    
    //设置弹道数量
    NSMutableArray *lines = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    
    for (int i = 0; i < 3; i++) {
        
        //获取随机弹道
        NSInteger index = arc4random()%lines.count;
        int line = [[lines objectAtIndex:index] intValue];
        [lines removeObjectAtIndex:index];
        
        NSString *content = [self.bulletComments firstObject];
        [self.bulletComments removeObjectAtIndex:0];
        
        [self createBulletView:content line:line];
    }
}
- (void)createBulletView:(NSString *)content line:(int)line
{
    if (self.isStop) {
        return;
    }
    //初始化弹道view
    BulletView *bulletView = [[BulletView alloc]initWithContent:content];
    bulletView.line = line;
    
    __weak typeof(bulletView) weakview = bulletView;
    __weak typeof(self) mySelf = self;
    bulletView.movingBlock = ^(moveState state){
        if (self.isStop) {
            return;
        }
        switch (state) {
            
            case start:{
                
                [mySelf.bulletViews addObject:weakview];
                
                break;
            }
            case enter:{
                
                //弹幕完全进入屏幕时 如果还有内容将继续获取后面的内容 （递归）
                NSString *content = [mySelf nextContent];
                if (content) {
                    [mySelf createBulletView:content line:line];
                }
                
                break;
            }
            case end:{
                
                //动画结束处理
                if ([mySelf.bulletViews containsObject:weakview]) {
                    
                    [weakview stopAnimation];
                    [mySelf.bulletViews removeObject:weakview];
                }
                //执行完毕可循环播放
                if (mySelf.bulletViews.count == 0) {
                    
                    mySelf.isStop = YES;
                    [mySelf start];
                }
                
                break;
            }
                
            default:
                break;
        }
    };
    
    //逐个将弹幕view回调
    if (self.generrateViewBlock) {
        self.generrateViewBlock(bulletView);
    }
}

- (NSString *)nextContent {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *content = [self.bulletComments firstObject];
    
    if (content) {
        
        [self.bulletComments removeObjectAtIndex:0];
    }
    
    return content;
}


- (void)stop {
    
    if (self.isStop) {
        return;
    }
    self.isStop = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
        
    }];
    
    [self.bulletViews removeAllObjects];
}


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1+++++",
                                                       @"弹幕2++++++++",
                                                       @"弹幕3++++++++++++",
                                                       @"弹幕4+++++",
                                                       @"弹幕5++++++++",
                                                       @"弹幕6+++++++",
                                                       @"弹幕7+++++",
                                                       @"弹幕8++++++++",
                                                       @"弹幕9++++++++++++++",
                                                       @"弹幕10+++++",
                                                       @"弹幕11++++++++",
                                                       @"弹幕12++++++++++"
                                                       ]];
    }
    return _dataSource;
}
-(NSMutableArray *)bulletComments
{
    if (!_bulletComments) {
        
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}
-(NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
