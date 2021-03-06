//
//  ScoreNode.m
//  Pong
//
//  Created by Michael Koukoullis on 1/08/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "ScoreNode.h"

@interface ScoreNode ()
@property (nonatomic, assign) NSInteger count;
@end

@implementation ScoreNode

- (id)init
{
    return [self initWithName:@"score"];
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.fontSize = 50;
        self.fontName = @"SFUIDisplay-Medium";
        self.count = 0;
        [self updateText];
    }
    
    return self;
}

- (void)increment
{
    self.count += 1;
    [self updateText];
}

- (void)reset
{
    self.count = 0;
    [self updateText];
}

- (void)updateText
{
    self.text = [NSString stringWithFormat:@"%ld", (long)self.count];
}

@end
