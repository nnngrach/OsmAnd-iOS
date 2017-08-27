//
//  OATargetPointsHelper.h
//  OsmAnd
//
//  Created by Alexey Kulish on 15/07/2017.
//  Copyright © 2017 OsmAnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class OAPointDescription, OARTargetPoint;

@protocol OAStateChangedListener <NSObject>
    
@required
- (void) stateChanged:(id)change;
    
@end

@interface OATargetPointsHelper : NSObject

+ (OATargetPointsHelper *) sharedInstance;

- (OARTargetPoint *) getPointToNavigate;
- (OARTargetPoint *) getPointToStart;
- (OAPointDescription *) getStartPointDescription;
- (NSArray<OARTargetPoint *> *) getIntermediatePoints;
- (NSArray<OARTargetPoint *> *) getIntermediatePointsNavigation;
- (NSArray<CLLocation *> *) getIntermediatePointsLatLon;
- (NSArray<CLLocation *> *) getIntermediatePointsLatLonNavigation;
- (NSArray<OARTargetPoint *> *) getAllPoints;
- (NSArray<OARTargetPoint *> *) getIntermediatePointsWithTarget;
- (OARTargetPoint *) getFirstIntermediatePoint;

- (void) navigateToPoint:(CLLocation *)point updateRoute:(BOOL)updateRoute intermediate:(int)intermediate;
- (void) navigateToPoint:(CLLocation *)point updateRoute:(BOOL)updateRoute intermediate:(int)intermediate historyName:(OAPointDescription *)historyName;
- (void) setStartPoint:(CLLocation *)startPoint updateRoute:(BOOL)updateRoute name:(OAPointDescription *)name;

- (void) updateRouteAndRefresh:(BOOL)updateRoute;
- (void) addListener:(id<OAStateChangedListener>)l;
- (void) clearPointToNavigate:(BOOL)updateRoute;
- (void) clearStartPoint:(BOOL)updateRoute;
- (void) reorderAllTargetPoints:(NSArray<OARTargetPoint *> *)point updateRoute:(BOOL)updateRoute;
- (void) removeWayPoint:(BOOL)updateRoute index:(int)index;
- (void) restoreTargetPoints:(BOOL)updateRoute;
- (void) removeAllWayPoints:(BOOL)updateRoute clearBackup:(BOOL)clearBackup;

- (BOOL) hasTooLongDistanceToNavigate;

@end
