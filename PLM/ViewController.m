//
//  ViewController.m
//  AudioVideoTest
//
//  Created by Lucian Boboc on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation ViewController
@synthesize recorder = _recorder;
@synthesize button = _button;
@synthesize player = _player;
@synthesize myEditedPath = _myEditedPath;
@synthesize playEditedButton = _playEditedButton;

- (void) dealloc
{
    [_recorder release];
    [_button release];
    [_player release];
    [_myEditedPath release];
    [_playEditedButton release];
    [super dealloc];
}

- (IBAction) playMovie:(id)sender
{
    NSURL *url  = [[NSBundle mainBundle] URLForResource: @"Taskulous" withExtension: @"mp4"];
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
    [self presentModalViewController: controller animated: YES];
    [controller release];
}

- (IBAction) editMovie:(id)sender
{
    UIVideoEditorController *controller = [[UIVideoEditorController alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Taskulous" ofType: @"mp4"];
    controller.delegate = self;

    if([UIVideoEditorController canEditVideoAtPath:path])
    {
        controller.videoPath = path;
        [self presentModalViewController: controller animated: YES];
        [controller release];
    }
    else
    {
        NSLog(@"UIVideoEditorController cannot edit video!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"Cannot edit video" delegate: nil cancelButtonTitle: @"OK!" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction) playEditedVideo:(id)sender
{
    NSString *path = [self myEditedPath];
    NSURL *url = [NSURL fileURLWithPath: path];
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
    [self presentModalViewController: controller animated: YES];
    [controller release];
}

#pragma mark - UIVideoEditorControllerDelegate Methods

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSData *data = [NSData dataWithContentsOfFile: editedVideoPath];
    if([data writeToFile: [self myEditedPath] atomically: YES] == YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"Edited video saved successfully!!" delegate: nil cancelButtonTitle: @"OK!" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self dismissModalViewControllerAnimated: YES];    
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self dismissModalViewControllerAnimated: YES];
    
}

- (IBAction) playShortSound:(id)sender
{
    SystemSoundID soundID;
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"sound2" withExtension: @"caf"];
    AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (IBAction) vibrate:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction) record:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(self.recorder.isRecording)
    {
        [self.button setTitle:@"Record" forState: UIControlStateNormal];       
        [self.recorder stop];
    }
    else
    {
        [self.button setTitle:@"Stop" forState: UIControlStateNormal];
        [self.recorder record];
    }
}

#pragma mark - recorder delegate methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSError *err;
    NSURL *url = [NSURL fileURLWithPath: [self getPath]];
    NSData *data = [[NSData alloc] initWithContentsOfURL: url];
    _player = [[AVAudioPlayer alloc] initWithData:data error: &err];
    [self.player prepareToPlay];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (NSString *) getPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex: 0] stringByAppendingPathComponent: @"file.caf"];
    return path;
}

- (NSString *) myEditedPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex: 0] stringByAppendingPathComponent: @"editedVideo.mp4"];
    return path;
}

- (IBAction) playRecording:(id)sender
{
    if(self.player)
        [self.player play];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *err;
    NSURL *url = [NSURL fileURLWithPath: [self getPath]];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error: &err];
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: [self myEditedPath]])
        self.playEditedButton.enabled = YES;
    else
        self.playEditedButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
