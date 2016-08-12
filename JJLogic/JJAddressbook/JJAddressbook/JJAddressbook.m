//
//  JJAddressbook.m
//  JJAddressbook
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJAddressbook.h"
#import "JJAddressbookcell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface JJAddressbook()<ABPeoplePickerNavigationControllerDelegate,UISearchBarDelegate,ABNewPersonViewControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,ABPersonViewControllerDelegate>
@property(nonatomic,strong) NSArray *personAddressBook;
@property(strong, nonatomic) UISearchController *searchController;

@end

@implementation JJAddressbook{
    ABAddressBookRef book;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.rowHeight = 66;
    
    [self creatSearchBar];
    
    [self performSelectorInBackground:@selector(addAddressBook) withObject:nil];
    
}

#pragma mark 授权进入
- (void)addAddressBook{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address Book Access Denied" message:@"Please grant us access to your Address Book in Settings -> Privacy -> Contacts" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;
        
    }
    
    if(!book) {
        
        book = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            
            [self getAllPeopleAddressBook:@""];
            
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        
    });
    
}

#pragma mark 共用：刷新表格

- (void)reloadData{
    
    [self.tableView reloadData];
    
}

#pragma mark 获取联系人
- (void)getAllPeopleAddressBook:(NSString *)searchText{
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if([searchText length]==0){
        
        self.personAddressBook = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
        
    } else {
        
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        
        self.personAddressBook = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        
        CFRelease(cfSearchText);
    }
}

- (NSArray *)personAddressBook{
    if (_personAddressBook == nil) {
        _personAddressBook = [NSArray array];
    }
    return _personAddressBook;
}

#pragma mark - tableview数据源：多少行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.personAddressBook count];
    
}

#pragma mark - tableview数据源：cell有什么数据

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JJAddressbookcell *cell = [JJAddressbookcell cell:tableView];
    
    [self setupCellData:indexPath tableViewCell:cell];
    
    return cell;
}

#pragma mark - cell赋值（没有模型）

- (void)setupCellData:(NSIndexPath *)indexPath tableViewCell:(JJAddressbookcell *)cell{
    
    ABRecordRef thisPerson = CFBridgingRetain([self.personAddressBook objectAtIndex:[indexPath row]]);
    
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    
    firstName = firstName != nil?firstName:@"";
    
    NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    
    lastName = lastName != nil?lastName:@"";
    
    cell.nameLabel1.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    
    // 设置电话
    ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
    
    NSArray* phoneNumberArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneNumberProperty));
    
    NSString* phoneNumer = [phoneNumberArray componentsJoinedByString:@" "];
    
    phoneNumer = phoneNumer != nil ? phoneNumer : @"空";
    
    cell.phoneLabel1.text = [NSString stringWithFormat:@"%@",phoneNumer ];
    
    // 设置头像
    if (ABPersonHasImageData(thisPerson)) {
        
        NSData *photoData = CFBridgingRelease(ABPersonCopyImageData(thisPerson));
        
        if(photoData){
            
            [cell.photoImageview1 setImage:[UIImage imageWithData:photoData]];
            
        }
    }else{
        
        [cell.photoImageview1 setImage:[UIImage imageNamed:@"contact"]];
        
    }
    
    CFRelease(thisPerson);
}

#pragma mark 退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}

#pragma mark 功能2：新建联系人
- (IBAction)addNewContactToAddressBook:(id)sender{
    
    [self addNewPersonUsingAdressBookUI];
    
}

#pragma mark 功能2：newPersonViewController 新建联系人

- (void)addNewPersonUsingAdressBookUI{
    
    ABNewPersonViewController *newPersonController=[[ABNewPersonViewController alloc]init];
    
    newPersonController.newPersonViewDelegate = self;
    
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:newPersonController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

#pragma mark 功能2：newPersonViewController代理：didCompleteWithNewPerson

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    [self addAddressBook];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 功能3：删除联系人
#pragma mark - tableview代理：commitEditingStylecell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self deleteContactData:editingStyle tableView:tableView forRowAtIndexPath:indexPath];
    
}

#pragma mark 功能3：滑动删除联系人
- (void)deleteContactData:(UITableViewCellEditingStyle)editingStyle tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(book);
        
        ABRecordRef ref = CFArrayGetValueAtIndex(arrayRef, indexPath.row);
        
        ABAddressBookRemoveRecord(book, ref, NULL);
        
        ABAddressBookSave(book, nil);
        
        CFRelease(arrayRef);
        
        [self addAddressBook];
    }
}

#pragma mark 功能4：编辑联系人
#pragma mark - tableview代理：didSelectRowAtIndexPath

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self checkPerson:indexPath];
    
}

#pragma mark 功能4：编辑联系人

- (void)checkPerson:(NSIndexPath *)indexPath{
    
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(book);
    
    ABRecordRef recordRef = CFArrayGetValueAtIndex(arrayRef, indexPath.row);
    
    ABPersonViewController *personController=[[ABPersonViewController alloc]init];
    
    personController.displayedPerson=recordRef;
    
    personController.personViewDelegate = self;
    
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:personController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

#pragma mark 功能4：personViewController代理：shouldPerformDefaultActionForPerson

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
    
}

#pragma mark 功能5：搜索联系人
- (void)creatSearchBar{
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

#pragma mark 功能5：UISearchResultsUpdating代理：updateSearchResultsForSearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self getAllPeopleAddressBook:self.searchController.searchBar.text];
    [self.tableView reloadData];
}

@end
