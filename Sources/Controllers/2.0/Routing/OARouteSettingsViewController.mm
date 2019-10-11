//
//  OARouteSettingsViewController.m
//  OsmAnd
//
//  Created by Paul on 8/29/18.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import "OARouteSettingsViewController.h"
#import "OARoutePreferencesParameters.h"
#import "OsmAndApp.h"
#import "OAAppSettings.h"
#import "Localization.h"
#import "OAFavoriteItem.h"
#import "OAPointTableViewCell.h"
#import "OADefaultFavorite.h"
#import "OAColors.h"
#import "OARoutingHelper.h"
#import "OASwitchTableViewCell.h"
#import "OASettingsTableViewCell.h"
#import "OANavigationSettingsViewController.h"
#import "OAUtilities.h"
#import "OASettingSwitchCell.h"
#import "OAIconTitleValueCell.h"

@interface OARouteSettingsViewController ()

@end

@implementation OARouteSettingsViewController
{
    NSDictionary *_data;
}

-(void) applyLocalization
{
    [super applyLocalization];
    self.titleView.text = OALocalizedString(@"shared_string_options");
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupView];
}

- (void) generateData
{
    _data = [NSDictionary dictionaryWithDictionary:[self getRoutingParameters:[self.routingHelper getAppMode]]];
}

- (void) setupView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

- (void)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat) heightForRow:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    OALocalRoutingParameter *param = _data[@(indexPath.section)][indexPath.row];
    NSString *type = [param getCellType];
    NSString *text = [param getText];
    NSString *value = [param getValue];
    
    if ([type isEqualToString:@"OASwitchCell"])
    {
        return [OASwitchTableViewCell getHeight:text cellWidth:tableView.bounds.size.width];
    }
    else if ([type isEqualToString:@"OASettingsCell"])
    {
        return [OASettingsTableViewCell getHeight:text value:value cellWidth:tableView.bounds.size.width];
    }
    else if ([type isEqualToString:@"OASettingSwitchCell"])
    {
        return [OASettingSwitchCell getHeight:text
                                         desc:value
                              hasSecondaryImg:YES
                                    cellWidth:tableView.bounds.size.width];
    }
    else if ([type isEqualToString:@"OAIconTitleValueCell"])
    {
        return [OAIconTitleValueCell getHeight:text value:value cellWidth:tableView.bounds.size.width];
    }
    else
    {
        return 44.0;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_data[@(section)]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return nil;
    else if (section == 1)
        return OALocalizedString(@"route_params");
    else if (section == 2)
        return OALocalizedString(@"osm_edits_advanced");
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRow:indexPath tableView:tableView];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRow:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OALocalRoutingParameter *param = _data[@(indexPath.section)][indexPath.row];
    NSString *text = [param getText];
    //NSString *description = [param getDescription];
    NSString *value = [param getValue];
    //UIImage *icon = [param getIcon];
    NSString *type = [param getCellType];
    
    if ([type isEqualToString:@"OASwitchCell"])
    {
        static NSString* const identifierCell = @"OASwitchTableViewCell";
        OASwitchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OASwitchCell" owner:self options:nil];
            cell = (OASwitchTableViewCell *)[nib objectAtIndex:0];
        }
        
        if (cell)
        {
            [cell.textView setText:text];
            [cell.switchView removeTarget:NULL action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.switchView setOn:[param isChecked]];
            [param setControlAction:cell.switchView];
        }
        return cell;
    }
    else if ([type isEqualToString:@"OASettingsCell"])
    {
        static NSString* const identifierCell = @"OASettingsTableViewCell";
        OASettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OASettingsCell" owner:self options:nil];
            cell = (OASettingsTableViewCell *)[nib objectAtIndex:0];
        }
        
        if (cell) {
            [cell.textView setText:text];
            [cell.descriptionView setText:value];
        }
        return cell;
    }
    else if ([type isEqualToString:@"OASettingSwitchCell"])
    {
        static NSString* const identifierCell = @"OASettingSwitchCell";
        OASettingSwitchCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OASettingSwitchCell" owner:self options:nil];
            cell = (OASettingSwitchCell *)[nib objectAtIndex:0];
        }
        
        if (cell)
        {
            [cell.switchView removeTarget:NULL action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.switchView setOn:[param isChecked]];
            cell.textView.text = text;
            cell.descriptionView.text = nil;
            cell.descriptionView.hidden = YES;
            if (param.getSecondaryIcon)
                cell.secondaryImgView.image = param.getSecondaryIcon;
            [cell showPrimaryImage:YES];
            cell.imgView.image = [param.getIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.imgView.tintColor = param.getTintColor;
            [param setControlAction:cell.switchView];
            cell.separatorInset = UIEdgeInsetsMake(0., 62., 0., 0.);
        }
        return cell;
    }
    else if ([type isEqualToString:@"OAIconTitleValueCell"])
    {
        static NSString* const identifierCell = @"OAIconTitleValueCell";
        OAIconTitleValueCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCell owner:self options:nil];
            cell = (OAIconTitleValueCell *)[nib objectAtIndex:0];
        }
        if (cell)
        {
            cell.textView.text = text;
            cell.descriptionView.hidden = YES;
            cell.iconView.tintColor = UIColorFromRGB(color_tint_gray);
            cell.leftImageView.image = [param.getIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.leftImageView.tintColor = param.getTintColor;
            cell.separatorInset = UIEdgeInsetsMake(0., 62., 0., 0.);
        }
        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OALocalRoutingParameter *param = _data[@(indexPath.section)][indexPath.row];
    [param rowSelectAction:tableView indexPath:indexPath];
}

@end
