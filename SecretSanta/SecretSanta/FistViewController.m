//
//  FistViewController.m
//  SecretSanta
//
//  Created by Fatima Zenine Villanueva on 3/26/16.
//  Copyright © 2016 apps. All rights reserved.
//

#import "FistViewController.h"

@interface FistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation FistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.okButton.layer.cornerRadius = 40.0f;
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
