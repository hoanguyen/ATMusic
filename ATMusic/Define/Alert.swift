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
typealias InputTextConfirmYes = (text: String) -> Void

class Alert {
    static var sharedInstance = Alert()

    func showAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.Yes, style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

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

    func inputTextAlert(viewController: UIViewController, title: String,
        message: String, confirmHandler confirmYes: InputTextConfirmYes) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: Strings.Confirm, style: .Default, handler: { (action: UIAlertAction) in
                if let textFields = alert.textFields, text = textFields[0].text {
                    confirmYes(text: text)
                }
                }))
            alert.addAction(UIAlertAction(title: Strings.Cancel, style: .Default, handler: { (action: UIAlertAction!) in
                alert .dismissViewControllerAnimated(true, completion: nil)
                }))
            alert.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Playlist name"
            }
            viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
