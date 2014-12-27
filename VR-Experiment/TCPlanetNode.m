//
//  TCPlanetNode.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/21/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "TCPlanetNode.h"

static NSString * const TCMiscTextureString = @"miscPlanet_";
static const NSInteger TCNumberOfTextures = 13;   // Includes 0 index

@interface TCPlanetNode ()

@property (nonatomic) SCNNode *rotationNode;
@property (nonatomic) SCNNode *groupNode;
@property (nonatomic) SCNNode *planetNode;
@property (nonatomic, readwrite) NSDictionary *textureDictionary;

@end


@implementation TCPlanetNode

- (instancetype)init {
    return [self initWithPlanetAttributes:nil aboutOrbitNode:nil];
}

- (instancetype)initWithPlanetAttributes:(NSDictionary *)planetAttributes aboutOrbitNode:(id)orbitNode {
    if (self = [super init]) {
        if (!orbitNode) {
            // TODO: Handle a nil oribitNode correctly.
            self.orbitNode = [SCNNode node];
        } else {
            self.orbitNode = orbitNode;
        }
        if (!planetAttributes) {
            // Create a random planet
            [self setRandomPlanetValues];
        } else {
            self.radius = [planetAttributes[TCPlanetRadius] floatValue];
            self.rotationDuration = [planetAttributes[TCPlanetRotationDuration] floatValue];
            self.orbitRadius = [planetAttributes[TCPlanetOrbitRadius] floatValue];
            self.orbitTilt = [planetAttributes[TCPlanetOrbitTilt] floatValue];
            self.orbitDuration = [planetAttributes[TCPlanetOrbitDuration] floatValue];
            self.textureDictionary = planetAttributes[TCPlanetTextureDictionary];
        }
        
        [self createPlanetNode];
    }
    return self;
}

- (void)setRandomPlanetValues {
    self.radius = (((float)arc4random()/0x100000000) * 3);
    self.orbitRadius = 10 + arc4random() % 40;
    self.orbitTilt = -(M_PI/4) + (((float)arc4random()/0x100000000) * (M_PI/2));
    self.orbitDuration = 5 + arc4random() % 75;
    self.rotationDuration = 5 + arc4random() % 15;
    
    NSInteger randomTextureInteger = arc4random() % TCNumberOfTextures;
    self.textureDictionary = @{@"diffuse" : [NSString stringWithFormat: @"%@%ld", TCMiscTextureString, randomTextureInteger]};
}

- (void)createPlanetNode {
    
    _rotationNode = [SCNNode node];
    
    _groupNode = [SCNNode node];
    _groupNode.position = SCNVector3Make(-self.orbitRadius + (((float)arc4random()/0x100000000) * (2 * self.orbitRadius)), 0, -(self.orbitRadius));
    [_rotationNode addChildNode:_groupNode];
    
    SCNSphere *planet = [SCNSphere sphereWithRadius:self.radius];
    _planetNode = [SCNNode nodeWithGeometry:planet];
    _planetNode.position = SCNVector3Make(0, 0, 0);
    [_groupNode addChildNode:_planetNode];
    
    // Add material to planet
    if (self.textureDictionary) {
        _planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:self.textureDictionary[@"diffuse"]];
        _planetNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
        _planetNode.geometry.firstMaterial.shininess = 0.1;
        _planetNode.geometry.firstMaterial.specular.intensity = 0.5;
    } else {
        // TODO: No textures provided, so provide some default or random texture...
        _planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earth-diffuse-mini"];
        _planetNode.geometry.firstMaterial.emission.contents = [UIImage imageNamed:@"earth-emissive-mini"];
        _planetNode.geometry.firstMaterial.specular.contents = [UIImage imageNamed:@"earth-specular-mini"];
        _planetNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
        _planetNode.geometry.firstMaterial.shininess = 0.1;
        _planetNode.geometry.firstMaterial.specular.intensity = 0.5;
    }
}

- (void)startAnimating {
    [self.orbitNode addChildNode:_rotationNode];
    
    // Set up the animations...
    CABasicAnimation *planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = self.orbitDuration;
    planetRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(self.orbitTilt, 1, 0, M_PI * 2)];
    planetRotationAnimation.repeatCount = FLT_MAX;
    [_rotationNode addAnimation:planetRotationAnimation forKey:@"planet rotation around orbit point"];
    
    // Rotate the Planet
    planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = self.rotationDuration;
    planetRotationAnimation.fromValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, 0)];
    planetRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    planetRotationAnimation.repeatCount = FLT_MAX;
    [_planetNode addAnimation:planetRotationAnimation forKey:@"planet rotation"];
}

- (void)removeFromParentNode {
    [super removeFromParentNode];
    [self.rotationNode removeFromParentNode];
}

@end
