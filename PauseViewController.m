//
//  PauseViewController.m
//  MultiPong
//
//  Created by Andrew Robinson on 12/23/15.
//  Copyright © 2015 Robinson Bros. All rights reserved.
//

#import "PauseViewController.h"
#import "GameViewController.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.50];
    
//    UIButton *resume = [[UIButton alloc] init];
//    [resume addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
//    [resume setTitle:@"Resume game" forState:UIControlStateNormal];
//    resume.backgroundColor = [UIColor whiteColor];
//    resume.titleLabel.textColor = [UIColor blackColor];
//    resume.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 50);
//    resume.layer.cornerRadius = 5.0f;
//    [self.view addSubview:resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resume:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GameViewController *game = [segue destinationViewController];
    [game resumeGame];
}

@end
