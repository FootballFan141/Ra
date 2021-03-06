import Foundation

public class Injector {
    public init() {}

    private var creationMethods : [String: (Void) -> (NSObject)] = [:]

    public func create(klass: AnyClass) -> NSObject {
        if let closure : (Void) -> (NSObject) = creationMethods[klass.description()] {
            let obj = closure()
            self.setInjectorIfPossible(obj)
            return obj
        }
        let aClass = (klass as NSObject.Type) // This is ugly, forcing a reliance on NSObject
        
        let obj = aClass()
        self.setInjectorIfPossible(obj)
        return obj
    }

    public func create(str: String) -> NSObject? {
        let obj = creationMethods[str]?()
        self.setInjectorIfPossible(obj)
        return obj
    }
    
    private func setInjectorIfPossible(object: NSObject?) {
        object?.injector = self
    }
    
    // MARK: Adding creation methods
    // TODO: rename "creation method" to something better.

    public func bind(klass: AnyClass, to: @autoclosure () -> (NSObject)) {
        self.creationMethods[klass.description()] = to
    }

    public func bind(string: String, to: @autoclosure () -> (NSObject)) {
        self.creationMethods[string] = to
    }
    
    public func bind(klass: AnyClass, toClosure: (Void) -> (NSObject)) {
        self.creationMethods[klass.description()] = toClosure
    }
    
    public func bind(string: String, toClosure: (Void) -> (NSObject)) {
        self.creationMethods[string] = toClosure
    }
    
    public func removeBinding(klass: AnyClass) {
        self.creationMethods.removeValueForKey(klass.description())
    }
    
    public func removeBinding(string: String) {
        self.creationMethods.removeValueForKey(string)
    }
}
