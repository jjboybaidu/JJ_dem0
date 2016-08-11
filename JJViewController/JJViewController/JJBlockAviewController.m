//
//  JJBlockAviewController.m
//  JJViewController
//
//  Created by farbell-imac on 16/8/11.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJBlockAviewController.h"
#import "JJBlockBviewController.h"

@interface JJBlockAviewController()

@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)JJBlockBviewController *bviewcontroller;

@end

@implementation JJBlockAviewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self setupAviewController];
}

- (void)setupAviewController{
    
    float btnwidth = 200;
    float btnheight = 50;
    float btnx = (self.view.frame.size.width - btnwidth)/2;
    float btny = self.view.center.y-150;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnx, btny, btnwidth, btnheight)];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn addTarget:self action:@selector(groupValue) forControlEvents:UIControlEventTouchDown];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"编辑个人信息" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
    
    float phoneLabelwidth = 200;
    float phoneLabelheight = 50;
    float phoneLabelx = (self.view.frame.size.width - btnwidth)/2;
    float phoneLabely = self.view.center.y-150 + btnheight;
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneLabelx, phoneLabely, phoneLabelwidth, phoneLabelheight)];
    [self.view addSubview:self.phoneLabel];
    
    float nameLabelwidth = 200;
    float nameLabelheight = 50;
    float nameLabelx = (self.view.frame.size.width - btnwidth)/2;
    float nameLabely = self.view.center.y-150 + btnheight + phoneLabelheight;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelx, nameLabely, nameLabelwidth, nameLabelheight)];
    [self.view addSubview:self.nameLabel];
}

// 点击跳到Bviewcontroller
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // stringVlaue
    // [self stringValue];
    
    // colorValue
    // [self colorValue];
    
    
}

// groupValue
- (void)groupValue{
    self.bviewcontroller = [[JJBlockBviewController alloc]init];
    __weak typeof(self) weakSelf = self;
    self.bviewcontroller.JJBlockBviewControllerBlockGroup = ^(NSString *phone,NSString *name){

            // [strongSelf setPhoneandname:phone name:name];
            
            weakSelf.phoneLabel.text = phone;
            weakSelf.nameLabel.text = name;
        
    };
    
    [self.navigationController pushViewController:self.bviewcontroller animated:YES];
}
- (void)setPhoneandname:(NSString*)phone name:(NSString*)name{
    self.phoneLabel.text = phone;
    self.nameLabel.text = name;
}


// stringValue
- (void)stringValue{
    JJBlockBviewController *bviewcontroller = [[JJBlockBviewController alloc]init];
    bviewcontroller.JJBlockBviewControllerBlock = ^(NSString *string){
        [self printBlockValue:string];
    };
    [self.navigationController pushViewController:bviewcontroller animated:YES];
}
- (void)printBlockValue:(NSString *)string{
    NSLog(@"%@",string);
}


// colorValue
- (void)colorValue{
    JJBlockBviewController *bviewcontroller = [[JJBlockBviewController alloc]init];
    bviewcontroller.backgroundColor = ^(UIColor *color){
        [self setBackGroundColor:color];
    };
    [self.navigationController pushViewController:bviewcontroller animated:YES];
}
- (void)setBackGroundColor:(UIColor *)color{
    self.view.backgroundColor = color;
}





@end
