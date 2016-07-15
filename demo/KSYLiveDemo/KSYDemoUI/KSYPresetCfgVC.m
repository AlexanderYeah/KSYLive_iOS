//
//  KSYPresetCfgVC.m
//  KSYStreamerVC
//
//  Created by yiqian on 10/15/15.
//  Copyright (c) 2015 ksyun. All rights reserved.
//

#import "KSYPresetCfgVC.h"
#import "KSYUIView.h"
#import "KSYPresetCfgView.h"
#import "KSYGPUStreamerVC.h"
#import "KSYStreamerKitVC.h"
#import "KSYBlockDemoVC.h"
#import "KSYKitDemoVC.h"


#ifdef KSYSTREAMER_DEMO
@interface KSYSimpleStreamerVC : UIViewController
@end
@interface KSYGPUStreamerKitVC : UIViewController
@end
@interface KSYAlphagoVC : UIViewController
@end
@interface rawVC : UIViewController
@end
@interface imageVC : UIViewController
@end
@interface movieWriterVC : UIViewController
@end
#endif

@interface KSYPresetCfgVC () {
    KSYPresetCfgView * _demoView;
}

// 方便调试 可以在app启动后自动开启预览和推流
@property BOOL  bAutoStart;

@end

@implementation KSYPresetCfgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _demoView = [[KSYPresetCfgView alloc] init];
    __weak KSYPresetCfgVC * weakSelf = self;
    _demoView.onBtnBlock = ^(id sender){
        [weakSelf  btnFunc:sender];
    };
    _demoView.frame = self.view.frame;
    self.view = _demoView;

    //  TODO: !!!! 设置是否自动启动推流
    _bAutoStart = YES;
    if (_bAutoStart) {
//        [self pressBtnAfter:0.5];
    }
    if (_rtmpURL && [_rtmpURL length] ){
        _demoView.hostUrlUI.text = _rtmpURL;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [self layoutUI];
}

- (void) pressBtnAfter : (double) delay {
    dispatch_time_t dt = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(dt, dispatch_get_main_queue(), ^{
        [self btnFunc:_demoView.btn2];
    });
}

-(void)layoutUI{
    if (_demoView){
        [_demoView layoutUI];
    }
}

- (BOOL)shouldAutorotate {
    [self layoutUI];
    return YES;
}

- (IBAction)btnFunc:(id)sender {
    UIViewController *vc;
    if ( sender == _demoView.btn0) { // kit demo
        vc = [[KSYKitDemoVC alloc] initWithCfg:_demoView];
    }
    else if (sender == _demoView.btn1) { // block demo
        vc = [[KSYBlockDemoVC alloc] initWithCfg:_demoView];
    }
    else if ( sender == _demoView.btn2) { // tests
#ifdef KSYSTREAMER_DEMO
        vc = [[KSYSimpleStreamerVC alloc] init];
        vc = [[imageVC alloc] init];
        //vc = [[movieWriterVC alloc] init];
#else
        [self dismissViewControllerAnimated:FALSE
                                 completion:nil];
#endif
    }
    else if ( sender == _demoView.btn3) { // tests
        vc = [[KSYStreamerKitVC alloc] init];
    }
    else if ( sender == _demoView.btn4) { // tests
        vc = [[KSYGPUStreamerVC alloc] init];
    }
    [self presentViewController:vc animated:true completion:nil];
    self.view.window.rootViewController = self;
}

@end
