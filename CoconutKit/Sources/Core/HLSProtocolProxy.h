//
//  HLSProtocolProxy.h
//  CoconutKit
//
//  Created by Samuel Défago on 25.04.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

// Forward declarations
@class HLSZeroingWeakRef;

// TODO: Put the restricted interface stuff first
// TODO: 1st option: Depending on the set of files which get included, different views of the same object
//       A single object type, not two. Can be misleading
// TODO: Document: Useful: Use several protocols (not necessarily orthogonal) to create several different
//       proxy interfaces

/**
 * HLSProtocolProxy allows the easy creation of lightweight proxy objects through which interaction with the 
 * underlying object only happens through a restricted subset of its interface. The common restricted 
 * interface subset is formally declared using one or several protocols made of optional methods only. The
 * protocols are used to check a class and a proxy class for compatibility when the proxy gets created. When 
 * calling a method on a proxy object, the call is transparently forwarded to the underlying object. No deep
 * copy of the original object is ever made. Clients of proxy objects are therefore guaranteed to access 
 * the original object data, not simply a snapshot of it.
 * 
 * A common example is an object which offers readonly access only to an underlying otherwise mutable
 * object. Where method forwarding does not conflict with performance requirements, an HLSProtocolProxy
 * object is a very convenient way to create a from a mutable one without a single line
 * of code
 *
 * If we want to implement an object offering a restricting interface to another one, we already have 
 * several options, but none of them is optimal:
 *   - use a single class for both objects.     , whose interface is spread on several header files. The main class interface 
 *     declaration contains the restricted set of methods through which the common 
 
 // cumbersome if different interface subsets wanted (severa)
 
 *   - create a class  immutable class interface, and an associated Friend category which collects all mutators.
 *     The class interface itself must contain creation and accessor methods only. In the class .m implementation 
 *     file, and from any other source file which requires the ability to mutate the object, include the Friend 
 *     category header file to access the whole interface. Clients which only need to interact with the object 
 *     in a mutable way include the class header file only. This way the compiler will report unknown method
 *     calls if a client tries to call some mutator on the class when only the class header file has been included
 *   - make the immutable class inherit from the mutable class, and enrich its interface with mutators. In
 *     such cases, though, the subclass must still implement the mutators, usually by calling mutator methods
 *     which the immutable class must secretly provide (using private Friend header files is a way to achieve 
 *     this). Where a mutable object must be accessed in an immutable way, we simply return the mutable object, 
 *     cast to its immutable counterpart. This is of course dangerous since callers might be tempted to cast this
 *     object back to its original mutable identity
 *   - provide a method to create an immutable copy from a mutable object. This requires a lot of boilerplate
 *     code just to copy the internal data of the mutable object into the immutable one. This also requires
 *     both classes to implement the accessors needed to read the data. Moreover, we obtain a data
 *     snapshot, the immutable object will stay the same as the mutable one changes
 *
 * In the first case, all the implementation resides in the immutable class .m file. In the second case,
 * some code must be written in the mutable class .m file as well. In the third case, most code must be
 * duplicated.
 *
 * HLSProtocolProxy offers a fourth way of elegantly solving this problem: The immutable methods common to
 * both classes are collected in a protocol whose methods must all be optional. Two separate classes must 
 * then be created, conforming to this common contract:
 *   - the mutable class, which contains the implementation of all methods (accessors and mutators), and
 *     which declare mutators in its interface (those are added to the methods declared in the protocol
 *     to create the full mutable class interface)
 *   - a subclass of the abstract HLSProtocolProxy class. The subclass does not require any implementation 
 *     (in fact it must not be implemented at all, otherwise the behavior is undefined) and only offers
 *     immutable access to the underyling object
 *
 * The goal of the HLSProtocolProxy subclass is only to forward the calls to the methods declared by the common
 * protocol transparently to the immutable implementation. This way, we directly access the mutable object,
 * but in an immutable way. If the mutable object changes, we transparently access its updated data through
 * the immutable proxy subclass. No additional code is required.
 *
 * All protocol methods must be optional so that the proxy subclass does not require any implementation
 * (having required methods would be better, but this would lead to compiler warnings, though everything
 * would work fine at runtime. I could not find a way to inhibit such warnings, though).
 *
 *
 * The common contract between original and proxy classes can be defined using several protocols if needed.
 * All that is required is that the original class at least conforms to all protocols the proxy class conforms
 * to. If an incompatibilty is detected, a proxy cannot be created.
 *
 * Instantiating an HLSProtocolProxy object is a lightweight process. Compatibility between classes and their
 * proxy counterparts is performed once and cached. The method call overhead is also minimal since the proxy object 
 * only forwards calls to the original object, nothing more.
 *
 * The proxy object does not retain the object it is created from. If the object gets deallocated, all associated
 * proxy objects are automatically set to nil.
 *
 * Designated initializer: initWithTarget:
 */
@interface HLSProtocolProxy : NSProxy {
@private
    HLSZeroingWeakRef *_targetZeroingWeakRef;
}

/**
 * Convenience constructor
 */
+ (id)proxyWithTarget:(id)target;

/**
 * Create a proxy for a given target. Creation fails if the protocols implemented by both classes are not
 * compatible
 */
- (id)initWithTarget:(id)target;

@end