//
//  ViewController.m
//  RAC_ChangColor
//
//  Created by 马朋飞 on 2017/12/11.
//  Copyright © 2017年 马朋飞. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redTextField.text = self.greenTextField.text = self.blueTextField.text = @"0.5";
    
    RACSignal *redSignal = [self blinderSlider:self.redSlider textField:self.redTextField];
    RACSignal *greenSignal = [self blinderSlider:self.greenSlider textField:self.greenTextField];
    RACSignal *blueSignal = [self blinderSlider:self.blueSlider textField:self.blueTextField];
    
    RACSignal *changeSignal = [[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }];
    RAC(self.colorView, backgroundColor) = changeSignal;
    
}

- (RACSignal *)blinderSlider:(UISlider *)slider textField:(UITextField *)textField {
    RACSignal *inputSignal = [textField rac_textSignal];
    RACChannelTerminal *silderSignal = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textSignal = [textField rac_newTextChannel];
    [[silderSignal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }] subscribe:textSignal];
    [textSignal subscribe:silderSignal];
    
    return [[textSignal merge:silderSignal] merge:inputSignal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
