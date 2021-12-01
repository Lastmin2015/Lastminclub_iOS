//
//  UIViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import UIKit
import MBProgressHUD

// MARK: - Keyboard
extension UIViewController: UIGestureRecognizerDelegate {
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton { return false }
        return true
    }
}

//// MARK: - Notification Keyboard funcs
//extension UIViewController {
//    func setupNotificationObserversOfKeyboard() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    func removeNotificationObserversOfKeyboard() {
//        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc func handleKeyboardShow(notification: NSNotification){
//        //guard let kybFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        //scrollView.contentInset.bottom = view.convert(kybFrame, from: nil).size.height
//    }
//
//    @objc func handleKeyboardHide(notification: NSNotification){
//        //scrollView.contentInset.bottom = 0
//    }
//}

// MARK: - present
@nonobjc extension UIViewController {
    // MARK: - Navigation
    func present(_ vc: UIViewController, _ modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        vc.modalPresentationStyle = modalPresentationStyle
        self.present(vc, animated: true, completion: nil)
    }
    // navigationController
    func pushVC(_ vc: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    func popVC(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    // MARK: - Вывод предупреждений и сообщений об ошибках
    func displayAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func displayAlertCompletion(_ title: String, _ message: String, completion: @escaping () -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
    func displayAlertYesNo(_ title: String?, _ message: String?, completion: @escaping (_ isYes: Bool) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (_) in completion(true) }
        let actionNo = UIAlertAction(title: "No", style: .default) { (_) in completion(false) }
        alertVC.addAction(actionNo)
        alertVC.addAction(actionYes)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}

//// MARK: - PopUp
//@nonobjc extension UIViewController {
//    func presentPopUp(_ child: UIViewController, _ frame: CGRect? = nil) {
//        addChild(child)
//        if let frame = frame { child.view.frame = frame }
//        view.addSubview(child.view)
//        child.didMove(toParent: self)
//    }
//    func removePopUp() {
//        guard parent != nil else { return }
//        willMove(toParent: nil)
//        view.removeFromSuperview()
//        removeFromParent()
//    }
//}

// MARK: - MBProgressHUD
extension UIViewController {
    func hudShow(title: String = "", description: String = "") {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.mode = .indeterminate
        indicator.label.text = title
        indicator.isUserInteractionEnabled = true
        indicator.detailsLabel.text = description
        indicator.contentColor = hexToUIColor("009d97")
        indicator.show(animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hudHide() {
        MBProgressHUD.hide(for: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
