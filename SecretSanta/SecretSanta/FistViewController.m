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


@end
