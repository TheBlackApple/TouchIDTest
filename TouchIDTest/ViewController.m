//
//  ViewController.m
//  TouchIDTest
//
//  Created by Charles Leo on 15/1/16.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "PresentViewController.h"

@interface ViewController ()
{
    BOOL isOpen;
}
@property (weak, nonatomic) IBOutlet UIButton *mButton;
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)buttonClick:(id)sender {
    PresentViewController * presentView = [[PresentViewController alloc]init];
    [self presentViewController:presentView animated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!isOpen) {
        BOOL isOk = [self canEvalautePolicy];
        if (isOk) {
            [self evaluatePolicy];
        }
    }
   
}
- (BOOL)canEvalautePolicy
{
     LAContext * context = [[LAContext alloc]init];
    __block NSString * msg;
    NSError * error;
    BOOL success;
    success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        msg = [NSString stringWithFormat:NSLocalizedString(@"TOUCH_ID_IS_AVAILABLE", nil)];
         NSLog(@"msg is %@",msg);
        return YES;
    }
    else
    {
        msg = [NSString stringWithFormat:NSLocalizedString(@"", nil)];
         NSLog(@"msg is %@",msg);
        return NO;
    }
   
}


-(void)evaluatePolicy
{
    LAContext * context = [[LAContext alloc]init];
    context.localizedFallbackTitle = @"";

    __block NSString * msg;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"请输入正确指纹，解锁进入应用。", nil) reply:^(BOOL success, NSError *error) {
        if (success) {
            msg = [NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_SUCCESS", nil)];
            isOpen = YES;
             NSLog(@"msg is %@",msg);
        }
        else
        {
             msg = [NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_WITH_ERROR", nil), error.localizedDescription];
             NSLog(@"msg is %@",msg);
            isOpen = NO;
            [self evaluatePolicy];
        }
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
