/// Author: Ramadhan Kalih Sewu
///
/// Purpose: Help the concept of MVVM for Data Binding
///
///

import Foundation

class PropetyObserver<T>
{
    typealias DidSetClosure     = (_ value: T, _ oldValue: T) -> Void
    typealias WillSetClosure    = (_ value: T, _ newValue: T) -> Void
    typealias ChangedClosure    = (_ newValue: T) -> Void
}

enum PropertyObserveType { case typeDidSet, typeWillSet }

@propertyWrapper
struct Bindable<T>
{
    class Listener<T>
    {
        fileprivate var value: T!
        
        fileprivate var didSetClosure: PropetyObserver<T>.ChangedClosure?
        fileprivate var willSetClosure: PropetyObserver<T>.ChangedClosure?
        
        func bind(type: PropertyObserveType = .typeWillSet, _ closure: PropetyObserver<T>.ChangedClosure?)
        {
            if (type == .typeDidSet) { didSetClosure = closure }
            else { willSetClosure = closure }
            closure?(value)
        }
    }
    
    var listener = Listener<T>()

    var wrappedValue: T
    {
        didSet  { listener.didSetClosure?(wrappedValue) }
        willSet { listener.willSetClosure?(newValue) }
    }

    var projectedValue: Listener<T>
    {
        listener.value = wrappedValue
        return listener
    }
}
