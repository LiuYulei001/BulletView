//
//  BarrageManager.h
//  BulletViewDemo
//
//  Created by Rainy on 2017/9/14.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BulletView;

@interface BulletManager : NSObject

//将创建的弹幕逐个回调给控制器
@property(nonatomic,copy)void (^generrateViewBlock)(BulletView *view);

- (void)start;

- (void)stop;

@end
