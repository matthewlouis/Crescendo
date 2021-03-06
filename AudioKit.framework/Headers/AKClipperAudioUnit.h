//
//  AKClipperAudioUnit.h
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

#ifndef AKClipperAudioUnit_h
#define AKClipperAudioUnit_h

#import <AudioToolbox/AudioToolbox.h>

@interface AKClipperAudioUnit : AUAudioUnit
- (void)start;
- (void)stop;
- (BOOL)isPlaying;
@end

#endif /* AKClipperAudioUnit_h */
