//
//  ViewController.m
//  SecretSanta
//
//  Created by Fatima Zenine Villanueva on 12/16/15.
//  Copyright © 2015 apps. All rights reserved.
//
#import "ViewController.h"

#define API_KEY @""
#define CLIENT_DOMAIN @""
#define SOURCE_EMAIL @""


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewSanta;
@property (weak, nonatomic) IBOutlet UITextField *enterNameField;
@property (weak, nonatomic) IBOutlet UITextField *enterEmailField;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) NSMutableArray *shuffledArr;
@property (nonatomic) NSMutableArray *unshuffledArr;
@end

@implementation ViewController


#pragma mark
#pragma mark - Life Cycle Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hides send button in initial view
    self.sendButton.hidden = YES;
    
    // Allocates memory to arrays needed for storing students
    self.shuffledArr = [[NSMutableArray alloc]init];
    self.unshuffledArr = [[NSMutableArray alloc]init];
    
    // Allows this class to use these delegates
    self.tableViewSanta.delegate = self;
    self.tableViewSanta.dataSource = self;
    self.enterNameField.delegate = self;
    self.enterEmailField.delegate = self;
}

#pragma mark
#pragma mark - Action Button Methods

- (IBAction)shuffleButtonAction:(id)sender {
    
    // Pops up an alert to confirm whether the player wants to shuffle
    [self activatingAlertControllerAfterActionButton:@"shuffle"];
}

- (void)shuffleTheItemsInsideTheArray {
    
    NSLog(@"Shuffled items!");
    
    // Adds objects from the unshuffled array to the shuffled array
    [self.shuffledArr addObjectsFromArray:self.unshuffledArr];
    
    // Shuffled array is now being shuffled
    for (int i = 0; i < self.shuffledArr.count; i++){
        [self.shuffledArr exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    // Deactivates the shuffle button to prevent further shuffling
    self.shuffleButton.hidden = YES;
    
    // Activates the send button after shuffle is pressed
    self.sendButton.hidden = NO;
}

- (IBAction)sendPlayersTheirSecretSantaViaEmail:(UIButton *)sender {
    
    [self activatingAlertControllerAfterActionButton:@"send"];
}

- (void)sendPlayersTheirSecretSanta {
    // Send Secret Santa email to everyone on the list
    for (int i = 0; i < self.shuffledArr.count; i++) {
        Person *person = [self.shuffledArr objectAtIndex:i];
        [self sendMailgunEmail:person.name yourSecretSanta:person.email];
    }
}

- (IBAction)addUserInTableButton:(id)sender completion:(Person*(^)(void))addPerson{
    addPerson = ^Person*(void) {
        
        // This is a completion block that instantiates a new object or secret santa person
        Person *newPerson = [[Person alloc]init];
        newPerson.name = self.enterNameField.text;
        newPerson.email = self.enterEmailField.text;
        NSLog(@"name: %@", newPerson.name);
        NSLog(@"email: %@", newPerson.email);
        return newPerson;
    };
    
    // Calls the completion block written above to add the object to unshuffled array
    [self.unshuffledArr addObject:addPerson()];
    
    // Reloads the table view data
    [self.tableViewSanta reloadData];
    
    // Checks if the object is added inside the array
    NSLog(@"unshuffled arr: %@", self.unshuffledArr);
}

#pragma mark
#pragma mark - Text Field Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Reload the table view data
    [self.tableViewSanta reloadData];
    
    // Keyboard will resign when user is done typing
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark
#pragma mark - MailGun API
- (void)sendMailgunEmail:(NSString*)email yourSecretSanta:(NSString*)name {
    
    // Creates a new mailgun object with doman and api key
    Mailgun *mailgun = [Mailgun clientWithDomain:CLIENT_DOMAIN
                                          apiKey:API_KEY];
    
    // Mailgun object calls a method to send an email with the secret santa message
    [mailgun sendMessageTo:email
                      from:SOURCE_EMAIL
                   subject:@"ENTER SUBJECT HEADLINE"
                      body:[NSString stringWithFormat:@"Woo! Your secret santa is %@", name]];
}

#pragma mark
#pragma mark - Alert Controller
- (void)activatingAlertControllerAfterActionButton: (NSString*)sendOrShuffle{
    
    NSString *message = [NSString stringWithFormat:@"Do you want to %@ the list?", sendOrShuffle];
    
    // Alert controller is instantiated to manage pop-ups and alert actions (buttons)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Secret Santa"
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    // 'Cancel' button action that stops the player from shuffling
    UIAlertAction * cancel_action = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];
    
    // 'Cancel' button action is added to the alert view
    [alert addAction:cancel_action];
    
    // 'OK' button action that calls the shuffle method to mix up the unshuffled array
    UIAlertAction *ok_action = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          if ([sendOrShuffle isEqualToString:@"shuffle"]) {
                                                              [self shuffleTheItemsInsideTheArray];
                                                          }
                                                          else if ([sendOrShuffle isEqualToString:@"send"]) {
                                                              [self sendPlayersTheirSecretSanta];
                                                          }
                                                          ;
                                                      }];
    
    // 'OK' button action is added to the alert view
    [alert addAction:ok_action];
    
    // Alert controller view is presented on the main view controller
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark
#pragma mark - Table View Data Source Methods

#pragma mark - Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Table wiew cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    Person *student = [self.unshuffledArr objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    return cell;
}

#pragma mark - Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.unshuffledArr.count;
}

#pragma mark - Table view cell removal
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.unshuffledArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view style
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, tableView.frame.size.width, 20)];
    [sectionLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [sectionLabel setText:@"Secret Santa Participants"];
    [sectionView addSubview:sectionLabel];
    [sectionView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:100/255.0 blue:100/255.0 alpha:1.0]];
    return sectionView;
}



@end
