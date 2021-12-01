//
//  UIView_count.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 16.04.2021.
//

import UIKit

class UIView_count: UIView {
    // MARK: - IBOutlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var controlView: UIView!
    // MARK: - IBAction
    @IBAction func countButtonPressed(_ sender: UIButton) { addCount(sender.tag) }
    // MARK: - Variables
    // MARK: Private Properties
    var minCount: Int = 0
    var maxCount: Int = 99
    var count: Int = 0// {  didSet { updateCode() } }
    var didUpdateCount: ((Int)->Void)?
    
    var keyboardType: UIKeyboardType = .numberPad
    var keyboardAppearance: UIKeyboardAppearance = .light
    
    // MARK: - MainInit
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInit()
    }
    private func setupInit() {
        Bundle.main.loadNibNamed("UIView_count", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //++
        controlView.decorateView_RoundBorder(4, "009D97", 1)
        //++
        setupTextField()
    }
    
    // MARK: - Actions
    private func addCount(_ tag: Int) {
        let newCount = count + ((tag == 1) ? -1 : +1)
        setNewCount(newCount)
    }
    private func setNewCount(_ newCount: Int) {
        guard (minCount <= newCount) && (newCount <= maxCount) else { return }
        count = newCount
        textField.text = "\(count)"
        didUpdateCount?(count)
    }
}

// MARK: - UITextFieldDelegate
extension UIView_count: UITextFieldDelegate {
    private func setupTextField() {
        textField.delegate = self
        textField.text = "\(count)"
        textField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
    }
    @objc func tapDone() { textField.resignFirstResponder() }
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField: textField.resignFirstResponder()
        default: ()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" { textField.text = "" }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //if textField.isEmpty { textField.text = "0"; count = minCount; }
        if textField.isEmpty || (textField.textStr == "0")
        { count = minCount; textField.text = "\(count)" }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("count: \(count)")
        
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            textField.text!.removeLast()
            count = Int(textField.textStr) ?? 0
            return false
        }
        
        var countStr = (count == 0) ? "" : "\(count)"
        countStr.append(contentsOf: string)
        
        guard let newCount = Int(countStr) else { return false }
        guard (minCount <= newCount) && (newCount <= maxCount) else { return false }
        count = newCount
        textField.text = "\(count)"
        didUpdateCount?(count)
        return false
    }
}

// MARK: - PublicFunctions
extension UIView_count {
    public func setData(minCount: Int, maxCount: Int, count: Int) {
        self.minCount = minCount
        self.maxCount = maxCount
        self.count = count
        
        textField.text = "\(count)"
    }
}
