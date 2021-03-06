# Location Tagging

Geospatial coordinates can be stored on an object using a `CMGeoPoint` object. For this example, we'll be saving the object shown below.

```objc
@interface CMCar : CMObject
 
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (nonatomic) NSInteger year;
@property (strong, nonatomic) CMGeoPoint *currentLoc;
 
@end
```

Once a CMGeoPoint is defined on an object, it can be initialized and saved.

```objc
// assume we've already initialized this
CMCar *car;
// the owner of the object, assume this has been previously initialized
CMUser *user;
 
car.currentLoc = [[CMGeoPoint alloc] initWithLatitude:20.2 andLongitude:-70.5];
 
[car saveWithUser:user];
```

Now that CMCar objects have a location field, we can use searching to find user objects within a certain radius.

```objc
[store searchUserObjects:@"[currentLoc near (20.0, -70.0)]"
   additionalOptions:nil
            callback:^(CMObjectFetchResponse *response) {
                NSLog(@"Objects: %@", response.objects);
            }
];
```
