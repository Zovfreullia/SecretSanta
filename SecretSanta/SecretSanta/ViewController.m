//
//  ViewController.m
//  SecretSanta
//
//  Created by Fatima Zenine Villanueva on 12/16/15.
//  Copyright © 2015 apps. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewSanta;
@property (weak, nonatomic) IBOutlet UITextField *enterNameField;
@property (weak, nonatomic) IBOutlet UITextField *enterEmailField;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (nonatomic) NSMutableArray *shuffledArr;
@property (nonatomic) NSMutableArray *unshuffledArr;
@end

@implementation ViewController


- (NSMutableArray *)returnThisArrayOfStudents {
    
    NSMutableArray *arrayOfStudents = [[NSMutableArray alloc]init];
    
    NSArray *names = @[

                       ];
    
    NSArray *emails = @[

                        ];
    
    for (int i = 0; i < names.count; i++) {
        Person *secretSanta = [[Person alloc]init];
        secretSanta.name = [names objectAtIndex:i];
        secretSanta.email = [emails objectAtIndex:i];
        [arrayOfStudents addObject:secretSanta];
    }
    
    return arrayOfStudents;
}

- (void)sendMailgunEmail:(NSString*)email yourSecretSanta:(NSString*)name {
    Mailgun *mailgun = [Mailgun clientWithDomain:@"" apiKey:@""];
    [mailgun sendMessageTo:email
                      from:@""
                   subject:@"Secret Santa - C4Q!"
                      body:[NSString stringWithFormat:@"Your secret santa is %@", name]];
}

#pragma mark
#pragma mark - Life Cycle Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self returnThisArrayOfStudents];
    for (int i = 0; i < [self returnThisArrayOfStudents].count; i++){
        Person *this = [[Person alloc]init];
        this = [[self returnThisArrayOfStudents] objectAtIndex:i];
        NSLog(@"Name:%@ -- Email:%@", this.name, this.email);
    }
    
    self.shuffledArr = [[NSMutableArray alloc]init];
    self.unshuffledArr = [[NSMutableArray alloc]init];
    
    [self.unshuffledArr addObjectsFromArray:[self returnThisArrayOfStudents]];
    
    self.tableViewSanta.delegate = self;
    self.tableViewSanta.dataSource = self;
    self.enterNameField.delegate = self;
    self.enterEmailField.delegate = self;
}

#pragma mark
#pragma mark - Action Methods
- (IBAction)shuffleButtonAction:(id)sender {
    
//    [self sendMailgunEmail];
    
    [self.shuffledArr addObjectsFromArray:self.unshuffledArr];

    for (int i = 0; i < self.shuffledArr.count; i++){
        [self.shuffledArr exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    [self.tableViewSanta reloadData];
    
    self.shuffleButton.enabled = NO;
}

- (IBAction)addUserInTableButton:(id)sender completion:(Person*(^)(void))addPerson{
    addPerson = ^Person*(void) {
        Person *newPerson = [[Person alloc]init];
        newPerson.name = self.enterNameField.text;
        newPerson.email = self.enterEmailField.text;
        NSLog(@"name: %@", newPerson.name);
        NSLog(@"email: %@", newPerson.email);
        return newPerson;
    };
    
    [self.unshuffledArr addObject:addPerson()];
    NSLog(@"unshuffled arr: %@", self.unshuffledArr);
}

#pragma mark
#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    Person *student = [self.unshuffledArr objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.unshuffledArr.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.unshuffledArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } 
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tableView.frame.size.width, 20)];
    [sectionLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [sectionLabel setText:@"Secret Santa Participants"];
    [sectionView addSubview:sectionLabel];
    [sectionView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:100/255.0 blue:100/255.0 alpha:1.0]];
    return sectionView;
}

#pragma mark
#pragma mark - Text Field Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tableViewSanta reloadData];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableViewSanta indexPathForSelectedRow];
    Person *secret = [self.shuffledArr objectAtIndex:selectedIndexPath.row];
    Person *student = [self.unshuffledArr objectAtIndex:selectedIndexPath.row];
    
    NSLog(@"Person: %@ Secret Santa: %@", student.name, secret.name);
    [self sendMailgunEmail:student.email yourSecretSanta:secret.name];
    DetailViewController *vc = segue.destinationViewController;
    vc.matchName = secret.name;
}

@end
