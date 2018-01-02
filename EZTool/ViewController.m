//
//  ViewController.m
//  EZTool
//
//  Created by xiacheng on 2017/9/24.
//  Copyright © 2017年 xiacheng. All rights reserved.
//

#import "ViewController.h"

#define kPyFileName @"symbolized"
#define kPyFileFullName @"symbolized.py"
#define kExcFileFullName @"symbolicatecrash"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *showLabel;

@property (weak) IBOutlet NSButton *startSymbolizedButton;

@property (nonatomic, copy)   NSString *dirPath;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}



- (IBAction)onChooseFileButtonClicked:(id)sender {
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    
    NSURL *homeUrl = [[NSFileManager defaultManager]homeDirectoryForCurrentUser];

    /*
     homeUrlPath:/Users/xiacheng urlPath:/Users/xiacheng/Desktop
     */
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop",homeUrl.path]];
    panel.title = @"选择文件";
    panel.directoryURL = url;
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            self.showLabel.stringValue = theDoc.path;
            self.dirPath = theDoc.path;
        }
    }];
}


- (IBAction)onStartSybolizedButtonClicked:(id)sender {
    //TD 没有选择文件夹时提醒
    
    
    NSString *pyPath = [[NSBundle mainBundle] pathForResource:kPyFileName ofType:@"py"];
    NSString *excPath = [[NSBundle mainBundle] pathForResource:kExcFileFullName ofType:nil];
    NSLog(@"path:%@ excPath:%@",pyPath,excPath);
    
    
    NSURL *pyUrl = [NSURL fileURLWithPath:pyPath];
    NSURL *excUrl = [NSURL fileURLWithPath:excPath];
    NSURL *pyToPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",self.dirPath,kPyFileFullName]];
    NSURL *excToPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",self.dirPath,kExcFileFullName]];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSError *pyCopyError = nil;
    NSError *excCopyError = nil;
    if (![defaultManager fileExistsAtPath:pyToPath.path]) {
        [defaultManager copyItemAtURL:pyUrl toURL:pyToPath error:&pyCopyError];
    }
    if (![defaultManager fileExistsAtPath:excToPath.path]) {
        [defaultManager copyItemAtURL:excUrl toURL:excToPath error:&excCopyError];
    }
    
    if (excCopyError || pyCopyError) {
        //TD
        //提醒
        NSLog(@"复制文件出错");
        return;
    }
    NSString *cmd = [NSString stringWithFormat:@"cd %@;python %@",self.dirPath,kPyFileFullName];
    
    int result = system(cmd.UTF8String);
    //TD 成功失败提醒
    
    [defaultManager removeItemAtURL:pyToPath error:&pyCopyError];
    [defaultManager removeItemAtURL:excToPath error:&excCopyError];
    
    if (excCopyError || pyCopyError) {
        [NSThread sleepForTimeInterval:1.0];
        //重试一次
        [defaultManager removeItemAtURL:pyToPath error:&pyCopyError];
        [defaultManager removeItemAtURL:excToPath error:&excCopyError];
        NSLog(@"删除文件出错");
    }
    
    if (result == 0) {
        self.showLabel.stringValue = @"已完成！！！";
    }else{
        self.showLabel.stringValue = @"出错了！balabalabala";
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
