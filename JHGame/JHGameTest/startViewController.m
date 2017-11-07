//
//  startViewController.m
//  JHGameTest
//
//  Created by song on 2016. 11. 30..
//  Copyright © 2016년 iPhyon. All rights reserved.
//

#import "startViewController.h"
#import "ViewController.h"

@interface startViewController ()

@end

@implementation startViewController

//mode설정
- (IBAction)myMusic:(UIButton *)sender {
    [self playgame:@"mymusic"];
}
- (IBAction)basicMusic:(UIButton *)sender {
    [self playgame:@"basicmusic"];
}

//화면전환
- (void)playgame:(NSString*)mode{
    ViewController * playViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    playViewController.playmode = mode;
    [self.navigationController pushViewController:playViewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
