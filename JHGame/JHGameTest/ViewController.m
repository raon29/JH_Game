//
//  ViewController.m
//  JHGameTest
//
//  Created by iPhyon on 2016. 11. 13..
//  Copyright © 2016년 iPhyon. All rights reserved.
//

#import "ViewController.h"
#import "AlbumViewController.h"

NSString *playingTitle;
MPMediaItemArtwork *playingArtwork;
int playIndex;
MPMusicPlayerController *mp;

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation ViewController

- (void)viewDidLoad {
    self.textField.delegate = self;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 키보드 보여질때 호출 되는 함수
-(void)keyboardWillShow:(NSNotification *)notif{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y -= 300;
    rect.size.height += 100;
    self.view.frame = rect;
    [UIView commitAnimations];
}
//키보드 없어질때 호출
- (void)DownView:(NSNotification *)notif{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y += 300;
    rect.size.height -= 100;
    self.view.frame = rect;
    [UIView commitAnimations];
}


-(void)viewWillAppear:(BOOL)animated{
    //keyboard 나타날 때
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    //keyboard 없어질 때
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DownView:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//keyboard return 눌렀을 경우
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//여백 클릭시 keyboard 사라짐
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

//game start!
- (IBAction)btnClickToStartMusic:(id)sender {
    //playmode가 mymusic일때
    if([self.playmode isEqualToString:@"mymusic"]){
        [self myMusicStart:-1];
    }
    //playmode가 basic일때
    else{
        [self basicMusicStart:-1];
    }
}


//내 뮤직에서 가져와서 play
- (void)myMusicStart:(int)index{
    playingTitle = nil;
    playingArtwork = nil;
    mp = [MPMusicPlayerController applicationMusicPlayer];
    if( mp != nil ){
        [mp stop];
    }
    MPMediaQuery *allAlbum = [MPMediaQuery songsQuery];
    
    NSArray *playlists = allAlbum.collections;
    if(index<0){
        int randomNumber = [self getRandomNumberBetween:0 to:(int)[playlists count] - 1];
        index = randomNumber;
    }
    MPMediaPlaylist *play = playlists[index];
    playIndex = index;
    [mp setQueueWithItemCollection:play];
    [mp setCurrentPlaybackTime:20.0];
    [mp play];
    
    //1초뒤 stop
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            playingTitle = [[mp nowPlayingItem] title];
            [mp stop];
        });
    });
}


//basic에서 가져와 music play
- (void)basicMusicStart:(int)index{
    //random
    if(index<0){
        index = [self getRandomNumberBetween:1 to:10];
    }
    playIndex = index;
    NSString *path = [NSString stringWithFormat:@"%@/music%d.mp3", [[NSBundle mainBundle] resourcePath],playIndex];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audioplayer play];
    //title 구하기
    AVAsset *assest;
    assest = [AVURLAsset URLAssetWithURL:soundUrl options:nil];
    for (NSString *format in [assest availableMetadataFormats]) {
        for (AVMetadataItem *item in [assest metadataForFormat:format]) {
            if ([[item commonKey] isEqualToString:@"title"]) {
                playingTitle = (NSString *)[item value];
            }
        }
    }
}


//replay 버튼 클릭시
- (IBAction)btnClickToReplay:(id)sender {
    if([_playmode isEqualToString:@"mymusic"]){
        [self myMusicStart:playIndex];
    }
    else{
        printf("playindex = %d",playIndex);
        [self basicMusicStart:playIndex];
    }
}


//답 check
- (IBAction)btnClickToCheck:(id)sender {
    //정답
    if([self.textField.text isEqualToString:playingTitle]){
        [[[UIAlertView alloc] initWithTitle:@"답확인" message:@"정답!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil] show];
    }
    //틀림
    else{
        [[[UIAlertView alloc] initWithTitle:@"답확인" message:@"틀림 TT" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil] show];
    }
}


//답 확인 클릭시
- (IBAction)GotoAnswer:(UIButton *)sender {
    //music 답 index를 넘겨줌
    AlbumViewController * albumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumView"];
    albumViewController.musicid = playIndex;
    albumViewController.musicmode = self.playmode;
    albumViewController.mp = mp;
    [self.navigationController pushViewController:albumViewController animated:YES];
}


//random number
-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}



@end
