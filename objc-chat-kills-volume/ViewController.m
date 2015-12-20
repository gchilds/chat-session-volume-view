//
//  ViewController.m
//  objc-chat-kills-volume
//
//  Created by Gordon Childs on 21/12/2015.
//  Copyright © 2015 Gordon Childs. All rights reserved.
//

// http://stackoverflow.com/questions/34346209/ios-mpvolumeview-breaks-based-on-audiosession-mode

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@property (nonatomic) MPVolumeView *volumeView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.volumeView = [[MPVolumeView alloc] init];
	[self.view addSubview:self.volumeView];
	
	// Make sure the session on this thread matches.
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth error:nil];
	
	// Here is the main connundrum: I want to set AVAudioSessionModeDefault so that the MPVolumeView will work,
	// but when I do that the mic picks up the audio from the speaker and plays it back creating an unwanted feeback loop.
	// If I set the mode to AVAudioSessionModeVoiceChat the voice processing (primarily the AEC) fixes the feeback loop,
	// but then the MPVolumeView no longers works.  (It no longer adjusts the system volume.
	//Question: How can I have BOTH the voice processing AND the MPVolumeView adjust the system volume?
	if(true)
		[audioSession setMode:AVAudioSessionModeDefault error:nil];
	else
		[audioSession setMode:AVAudioSessionModeVoiceChat error:nil];
	
	[audioSession setPreferredIOBufferDuration:0.005 error:nil];
	[audioSession setActive:YES error:nil];
}

- (void)viewWillLayoutSubviews {
	self.volumeView.frame = self.view.frame;
}

@end
