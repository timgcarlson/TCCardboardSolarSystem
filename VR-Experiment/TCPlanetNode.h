//
//  TCPlanetNode.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/21/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <SceneKit/SceneKit.h>

static NSString * const TCPlanetRadius = @"planetRadius";
static NSString * const TCPlanetRotationDuration = @"rotationDuration";
static NSString * const TCPlanetOrbitRadius = @"orbitRadius";
static NSString * const TCPlanetOrbitTilt = @"orbitTilt";
static NSString * const TCPlanetOrbitDuration = @"orbitDuration";
static NSString * const TCPlanetTextureDictionary = @"textureDictionary";

@interface TCPlanetNode : SCNNode

@property (nonatomic) id orbitNode;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat rotationDuration;
@property (nonatomic) CGFloat orbitRadius;
@property (nonatomic) CGFloat orbitTilt;
@property (nonatomic) CGFloat orbitDuration;
@property (nonatomic, readonly) NSDictionary *textureDictionary;

- (instancetype)initWithPlanetAttributes:(NSDictionary *)planetAttributes aboutOrbitNode:(id)orbitNode;

- (void)startAnimating;

- (void)removeFromParentNode;

@end
