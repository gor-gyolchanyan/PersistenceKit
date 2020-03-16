//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

import Foundation
import ObjectiveC

// Type: _PersistentAggregateObjectVariant

struct _PersistentAggregateObjectVariant {

    // Topic: Main

    // Exposed

    init(_aggregateName: String) {
        self._aggregateName = _aggregateName
        _idName = nil
        _objectVariantMapping = .init()
    }

    var _aggregateName: String

    var _idName: String?

    var _objectVariantMapping: [String: _PersistentPrimitiveObjectVariant]
}

// Topic: Main

extension _PersistentAggregateObjectVariant {

    // Exposed

    func _persistentAggregateObjectType() -> _PersistentAggregateObject.Type {
        let nativeTypeName = "\(Self._nativeTypeName(_PersistentAggregateObject.self))_\(_aggregateName)"

        let existingNativeType =
            nativeTypeName
            .withCString { objc_lookUpClass($0) }
            .map { Self._castNativeType($0, to: _PersistentAggregateObject.self) }
            ?? nil

        if let nativeType = existingNativeType {
            return nativeType
        }

        guard
            let nativeType =
                nativeTypeName
                .withCString({ objc_allocateClassPair(_PersistentAggregateObject.self, $0, 0) })
                .map({ Self._forceCastNativeType($0, to: _PersistentAggregateObject.self) })
        else {
            preconditionFailure()
        }

        for (propertyName, propertyType) in _objectVariantMapping {
            guard
                Self._generateProperty(named: propertyName, typed: propertyType, in: nativeType)
            else {
                preconditionFailure()
            }
        }

        guard
            Self._generatePrimaryKeyRepresenter(primaryKey: _idName, modelClass: nativeType)
        else {
            preconditionFailure()
        }

        objc_registerClassPair(nativeType)
        return nativeType
    }

    // Concealed

    private static let _propertySize = MemoryLayout<UnsafeRawPointer>.size
    private static let _propertyAlignment = UInt8(log2(Float64(MemoryLayout<UnsafeRawPointer>.alignment)))
    private static let _strongPropertyAttributeKey = "&"
    private static let _nonatomicPropertyAttributeKey = "N"
    private static let _dynamicPropertyAttributeKey = "D"
    private static let _getterNamePropertyAttributeKey = "G"
    private static let _setterNamePropertyAttributeKey = "S"
    private static let _typePropertyAttributeKey = "T"
    private static let _backingVariableNamePropertyAttributeKey = "V"
    private static let _emptyPropertyAttributeValue = ""
    private static let _getterMethodTypeCode = "@@:"
    private static let _setterMethodTypeCode = "v@:@"

    private static func _nativeTypeName(_ dynamicClass: AnyObject.Type) -> String {
        String(cString: class_getName(dynamicClass))
    }

    private static func _castNativeType<Object>(_ dynamicClass: AnyObject.Type, to staticClass: Object.Type = Object.self) -> Object.Type?
    where Object: AnyObject {
        assert(staticClass === Object.self)
        return dynamicClass as? Object.Type
    }

    private static func _forceCastNativeType<Object>(_ dynamicClass: AnyObject.Type, to staticClass: Object.Type = Object.self) -> Object.Type
    where Object: AnyObject {
        guard let result = _castNativeType(dynamicClass, to: staticClass) else {
            let dynamicClass = String(reflecting: _nativeTypeName(dynamicClass))
            let staticClass = String(reflecting: _nativeTypeName(staticClass))
            preconditionFailure("Class \(dynamicClass) is not the same class as or a subclass of \(staticClass)).")
        }
        return result
    }

    private static func _generatePrimaryKeyRepresenter(primaryKey: String?, modelClass: _PersistentAggregateObject.Type) -> Bool {
        guard let modelMetaClass = object_getClass(modelClass) else {
            return false
        }
        let methodBlock: @convention(block) (_PersistentAggregateObject.Type, Selector) -> String? = { _self, _cmd in
            primaryKey
        }
        let methodImp = imp_implementationWithBlock(methodBlock)
        return _getterMethodTypeCode.withCString { typeCode in
            class_addMethod(
                modelMetaClass,
                #selector(_PersistentAggregateObject.primaryKey),
                methodImp,
                typeCode
            )
        }
    }

    private static func _generateProperty(named primitiveName: String, typed primitiveType: _PersistentPrimitiveObjectVariant, in aggregateObjectType: _PersistentAggregateObject.Type) -> Bool {
        var isSuccessful: Bool

        let backingVariableName = "_\(primitiveName)"

        isSuccessful =
            backingVariableName.withCString { backingVariableName in
            primitiveType._code.withCString { primitiveType in
                let size = Self._propertySize
                let alignment = Self._propertyAlignment
                return class_addIvar(
                    aggregateObjectType,
                    backingVariableName,
                    size,
                    alignment,
                    primitiveType
                )
            }}
        guard isSuccessful else { return false }



        let getterSelector = Selector("_get_\(primitiveName)")
        let getterFunction: @convention(block) (
            _PersistentAggregateObject,
            Selector
        ) -> Any? = { _self, _cmd in
            guard let backingVariable =
                backingVariableName.withCString({ class_getInstanceVariable(aggregateObjectType, $0) })
            else {
                preconditionFailure()
            }

            return object_getIvar(_self, backingVariable)
        }
        isSuccessful = Self._getterMethodTypeCode.withCString { getterMethodTypeCode in
            class_addMethod(
                aggregateObjectType,
                getterSelector,
                imp_implementationWithBlock(getterFunction),
                getterMethodTypeCode
            )
        }
        guard isSuccessful else { return false }

        let willChangeValueForKey: (_PersistentAggregateObject) -> (String) -> () = _PersistentAggregateObject.willChangeValue
        let didChangeValueForKey: (_PersistentAggregateObject) -> (String) -> () = _PersistentAggregateObject.didChangeValue
        let setterSelector = Selector("_set_\(primitiveName):")
        let setterFunction: @convention(block) (
            _PersistentAggregateObject,
            Selector,
            Any?
        ) -> Void = { _self, _cmd, _value in
            guard let backingVariable =
                backingVariableName.withCString({ class_getInstanceVariable(aggregateObjectType, $0) })
            else {
                preconditionFailure()
            }

            willChangeValueForKey(_self)(primitiveName)
            object_setIvar(_self, backingVariable, _value)
            didChangeValueForKey(_self)(primitiveName)
        }
        isSuccessful = Self._setterMethodTypeCode.withCString { setterMethodTypeCode in
            class_addMethod(
                aggregateObjectType,
                setterSelector,
                imp_implementationWithBlock(setterFunction),
                setterMethodTypeCode
            )
        }
        guard isSuccessful else { return false }

        isSuccessful =
            Self._strongPropertyAttributeKey.withCString { strongAttributeKey in
            Self._nonatomicPropertyAttributeKey.withCString { nonatomicAttributeKey in
            Self._dynamicPropertyAttributeKey.withCString { dynamicAttributeKey in
            Self._getterNamePropertyAttributeKey.withCString { getterNameAttributeKey in
            Self._setterNamePropertyAttributeKey.withCString { setterNameAttributeKey in
            Self._typePropertyAttributeKey.withCString { typeAttributeKey in
            Self._backingVariableNamePropertyAttributeKey.withCString { backingVariableNameAttributeKey in
            Self._emptyPropertyAttributeValue.withCString { emptyAttributeValue in
            getterSelector.description.withCString { getterNameAttributeValue in
            setterSelector.description.withCString { setterNameAttributeValue in
            primitiveType._code.withCString { typeAttributeValue in
            backingVariableName.withCString { backingVariableNameAttributeValue in
                let attributes: ContiguousArray<objc_property_attribute_t> = [
                   .init(name: strongAttributeKey, value: emptyAttributeValue),
                   .init(name: nonatomicAttributeKey, value: emptyAttributeValue),
                   .init(name: dynamicAttributeKey, value: emptyAttributeValue),
                   .init(name: getterNameAttributeKey, value: getterNameAttributeValue),
                   .init(name: setterNameAttributeKey, value: setterNameAttributeValue),
                   .init(name: typeAttributeKey, value: typeAttributeValue),
                   .init(name: backingVariableNameAttributeKey, value: backingVariableNameAttributeValue)
               ]
               return attributes.withUnsafeBufferPointer { attributes in
                   guard
                       let attributesStart = attributes.baseAddress,
                       let attributesCount = UInt32(exactly: attributes.count)
                   else {
                       return false
                   }
                   return primitiveName.withCString { primitiveName in
                       class_addProperty(
                           aggregateObjectType,
                           primitiveName,
                           attributesStart,
                           attributesCount
                       )
                   }
               }
            }}}}}}}}}}}}
        guard isSuccessful else { return false }

        return true
    }
}
