//
//  ViewController.m
//  RFAlertViewDemo
//
//  Created by rocky on 16/10/18.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "ViewController.h"
#import "RFAlertView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"缩放", @"左边弹出", @"上面落下",@"无动画"];
    
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = (NSString *)obj;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50 + (idx + 1) * 50, 100, 40)];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [self.view addSubview:btn];
        
        
    }];
    
}
- (void)clickBtn:(UIButton *)btn{
    
    NSArray *titles = @[@"缩放", @"左边弹出", @"上面落下",@"无动画"];
    NSString *meg = @"自定义alertview,可以自动适应文字内容。自定义alertview,可以自动适应文字内容。";
    RFShowAnimationStyle style = RFShowAnimationNO;
    if (btn.tag == 0) {
        style = RFShowAnimationDefault;
    }else if (btn.tag == 1){
        style = RFShowAnimationLeftShake;
    }else if (btn.tag == 2){
        style = RFShowAnimationTopShake;
    }else{
        style = RFShowAnimationNO;
    }
    
    RFAlertView *alert = [[RFAlertView alloc]initWithTitle:titles[btn.tag] message:meg cancelBtnTitle:@"cancel" otherBtnTitle:@"ok" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击了第%ld个按钮",clickIndex);
    }];
    alert.animationStyle = style;
    [alert showRFAlertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
