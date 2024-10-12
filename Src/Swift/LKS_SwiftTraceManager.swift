#if SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKS_TraceManager+Extension.swift
//  LookinServer
//
//  Created by Shida Zhu on 2022/8/21.
//

import Foundation
import UIKit
#if SPM_LOOKIN_SERVER_ENABLED
import LookinServerBase
#endif

public class LKS_SwiftTraceManager: NSObject {
    @objc public static func swiftMarkIVars(ofObject hostObject: AnyObject) {
        var mirror: Mirror? = Mirror(reflecting: hostObject)
        var currClass: AnyClass? = type(of: hostObject)
        let initialInClass: AnyClass? = currClass
        
        while let m = mirror, let unwrappedCurrClass = currClass {
            m.children.forEach { child in
                if let child = child as? (label: String?, value: NSObject) {
                    let label: String? = child.label?.replacingOccurrences(of: "$__lazy_storage_$_", with: "")
                    let value = child.value
                    
                    guard (value is UIView) || (value is CALayer) || (value is UIViewController) || (value is UIGestureRecognizer) else {
                        return
                    }
                    
                    guard let label = label, label.count > 0 else {
                        return
                    }
                    
                    let ivarTrace = LookinIvarTrace()
                    ivarTrace.hostObject = hostObject
                    
                    ivarTrace.hostClassName = makeDisplayClassName(superClass: unwrappedCurrClass, childClass: initialInClass)
                    
                    ivarTrace.ivarName = label
                    
                    if (value === hostObject) {
                        ivarTrace.relation = LookinIvarTraceRelationValue_Self
                    } else if let hostView = hostObject as? UIView {
                        var ivarLayer: CALayer? = nil
                        if let layer = value as? CALayer {
                            ivarLayer = layer
                        } else if let view = value as? UIView {
                            ivarLayer = view.layer
                        }
                        if let layer = ivarLayer, layer.superlayer === hostView.layer {
                            ivarTrace.relation = "superview"
                        }
                    }
                    value.lks_ivarTraces = (value.lks_ivarTraces ?? []) + [ivarTrace]
                }
            }
            mirror = m.superclassMirror
            currClass = unwrappedCurrClass.superclass()
        }
    }
    
    // 比如 superClass 可能是 UIView，而 childClass 可能是 UIButton
    private static func makeDisplayClassName(superClass: AnyClass, childClass: AnyClass?) -> String {
        let superName = NSStringFromClass(superClass)
        
        guard let childClass = childClass else {
            return queryShortClassName(classname: superName)
        }
        let childName = NSStringFromClass(childClass)
        if superName == childName {
            return queryShortClassName(classname: superName)
        }
        let superModule = queryModuleName(classname: superName)
        let childModule = queryModuleName(classname: childName)
        if superModule != nil, superModule == childModule {
            let shortSuperName = queryShortClassName(classname: superName)
            // ( UIKit.UIButton : UIView *)
            return "\(queryShortClassName(classname: childName)) : \(shortSuperName)"
        }
        return "\(queryShortClassName(classname: childName)) : \(superName)"
    }
    
    private static func queryModuleName(classname: String) -> String? {
        let parts = classname.components(separatedBy: ".")
        if parts.count != 2 {
            return nil
        }
        return parts[0]
    }
    
    /// 不包含 module name - 当存在多个命名空间时，这种写法不对
    private static func queryShortName(classname: String) -> String {
        let parts = classname.components(separatedBy: ".")
        if parts.count != 2 {
            return classname
        }
        return parts[1]
    }
    
    private static func queryShortClassName(classname: String) -> String {
        let parts = classname.components(separatedBy: ".")
        if parts.count <= 1 {
            return classname
        }
        
        return parts[1...].joined(separator: ".")
    }
}

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
