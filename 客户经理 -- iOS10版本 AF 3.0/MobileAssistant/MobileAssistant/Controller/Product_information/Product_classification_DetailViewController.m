//
//  Product_classification_DetailViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/6/20.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Product_classification_DetailViewController.h"
#import "WMPlayer.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49

@interface Product_classification_DetailViewController ()<UIScrollViewDelegate,WMPlayerDelegate>
{
    WMPlayer *wmPlayer;
    BOOL isSmallScreen;
    UIButton *playBtn;
}

@end

@implementation Product_classification_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSURL *url = [NSURL URLWithString:self.entity.icon];
    [self.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = self.entity.name;
    self.messageLabel.text = self.entity.title;
    
    self.messageLabel.textColor = RGBA(147, 147, 147, 1);
    
    ////////////////////////////定义标题页面//////////////////////////
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10, SCREEN_WIDTH / 4 * 3, 44)];
    _titleScrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 4, 44);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.delegate = self;
    
    //    横向分割线
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10 + 38, SCREEN_WIDTH / 4 - 14, 2)];
    self.lineLabel.backgroundColor = RGBA(225, 123, 171, 1);
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;//防止留白
    ////////////////////////////定义主页面//////////////////////////
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.lineLabel.frame.origin.y + 10, SCREEN_WIDTH, SCREEN_HEIGHT - self.lineLabel.frame.origin.y - 2)];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - self.lineLabel.frame.origin.y - 2);
    _mainScrollView.pagingEnabled = YES;//整个页面翻页
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;

    
    [self addMyButtons];
    [self addMyViews];
    
    [self.view addSubview:self.lineLabel];
    [self.view addSubview:_mainScrollView];
    [self.view addSubview:_titleScrollView];
}
//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addMyButtons
{
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 4, 38)];
    [_button1 setTitle:@"产品介绍" forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBA(96, 171, 186, 1) forState:UIControlStateNormal];
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 + 1, 0, SCREEN_WIDTH / 4, 38)];
    [_button2 setTitle:@"业务特点" forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
    
    _button3 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 4 )*2 + 2, 0, SCREEN_WIDTH / 4, 38)];
    [_button3 setTitle:@"演示视频" forState:UIControlStateNormal];
    [_button3 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
    
    
    _button1.titleLabel.font = [UIFont systemFontOfSize:18];
    _button2.titleLabel.font = [UIFont systemFontOfSize:18];
    _button3.titleLabel.font = [UIFont systemFontOfSize:18];
    
    _button1.tag = 1;
    _button2.tag = 2;
    _button3.tag = 3;
    
    [_button1 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleScrollView addSubview:_button1];
    [_titleScrollView addSubview:_button2];
    [_titleScrollView addSubview:_button3];
}

- (void)addMyViews
{

    
    _webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.lineLabel.frame.origin.y - 4)];
    _webView1.backgroundColor = [UIColor whiteColor];
    
    _webView2 = [[UIWebView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.lineLabel.frame.origin.y - 4)];
    _webView2.backgroundColor = [UIColor whiteColor];
    
    _View3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.view.frame.size.height - self.lineLabel.frame.origin.y - 4)];
    
    wmPlayer = [[WMPlayer alloc]initWithFrame:CGRectMake(0, _View3.frame.size.height / 5, _View3.frame.size.width, _View3.frame.size.height/2)];
    wmPlayer.delegate = self;
    [wmPlayer setURLString:self.entity.video_url];
    
    playBtn = [[UIButton alloc]initWithFrame:CGRectMake((wmPlayer.frame.size.width - 50)/2, (_View3.frame.size.height - 50)/2, 50, 50)];
    [playBtn setImage:[UIImage imageNamed:@"video_play_btn_bg.png"] forState:UIControlStateNormal];
    
    [playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    [_View3 addSubview:wmPlayer];
    [_View3 addSubview:playBtn];
    
    [_mainScrollView addSubview:_webView1];
    [_mainScrollView addSubview:_webView2];
    [_mainScrollView addSubview:_View3];
    
    NSString *url1 = [NSString stringWithFormat:@"%@?method=%@&page=%@&id=%@&field=%@",BASEURL,@"common_page",@"product",self.entity.product_id,@"content1"];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
    
    NSString *url2 = [NSString stringWithFormat:@"%@?method=%@&page=%@&id=%@&field=%@",BASEURL,@"common_page",@"product",self.entity.product_id,@"content2"];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
    
    [_webView1 loadRequest:request1];
    [_webView2 loadRequest:request2];
    
}

#pragma mark ------- scrollView的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _x = _mainScrollView.contentOffset.x;
    
    if (_x > 0 && _x < SCREEN_WIDTH /2) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*SCREEN_WIDTH + 15, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10 + 38 , SCREEN_WIDTH/4 - 12, 2);
        }];

    }else if(_x > SCREEN_WIDTH /2 && _x < SCREEN_WIDTH)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*SCREEN_WIDTH - 8, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10 + 38 , SCREEN_WIDTH/4 - 14, 2);
        }];
        
        
    }
    else if(_x >= SCREEN_WIDTH && _x <= (3/2) * SCREEN_WIDTH)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*SCREEN_WIDTH - 8, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10 + 38, SCREEN_WIDTH/4- 14, 2);
        }];
        
        
    }else if(_x > (3/2) * SCREEN_WIDTH && _x < 2 * SCREEN_WIDTH)
    {
        

        [UIView animateWithDuration:0.5 animations:^{
            
            self.lineLabel.frame = CGRectMake( _x/self.mainScrollView.contentSize.width*SCREEN_WIDTH - 35, self.iconImage.frame.size.height + self.iconImage.frame.origin.y + 10 + 38, SCREEN_WIDTH/4- 14, 2);
        }];
        
        
    }
    
    
    if (_x == 0) {
        
        [_button1 setTitleColor:RGBA(96, 171, 186, 1) forState:UIControlStateNormal];
        [_button2 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
        [_button3 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];

    }else if(_x == SCREEN_WIDTH){
        
        [_button1 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
        [_button2 setTitleColor:RGBA(96, 171, 186, 1) forState:UIControlStateNormal];
        [_button3 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
        
    }else if(_x == 2 * SCREEN_WIDTH){
        
        [_button1 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
        [_button2 setTitleColor:RGBA(147, 147, 147, 1) forState:UIControlStateNormal];
        [_button3 setTitleColor:RGBA(96, 171, 186, 1) forState:UIControlStateNormal];
    }
    
}

- (void)turn:(UIButton*)sender{
    
    NSInteger i = sender.tag - 1;
    
    [_mainScrollView setContentOffset:CGPointMake(i * SCREEN_WIDTH, 0) animated:YES];
    
}

-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
- (instancetype)init{
    self = [super init];
    if (self) {
        isSmallScreen = NO;
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    if (wmPlayer) {
        if (wmPlayer.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(void)startPlayVideo:(UIButton *)sender{
//    
//        isSmallScreen = NO;
    if (isSmallScreen) {
        [self releaseWMPlayer];
        isSmallScreen = NO;
        
    }
    [wmPlayer play];
    
    [playBtn.superview sendSubviewToBack:playBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
//    旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ( _x != 2 * SCREEN_WIDTH){
        return;
    }

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
            
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                if (isSmallScreen) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }else{
                    [self toCell];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            wmPlayer.isFullscreen = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            wmPlayer.isFullscreen = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}

///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
    
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseWMPlayer];
}
/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    [wmPlayer pause];
    
    
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}

-(void)toCell{
    
    [wmPlayer removeFromSuperview];
    
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(0, _View3.frame.size.height / 5, _View3.frame.size.width, _View3.frame.size.height/2);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.View3 addSubview:wmPlayer];
        
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-kScreenHeight/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
    }];
    
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)));
        make.height.equalTo(@30);
    }];
    
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

-(void)toSmallScreen{
    //放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(kScreenWidth/2,kScreenHeight-kTabBarHeight-(kScreenWidth/2)*0.75, kScreenWidth/2, (kScreenWidth/2)*0.75);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
