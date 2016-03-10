//
//  ViewController.m
//  SmallCoreAnimationDemo
//
//  Created by 李璐 on 16/3/9.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#define MAS_SHORTHAND_GLOBALS

// 普通视图左右边距
#define WPedding 16

#define widthCuteButton (WScreenWidth - WPedding * 5)/4
#define heightCuteView widthCuteButton + WStatusBarHeight
// 动态获取屏幕宽高
#define WScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WScreenWidth ([UIScreen mainScreen].bounds.size.width)
// 状态栏高度
#define WStatusBarHeight (20.0)


@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray<UIButton*> * buttonArray;
@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,assign)CGFloat lastOffSet;

@end

static int buttonCounter = 8;

@implementation ViewController

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView * view = [[UIScrollView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.delegate = self;
        view.showsHorizontalScrollIndicator = NO;
        
        _scrollView = view;
    }
    return _scrollView;
}

-(NSArray *)buttonArray
{
    if (!_buttonArray) {
        NSMutableArray * array = [NSMutableArray array];
        
        UIButton * lastButton;
        for (int i = 0; i < buttonCounter; i++) {
            UIButton * button = [[UIButton alloc]init];
            button.tag = i + 10;
            [button addTarget:self action:@selector(cuteButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.scrollView.mas_left).offset(WPedding);
                }
                else
                {
                    make.left.equalTo(lastButton.mas_right).offset(WPedding);
                }
                make.bottom.equalTo(self.scrollView).offset(0);
                make.top.equalTo(self.scrollView).offset(WScreenHeight/2);
                make.height.width.equalTo(@(widthCuteButton));
                
                if (i == buttonCounter - 1) {
                    make.trailing.equalTo(self.scrollView).offset(-WPedding);
                }
            }];
            lastButton = button;
            
            
            button.layer.cornerRadius = widthCuteButton/2;
            button.clipsToBounds =YES;
            [array addObject:button];
        }//end for
        _buttonArray = array;
    }//end if
    return _buttonArray;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //统一加上一个CAGradientLayer
    for (UIButton * button in self.buttonArray) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = button.bounds;
        gradientLayer.locations = @[@(0.35),@(0.65)];
        gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor];
        
        [button.layer addSublayer:gradientLayer];
        
        [button bringSubviewToFront:button.titleLabel];
    }
    
}

-(void)cuteButtonTouch:(UIButton *)sender
{
    //button动画
    CATransition *lldonghua = [CATransition animation];
    lldonghua.duration = 1.0;
    lldonghua.type = @"rippleEffect";
    [sender.layer addAnimation:lldonghua forKey:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    [self.view addSubview:imageView];
    __weak typeof(self) weakSelf = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self buttonArray];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //和lastoffsize比较得出速度
    CGFloat speed = scrollView.contentOffset.x - self.lastOffSet;
    
    self.lastOffSet = scrollView.contentOffset.x;
    
    speed = speed/65;
    //动画
    [UIView animateWithDuration:0.1 animations:^{
        for (UIButton * button in self.buttonArray) {
            CGAffineTransform old = button.transform;
            button.transform = CGAffineTransformRotate(old, -speed);
        }
    }];
}

@end
