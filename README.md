
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

The `independence_requirements` macro used to declare what dependencies _InDependence_ should inject to all instances it creates of that class. `independence_requirements` can be used safely with inheritance.

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


### Child-to-parent references
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
#### Example

### Modules
#### Class bindings
![][bindings]

#### Instance and protocol bindings



#### Recursive bindings
![][recursive2]

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
#### Default Arguments Example
####  Custom Arguments Example

### Singletons
![][singleton]


## Extensions
_(TODO)_

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
* Bindings
    * Instance bindings
    * Custom factory blocks
    * Custom _post-init_ blocks
* References
    * Dynamically provided references 

## Acknowledgments
Some code and ideas derived from [Objection][Objection] by Justin DeWind.

[Objection]: https://github.com/atomicobject/objection
[requirements]: docs/img/b5b2f18b.png
[bindings2]: docs/img/ee66eff9.png
[bindings]: docs/img/e90379af.png
[references]: docs/img/41ba975a.png
[recursive]: docs/img/47a78d9d.png
[recursive2]: docs/img/bf3f46b8.png
[singleton]: docs/img/5fd9b515.png
