//
//  FBShareSandbox.m
//  AirSandboxDemo
//
//  Created by 张学阳 on 2018/4/27.
//  Copyright © 2018年 music4kid. All rights reserved.
//

#import "FBShareSandbox.h"
#import <UIKit/UIKit.h>

#define kWindowBorderColor [UIColor colorWithWhite:0.2 alpha:1.0]
#define kWindowPading  20

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


typedef NS_ENUM(NSUInteger , FBSandboxType) {
    FBSandboxTypeBack,
    FBSandboxTypeDirectory,
    FBSandboxTypeFile
};

#pragma mark -------- FBSandboxItem
@interface FBSandboxItem : NSObject
@property(nonatomic,assign)FBSandboxType sandboxType;
@property(nonatomic , copy)NSString *fileName;
@property(nonatomic , copy)NSString *filePath;
@end

@implementation FBSandboxItem
@end

#pragma mark- ASTableViewCell
@interface FBSharedSandboxCell : UITableViewCell
@property (nonatomic, strong) UILabel *lbName;
@end

@implementation FBSharedSandboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        int cellWidth = [UIScreen mainScreen].bounds.size.width - 2*kWindowPading;
        
        _lbName = [UILabel new];
        _lbName.backgroundColor = [UIColor clearColor];
        _lbName.font = [UIFont systemFontOfSize:13];
        _lbName.textAlignment = NSTextAlignmentLeft;
        _lbName.frame = CGRectMake(10, 30, cellWidth - 20, 15);
        _lbName.textColor = [UIColor blackColor];
        [self addSubview:_lbName];
        
        UIView* line = [UIView new];
        line.backgroundColor = kWindowBorderColor;
        line.frame = CGRectMake(10, 47, cellWidth - 20, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)renderWithItem:(FBSandboxItem*)item
{
    _lbName.text = item.fileName;
}
@end

#pragma mark -------- FBSandoxVCCtrl
@interface FBSandboxVCCtrl :UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabview;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic , copy)NSString *rootPath;
@property(nonatomic,strong)UIButton *closeBtn;
@end


static NSString *const SANDBOX_CELL_IDENT = @"FBSharedSandboxCell";

@implementation FBSandboxVCCtrl

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, kScreenWidth-kWindowPading*2, kScreenHeight-kWindowPading*2-64);
    _rootPath = NSHomeDirectory();
    
    [self prepareUI];
    
    [self getFileFromPath:nil];
    
}

#pragma mark -------- 取出沙盒文件
-(void)getFileFromPath:(NSString *)filePath
{
    NSMutableArray *paths = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *targertPath = filePath;
    if (targertPath.length == 0 || [targertPath isEqualToString:_rootPath]) {
        targertPath = _rootPath;
    }
    else
    {
        FBSandboxItem *item = [[FBSandboxItem alloc] init];
        item.sandboxType = FBSandboxTypeBack;
        item.filePath = filePath;
        item.fileName = @"🔙 BACK";
        [paths addObject:item];
    }
    NSError *error = nil;
    NSArray *filePaths = [fileManager contentsOfDirectoryAtPath:targertPath error:&error];
    
    for (NSString *fileName in filePaths) {
        
        if ([[fileName lastPathComponent] hasPrefix:@"."]) {
            //过滤 .com.apple.mobile_container_manager.metadata.plist
            continue;
        }
        
        BOOL isDir = NO;
        NSString* fullPath = [targertPath stringByAppendingPathComponent:fileName];
        [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        
        FBSandboxItem* fileItem = [FBSandboxItem new];
        fileItem.filePath = fullPath;
        
        if (isDir) {//是文件夹
            fileItem.fileName = [NSString stringWithFormat:@"%@ %@", @"📁", fileName];
            fileItem.sandboxType = FBSandboxTypeDirectory;
        }else{
            fileItem.fileName = [NSString stringWithFormat:@"%@ %@", @"📄", fileName];
            fileItem.sandboxType = FBSandboxTypeFile;
        }
        
        [paths addObject:fileItem];
    }
    _dataSource = paths;
    [_tabview reloadData];
}

#pragma mark -------- 搭建UI
-(void)prepareUI
{
    int viewWidth = kScreenWidth - 2*kWindowPading;
    int closeWidth = 90;
    int closeHeight = 28;
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setTitle:@"❌ " forState:UIControlStateNormal];
    _closeBtn.frame = CGRectMake(viewWidth-closeWidth-4, 4, closeWidth, closeHeight);
    [_closeBtn addTarget:self action:@selector(hiddenSharedSandboxPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    CGRect react = CGRectMake(0, closeHeight+4, kScreenWidth-kWindowPading*2, self.view.bounds.size.height-closeHeight-4);
    
    _tabview = [[UITableView alloc] initWithFrame:react style:UITableViewStylePlain];
    _tabview.delegate = self;
    _tabview.dataSource = self;
    _tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tabview registerClass:[FBSharedSandboxCell class] forCellReuseIdentifier:SANDBOX_CELL_IDENT];
    [self.view addSubview:_tabview];
}

#pragma mark -------- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > _dataSource.count-1) {
        return [UITableViewCell new];
    }
    FBSandboxItem *item = _dataSource[indexPath.row];
    FBSharedSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:SANDBOX_CELL_IDENT forIndexPath:indexPath];
    [cell renderWithItem:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > _dataSource.count-1) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FBSandboxItem* item = [_dataSource objectAtIndex:indexPath.row];
    if (item.sandboxType == FBSandboxTypeBack) {
        [self getFileFromPath:[item.filePath stringByDeletingLastPathComponent]];
    }
    else if(item.sandboxType == FBSandboxTypeFile) {
        [self sharePath:item.filePath];
    }
    else if(item.sandboxType == FBSandboxTypeDirectory) {
        [self getFileFromPath:item.filePath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return  0.1f;}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{return nil;}
#pragma mark -------- 隐藏试图
- (void)hiddenSharedSandboxPage{
    self.view.window.hidden = true;
}
#pragma mark -------- 分享
- (void)sharePath:(NSString*)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSArray *objectsToShare = @[url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height, 10, 10);
    }
    [self presentViewController:controller animated:YES completion:nil];
}
@end




#pragma mark -------- FBShareSandbox
@interface FBShareSandbox ()<NSCopying>
@property(nonatomic,strong)UIWindow *sandboxWindow;
@property(nonatomic,strong)FBSandboxVCCtrl *sandboxCtrl;
@end

@implementation FBShareSandbox

static FBShareSandbox * _sharedSandbox = nil;

+(instancetype)sharedSandbox{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSandbox = [[super allocWithZone:NULL] init];
    });

    return _sharedSandbox;
}

+(id)copyWithZone:(NSZone *)zone{
    return [FBShareSandbox sharedSandbox];
}

-(id) copyWithZone:(struct _NSZone *)zone{
    return [FBShareSandbox sharedSandbox] ;
}


-(void)swipSandboxPage{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeTargert:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:leftSwipe];
}

-(void)leftSwipeTargert:(UIGestureRecognizer *)sender{
    [self showSandboxWindow];
}

-(void)showSandboxWindow
{
    if (!_sandboxWindow) {
        _sandboxWindow = [[UIWindow alloc] init];
        _sandboxWindow.backgroundColor = [UIColor yellowColor];
        CGRect keyFrame = [UIScreen mainScreen].bounds;
        keyFrame.origin.y += 64;
        keyFrame.size.height -= 64;
        _sandboxWindow.frame = CGRectInset(keyFrame, kWindowPading, kWindowPading);
        _sandboxWindow.backgroundColor = [UIColor whiteColor];
        _sandboxWindow.layer.borderColor = kWindowBorderColor.CGColor;
        _sandboxWindow.layer.borderWidth = 2.0;
        _sandboxWindow.windowLevel = UIWindowLevelStatusBar;
        
        _sandboxCtrl = [FBSandboxVCCtrl new];
        _sandboxWindow.rootViewController = _sandboxCtrl;
    }
    
    _sandboxWindow.hidden = NO;
    
}

@end
