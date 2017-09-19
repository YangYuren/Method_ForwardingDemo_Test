//
//  ViewController.m
//  MessageForwardingTest
//
//
//  Created by Yanglaoshi on 17/9/18.
//
//

#import "ViewController.h"
#import "PersonModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PersonModel *personModel = [[PersonModel alloc] init];
    
    //快速消息转发  resolveInstanceMethod
    personModel.name = @"Jim Green";
    NSString *name = personModel.name;
    NSLog(@"%@", name);
    
    //标准消息转发 forwardingTargetForSelector
    name = [personModel companyName];
    NSLog(@"%@", name);
    //标准消息转发 forwardInvocation
    name = [personModel deptName];
    NSLog(@"%@", name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
