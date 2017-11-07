//
//  AlbumViewController.m
//  JHGameTest
//
//  Created by song on 2016. 11. 30..
//  Copyright © 2016년 iPhyon. All rights reserved.
//

#import "AlbumViewController.h"
#import "ViewController.h"
#import "startViewController.h"

@interface AlbumViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *uiAlbumView;
@property (weak, nonatomic) IBOutlet UILabel *labelArtist;

@end

@implementation AlbumViewController

- (void)myMusicShow{
    
    //full music play
    [self.mp play];
    
    MPMediaItemArtwork *playingArtwork = [[self.mp nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork];
    NSString * musicTitle =[[self.mp nowPlayingItem] title];
    NSString * musicArtist = [[self.mp nowPlayingItem] artist];
    
    //이미지
    UIImage * artworkImage;
    if(playingArtwork){
        artworkImage = [playingArtwork imageWithSize:self.uiAlbumView.bounds.size];
    }
    else{
        artworkImage = [UIImage imageNamed:@"noimage.png"];
    }
    [self.uiAlbumView setImage:artworkImage];

    //title
    [self.labelTitle setText:musicTitle];
    
    //artist
    if(musicArtist){
        [self.labelArtist setText:musicArtist];
    }
    else{
        [self.labelArtist setText:@"정보없음"];
    }
}
- (void)basicMusicShow{
    AVAsset *assest;
    NSString *path = [NSString stringWithFormat:@"%@/music%d.mp3", [[NSBundle mainBundle] resourcePath],self.musicid];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    assest = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    
    NSString * musicTitle;
    NSString * musicArtist;
    UIImage * artworkImage;
    for (NSString *format in [assest availableMetadataFormats]) {
        for (AVMetadataItem *item in [assest metadataForFormat:format]) {
            
            if ([[item commonKey] isEqualToString:@"title"]) {
                musicTitle = (NSString *)[item value];
            }
            
            if ([[item commonKey] isEqualToString:@"artist"]) {
                musicArtist = (NSString *)[item value];
            }
            
            if ([[item commonKey] isEqualToString:@"artwork"]) {
                UIImage *img = nil;
                img = [UIImage imageWithData:[item.value copyWithZone:nil]];
                artworkImage = img;
            }
        }
    }
    
    //image
    [self.uiAlbumView setImage:artworkImage];
    //title
    [self.labelTitle setText:musicTitle];
    //artist
    [self.labelArtist setText:musicArtist];
}

//home으로
- (IBAction)gotohome:(UIButton *)sender {
    startViewController * startViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"startView"];
    [self.navigationController pushViewController:startViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([_musicmode isEqualToString:@"mymusic"]){
        [self myMusicShow];
    }
    else{
        [self basicMusicShow];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.mp stop];
    [self.navigationController popToRootViewControllerAnimated:NO];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
