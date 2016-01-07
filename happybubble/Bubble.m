//
//  Bubble.m
//  happybubble
//
//  Created by Huatan on 15/12/29.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble


- (id)init {
    self = [super init];
    if (self) {
        [self createBubble];
    }
    
    return self;
}


- (void)createBubble {
    
    UIImage *img = [UIImage imageNamed:@"bubble"];

    //随机生成气泡的大小
    int width = (arc4random()%10)+30;
    self.contents = (__bridge id _Nullable)(img.CGImage);

    [self setBounds:CGRectMake(0, 0, width, width)];
}

@end
