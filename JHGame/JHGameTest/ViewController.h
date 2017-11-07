//
//  ViewController.h
//  JHGameTest
//
//  Created by iPhyon on 2016. 11. 13..
//  Copyright © 2016년 iPhyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController{
    AVAudioPlayer * audioplayer;
}
@property (nonatomic) NSString * playmode;
@end
