//
//  Alert.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/11/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

typealias ConfirmYes = () -> Void
typealias InputTextConfirmYes = (text: String, usingPlaceHolder: Bool) -> Void
typealias ConfirmPlaylistFinished = (index: Int?, isCreate: Bool) -> Void

private let kNumberItemOverHeight = 4 // if number of item >= 4, the alert height will be bigger

class Alert {
    static var sharedInstance = Alert()
    // Default alert
    func showAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.Yes, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    // Confirm alert, choose Yes or No
    func showConfirmAlert(viewController: UIViewController, title: String, message: String, confirmYes: ConfirmYes) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.Confirm, style: .Default, handler: { (action: UIAlertAction!) in
            confirmYes()
            }))
        alert.addAction(UIAlertAction(title: Strings.Cancel, style: .Default, handler: { (action: UIAlertAction!) in
            alert .dismissViewControllerAnimated(true, completion: nil)
            }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    // input text alert, to create something.
    func inputTextAlert(viewController: UIViewController, title: String,
        message: String, placeholder: String, confirmHandler confirmYes: InputTextConfirmYes) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: Strings.Confirm, style: .Default, handler: { (action: UIAlertAction) in
                if let textFields = alert.textFields, var text = textFields[0].text {
                    var isUse = false
                    if text == "" {
                        text = textFields[0].placeholder ?? Strings.PlaylistNamePlaceHolder
                        isUse = true
                    }
                    confirmYes(text: text, usingPlaceHolder: isUse)
                }
                }))
            alert.addAction(UIAlertAction(title: Strings.Cancel, style: .Default, handler: { (action: UIAlertAction!) in
                alert .dismissViewControllerAnimated(true, completion: nil)
                }))
            alert.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = placeholder
            }
            viewController.presentViewController(alert, animated: true, completion: nil)
    }
    // show actionsheet
    func showActionSheet(viewController: UIViewController, title: String?, message: String?,
        options: [String]?, confirmHandler confirm: ConfirmPlaylistFinished?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: Strings.AddNew, style: .Destructive, handler: { (action) in
                confirm?(index: nil, isCreate: true) }))
            if let options = options {
                if options.count >= kNumberItemOverHeight { // fixed height of alert height equal with 4 items.
                    let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .Height,
                        relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
                        multiplier: 1, constant: viewController.view.bounds.height / 3 * 2)
                    alert.view.addConstraint(height)
                }
                for (index, item) in options.enumerate() {
                    alert.addAction(UIAlertAction(title: item, style: .Default, handler: { (action: UIAlertAction) in
                        confirm?(index: index, isCreate: false)
                        }))
                }
            }
            alert.addAction(UIAlertAction(title: Strings.Cancel, style: .Cancel, handler: nil))
            viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
