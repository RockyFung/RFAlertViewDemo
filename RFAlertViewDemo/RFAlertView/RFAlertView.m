//
//  RFAlertView.m
//  RFAlertViewDemo
//
//  Created by rocky on 16/10/18.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#define KMainScreenRect [UIScreen mainScreen].bounds
#define KAlertView_W     270.0f
#define KMessageMin_H    60.0f       //messagelab的最小高度
#define KMessageMAX_H    120.0f      //messagelab的最大高度，当超过时，文本会以...结尾
#define KTitle_H      20.0f
#define KBtn_H        30.0f

#define KBlueColor        [UIColor colorWithRed:9/255.0 green:170/255.0 blue:238/255.0 alpha:1]
#define KRedColor         [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define KLightGrayColor   [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#define KTitleFont       [UIFont boldSystemFontOfSize:17];
#define KMessageFont     [UIFont systemFontOfSize:14];
#define KBtnTitleFont    [UIFont systemFontOfSize:15];

#import "RFAlertView.h"
#import "UILabel+AlertAdd.h"

@interface RFAlertView()

@property (nonatomic,strong)UIWindow *alertWindow;
@property (nonatomic,strong)UIView *alertView;

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *otherBtn;

@end


@implementation RFAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(RFAlertClickIndexBlock)block{
    if(self=[super init]){
        self.frame = KMainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=10.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        
        if (title) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, KAlertView_W, KTitle_H)];
            _titleLab.text=title;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=[UIColor blackColor];
            _titleLab.font=KTitleFont;
            
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.text=message;
        _messageLab.textColor=[UIColor lightGrayColor];
        _messageLab.font=KMessageFont;
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:KAlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < KMessageMin_H?KMessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > KMessageMAX_H?KMessageMAX_H:messageLabAotuH;
        _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+10, KAlertView_W-messageLabSpace*2, endMessageLabH);
        
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, KAlertView_W, _messageLab.frame.size.height+KTitle_H+KBtn_H+40);
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cancelTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:KLightGrayColor] forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font=KBtnTitleFont;
            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_cancelBtn];
        }
        
        if (otherBtnTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=KBtnTitleFont;
            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            [_otherBtn setBackgroundImage:[UIImage imageWithColor:KRedColor] forState:UIControlStateNormal];
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }
        
        CGFloat btnLeftSpace = 40;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-40;
        if (cancelTitle && !otherBtnTitle) {
            _cancelBtn.tag = 0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, KAlertView_W-btnLeftSpace*2, KBtn_H);
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag = 0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, KAlertView_W-btnLeftSpace*2, KBtn_H);
        }else if (cancelTitle && otherBtnTitle){
            _cancelBtn.tag = 0;
            _otherBtn.tag = 1;
            CGFloat btnSpace = 20;//两个btn之间的间距
            CGFloat btn_w =(KAlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, KBtn_H);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, KBtn_H);
        }
        
        self.clickBlock=block;
        
    }
    return self;
}


-(void)btnClick:(UIButton *)btn{
    
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
    
}

-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss=dontDissmiss;
}

-(void)showRFAlertView{
    
    
    
    _alertWindow=[[UIWindow alloc] initWithFrame:KMainScreenRect];
    _alertWindow.windowLevel=UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    
    [_alertWindow addSubview:self];
    
    [self setShowAnimation];
    
}

-(void)dismissAlertView{
    [self removeFromSuperview];
    [_alertWindow resignKeyWindow];
}

-(void)setShowAnimation{
    
    switch (_animationStyle) {
            
        case RFShowAnimationDefault:
        {
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_alertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [_alertView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [_alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case RFShowAnimationLeftShake:{
            
            CGPoint startPoint = CGPointMake(-KAlertView_W, self.center.y);
            _alertView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _alertView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case RFShowAnimationTopShake:{
            
            CGPoint startPoint = CGPointMake(self.center.x, -_alertView.frame.size.height);
            _alertView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _alertView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case RFShowAnimationNO:{
            
        }
            
            break;
            
        default:
            break;
    }
    
}


-(void)setAnimationStyle:(RFShowAnimationStyle)animationStyle{
    _animationStyle = animationStyle;
}


@end

@implementation UIImage (Colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

