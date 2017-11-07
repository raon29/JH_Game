//
//  AlbumViewController.h
//  JHGameTest
//
//  Created by song on 2016. 11. 30..
//  Copyright © 2016년 iPhyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface AlbumViewController : UIViewController
@property (nonatomic) int musicid;
@property (nonatomic) NSString * musicmode;
@property (nonatomic) MPMusicPlayerController *mp;
@end
