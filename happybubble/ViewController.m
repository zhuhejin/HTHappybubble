//
//  ViewController.m
//  happybubble
//
//  Created by Huatan on 15/12/29.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "ViewController.h"
#import "Bubble.h"

#define KMaxTimes 5

@interface ViewController ()

@end

@implementation ViewController

//连续产生多个气泡
float _duration; // 动画 间隔
float _lastTime; //纪录每一个点的 时刻
int _index;
NSMutableArray *totlePoints; //纪录所有的点。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    totlePoints = [NSMutableArray array];
    
    [self shotSomeBubble:nil];
}

- (void)creatBubble {
    
    Bubble *bubble = [[Bubble alloc] init];
    
    //保证气泡不出界
    //随机的x
    int x = [self getRandomNumber:10 to:(int)self.view.frame.size.width - bubble.bounds.size.width];
    CGRect startFrame = CGRectMake(x, 500, bubble.bounds.size.width, bubble.bounds.size.height);
    bubble.frame = startFrame;
    [self.view.layer addSublayer:bubble];
    
    [self configerRisingAnimation:bubble];
}


//上升动画
- (void)configerRisingAnimation:(Bubble *)bubble {

    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.fromValue = [NSValue valueWithCGPoint:bubble.position];
    CGPoint toPoint = bubble.position;
    toPoint.y = 0;
    animation1.toValue = [NSValue valueWithCGPoint:toPoint];
    
    //加速移动
    animation1.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.80 :0.27 :0.95 :0.89];
    
    CABasicAnimation *scaoleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.autoreverses = NO;
    scaoleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaoleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO; //动画结束后进行逆动画
    group.duration = 3.0;
    group.animations = [NSArray arrayWithObjects:animation1,scaoleAnimation, nil];
    group.repeatCount = 0;
    
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate = self;
    [group setValue:bubble forKey:@"first"];
    
    [bubble addAnimation:group forKey:@"kkLayerMove"];
}

//动画结束后layer移除
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        
        if ([anim isKindOfClass:[CAAnimationGroup class]]) {
            
            CAAnimationGroup *group = (CAAnimationGroup *)anim;
            
            CALayer *layer = [group valueForKey:@"first"];
            
            [layer removeFromSuperlayer];
        }else if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
            
            CAKeyframeAnimation *key = (CAKeyframeAnimation *)anim;
            
            CALayer *layer = [key valueForKey:@"second"];
            
            [layer removeFromSuperlayer];
        }
    }
}

- (IBAction)shotOneBubble:(id)sender {
    
    _index =0;
    

    Bubble *bubble = [[Bubble alloc] init];
    
    //保证气泡不出界
    //随机的x
    int x = [self getRandomNumber:10 to:(int)self.view.frame.size.width - bubble.bounds.size.width];
    CGRect startFrame = CGRectMake(x, 500, bubble.bounds.size.width, bubble.bounds.size.height);
    bubble.frame = startFrame;
    [self.view.layer addSublayer:bubble];

    //关键帧动画
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath = @"position";
    
    UIBezierPath *airplanePath = [UIBezierPath bezierPath];
    [airplanePath moveToPoint: CGPointMake(100, 500)];
    [airplanePath addCurveToPoint: CGPointMake(100, 400) controlPoint1: CGPointMake(0, 474) controlPoint2: CGPointMake(0, 435)];
    [airplanePath addCurveToPoint: CGPointMake(100, 200) controlPoint1: CGPointMake(200, 350) controlPoint2: CGPointMake(200, 250)];
    [airplanePath addCurveToPoint: CGPointMake(100, 0) controlPoint1: CGPointMake(0, 150) controlPoint2: CGPointMake(0, 50)];
    
    animation.path = airplanePath.CGPath;
    
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 4.0f;
    animation.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.80 :0.27 :0.95 :0.89];
    animation.delegate=self;
    [animation setValue:bubble forKey:@"second"];
    [bubble addAnimation:animation forKey:nil];
    
    
}

- (IBAction)shotSomeBubble:(id)sender {
    
    _lastTime = 0.0;
    
    _duration = 0.0;
    
    _index =0;
    
    [totlePoints removeAllObjects];
    
    for (int i = 0; i <= KMaxTimes; i++) {
        
        //两个气泡之间的时间间隔  随机的
        int int1 = (arc4random()%5)+1;
        float f = (float)int1/50;
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:f] , nil];
        
        [totlePoints addObject:array];
    }
    
    [self run];
}

- (void)run {
    
    if (_index >= KMaxTimes) {
        return;
    }else{
        NSArray *pointValues = [totlePoints objectAtIndex:_index];
        _index++;
        float currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        float timeDuration = currentTime + _lastTime;
        _lastTime = currentTime;
        
        [self creatBubble];
        
        [self performSelector:@selector(run) withObject:nil afterDelay:timeDuration];
    }
}

-(int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
