//
//  ViewController.h
//  AudioVideoTest
//
//  Created by Lucian Boboc on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController <AVAudioRecorderDelegate, UINavigationControllerDelegate,UIVideoEditorControllerDelegate>

@property (retain, nonatomic) AVAudioRecorder *recorder;
@property (retain, nonatomic) AVAudioPlayer *player;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) NSString *myEditedPath;
@property (retain, nonatomic) IBOutlet UIButton *playEditedButton;

- (NSString *) getPath;
- (NSString *) myEditedPath;

- (IBAction) playMovie:(id)sender;
- (IBAction) editMovie:(id)sender;
- (IBAction) playEditedVideo:(id)sender;
- (IBAction) playShortSound:(id)sender;
- (IBAction) vibrate:(id)sender;
- (IBAction) record:(id)sender;
- (IBAction) playRecording:(id)sender;

@end
