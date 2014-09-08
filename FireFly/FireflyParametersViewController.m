//
//  FireflyParametersViewController.m
//  FireFly
//
//  Created by Håkon on 04/09/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "FireflyParametersViewController.h"
#import "Puredata.h"

@interface FireflyParametersViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pccLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *pccSlider;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@end

@implementation FireflyParametersViewController

- (IBAction)thresholdAction:(UISlider *)sender {
    self.thresholdLabel.text = [NSString stringWithFormat:@"Threshold: %.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"thresholdFromUI"];
}

- (IBAction)pccAction:(UISlider *)sender {
    self.pccLabel.text = [NSString stringWithFormat:@"PCC: %.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"pccFromUI"];
}

//- (IBAction)pccStepperAction:(UIStepper *)sender {
//    double pccVal = (double)sender.value/10;
//    self.pccLabel.text = [NSString stringWithFormat:@"PCC: %.2f",pccVal];
//    Puredata *pd = [Puredata sharedPuredata];
//    [pd setValueInPd:pccVal forKey:@"pccFromUI"];
//}
//- (IBAction)thresholdStepperAction:(UIStepper *)sender {

//}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// add steppers as outlets and set the values instead of having two separate floats with the values of pcc and threshold
-(void)setValuesFromPd:(NSNotification *)notification
{
    NSEnumerator *received = [(NSMutableDictionary *)[notification object] keyEnumerator];
    NSString *key;
    while (key = [received nextObject]) {
        if ([key isEqualToString:@"pcc"]) {
            float pccVal = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.pccSlider.value = pccVal;
            self.pccLabel.text = [NSString stringWithFormat:@"PCC: %.2f",pccVal];
        }
        if ([key isEqualToString:@"threshold"]) {
            float threshold = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.thresholdSlider.value = threshold;
            self.thresholdLabel.text = [NSString stringWithFormat:@"Threshold: %.2f",threshold];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.listener = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Puredata *pd = (Puredata *)[Puredata sharedPuredata];
    [pd sendBangToReceiver:@"getParameters"];
    // put this in viewWillAppear instead

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parameterCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
