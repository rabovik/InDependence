
# InDependence

_InDependence_ is a Dependency Injection (DI) framework for iOS written in Objective-C. Key features are:

* Support for _child-to-parent_ and other _object-to-relatives_ references. It makes integration of DI to old legacy code much easier.
* Extendable design of framework encourages writing custom extensions for adapting _InDependence_ to own needs.

## Project status
**Álpha**. Public interface may change.

## Features

* "Annotation" based Dependency Injection
* Binding system
    * Class bindings
    * Protocol bindings
* Bindings may be grouped into modules
* _Child-to-parent_ references
* _Object-to-relatives_ references
* Initializer support
    * Default and custom arguments
* Singleton annotations
* Objects are notified when injection is complete
* Extensions for adding own features

## How to use InDependence

### Basic Usage
![][requirements]

The `independence_requirements` macros used to declare what dependencies _InDependence_ should inject to all instances it creates of that class. `independence_requirements` can be used safely with inheritance.

```objective-c
@class Wheel;

@interface Chassis : NSObject
// Will be injected by InDependence
@property(nonatomic,strong) Wheel *wheel;
@end

@interface Car : NSObject
// Will be injected by InDependence
@property(nonatomic,strong) Chassis *chassis;
// Will be injected by InDependence
@property(nonatomic,strong) Engine *engine;
@end

@implementation Chassis
independence_requirements(@"wheel");
@end

@implementation Car
independence_requirements(@"chassis",@"wheel");
@end
```

### Fetching objects from injector

An object can be fetched by asking _injector_ for an instance of a particular class or protocol. An injector manages its own context. It means that a singleton is per injector and is not necessarily a *true* singleton.

```objective-c
- (void)someMethod {
    INDInjector *injector = [INDInjector sharedInjector];
    Car *car = [injector getObject:[Car class] 
                            parent:nil]; // Car is root object
}
```
Shared _injector_ may be changed at any time:

```objective-c
INDInjector newInjector = [INDInjector new];
[INDInjector setSharedInjector:newInjector];
```


### References
![][references]

_InDependence_ can automatically fill in references to parents, ancestors and any other relatives. References must be declared as `weak`.

```objective-c

@interface Wheel()
// Will be filled in by InDependence
@property(nonatomic,weak) Chassis *chassis;
// Will be filled in by InDependence
@property(nonatomic,weak) Car *car;
@end

@interface Engine()
// Will be filled in by InDependence
@property(nonatomic,weak) Wheel *wheel;
@end

@implementation Wheel
independence_references(@"chassis",@"car");
@end

@implementation Engine
independence_references(@"wheel");
// ...
@end
```

### Awaking from Injector
If an object is interested in knowing when it has been fully instantiated by _InDependence_ it can implement the method `awakeFromInjector`.

```objective-c
@implementation Car
// ...
-(void)awakeFromInjector{
    NSLog(@"%@ awaked",self);
}
@end  
```  

### Modules

A module is a set of bindings which contributes additional configuration information to the injector. It is especially useful for integrating external dependencies and binding protocols to classes or instances.

#### Class bindings
![][bindings]
```objective-c
@interface MyModule : INDModule
@end

@implementation MyModule
- (void)configure {
    [self bindClass:[UnibodyChassis class] toClass:[Chassis class]];
    [self bindClass:[HybridEngine class] toClass:[Engine class]];
}
@end
```
```objective-c
[[INDInjector sharedInjector] addModule:[MyModule new]];
Car *car = [[INDInjector sharedInjector] getObject:[Car class]
                                            parent:nil];
NSLog(@"%@",NSStringFromClass([car.chassis class])); // UnibodyChassis
NSLog(@"%@",NSStringFromClass([car.engine class])); // HybridEngine
```

#### Recursive bindings
![][recursive]

There may be binding rules for already binded classes (for example, in another module). _InDependence_ finds appropriate class by recursion.
```objective-c
-(void)configure{
    [self.injector bindClass:[Ford class] toClass:[Car class]];
    [self.injector bindClass:[FordFocus class] toClass:[Ford class]];
}
// ...
Car *car = [[InDependenceInjector sharedInjector] getObject:[Car class]];
NSLog(NSStringFromClass([car class])); // FordFocus
```

### Initializers

By default, _InDependence_ allocates objects with the default initializer `init`. If you'd like to instantiate an object with an alternate initializer the `independence_initializer` macros can be used to do so. The macros supports passing in default arguments (scalar values are not supported).

```objective-c
@interface ColoredCar : Car
-(id)initWithColor:(NSString *)color;
@property(nonatomic,copy) NSString *color;
@end

@implementation ColoredCar
independence_initializer(initWithColor:,@"Black");
-(id)initWithColor:(NSString *)color{
    if (!(self = [super init])) return self;
    _color = color;
    return self;
}
@end

```
```objective-c
ColoredCar *carWithDefaultColor = 
    [[INDInjector sharedInjector] getObject:[ColoredCar class] 
                                     parent:nil];
NSLog(@"%@",carWithDefaultColor.color); // Black

ColoredCar *carWithCustomColor = 
    [[INDInjector sharedInjector] getObject:[ColoredCar class] 
                                     parent:nil 
                                  arguments:@"Red",nil];
NSLog(@"%@",carWithCustomColor.color); // Red
```

### Singletons
![][singleton]

Any class may be annotated as a singleton using `independence_singleton()` macros.
```objective-c
@interface Road : NSObject
@end
@implementation Road
independence_singleton();
@end
```
```objective-c
@interface Car()
@property(nonatomic,strong) Road *road;
@end

@implementation Car
independence_requirements(@"chassis",@"wheel",@"road");
// …
@end

```
```objective-c
Car *car = [[INDInjector sharedInjector] getObject:[Car class] parent:nil];
Car *anotherCar = [[INDInjector sharedInjector] getObject:[Car class] parent:nil];
NSLog(@"%d",[car.road isEqual:anotherCar.road]); // 1
```

## Installation
Add sources from `InDependence` folder to your project. Enable ARC for them. Add `InDependence.h` to your project's `.pch` file:
    
    #import "InDependence.h"

## Requirements
* iOS 5.0 and later
* ARC

## License
MIT License.

## TODO

* Better README
    * _Objects Tree_ and correct _parent_ specifying
    * Protocol bindings
    * Binded arguments
    * Inline modules
    * Extensions
* Bindings
    * Instance bindings
    * Custom factory blocks
    * Custom _post-init_ blocks
* References
    * Dynamically provided references 

## Acknowledgments
Some code and ideas derived from [Objection][Objection] by Justin DeWind.

[Objection]: https://github.com/atomicobject/objection
[requirements]: docs/img/2450eb31.png
[references]: docs/img/9ab14a6e.png
[bindings]: docs/img/05a93d38.png
[recursive]: docs/img/bf3f46b8.png
[singleton]: docs/img/8c227fd0.png
