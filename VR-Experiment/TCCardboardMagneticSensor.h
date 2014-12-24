//
//  TCCardboardMagneticSensor.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/24/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <SceneKit/SceneKit.h>

@protocol TCCardboardMagneticSensorDelegate <NSObject>

- (void)onCardboardTrigger;

@end

@interface TCCardboardMagneticSensor : NSObject <CLLocationManagerDelegate>

@property (weak) id <TCCardboardMagneticSensorDelegate> delegate;

@end
