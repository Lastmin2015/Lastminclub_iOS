//
//  SearchTravellerTableViewCell.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 12.04.2021.
//

import UIKit

public enum TypeSearchTravellerCell {
    case adultCount
    case childCount
    case childAge
}

class SearchTravellerTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var countView: UIView_count!
    // MARK: - IBAction
    //@IBAction func countButtonPressed(_ sender: UIButton) { addCount(sender.tag) }
    // MARK: - Variables
    var indexPath: IndexPath!
    //var item: String!
    var typeCell: TypeSearchTravellerCell!
    var value: Int!
    var isSelect: Bool = false
    var didSelect: (()->Void)?
    var didUpdateCount: ((Int)->Void)?
    var didUpdateChildCount: ((Int)->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        //setupTextField()
        controlView.decorateView_RoundBorder(4, "009D97", 1)
        countView.didUpdateCount = { (newCount) in
            switch self.typeCell {
            case .adultCount: self.didUpdateCount?(newCount)
            case .childCount: self.didUpdateCount?(newCount)
                //self.didUpdateChildCount?(newCount)
            case .childAge: self.didUpdateCount?(newCount)
            default: ()
            }
        }
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func configureCell() {
        switch typeCell {
        case .adultCount:
            titleLabel.isHidden = false
            subtitleLabel.isHidden = true
            titleLabel.text = "Adults"
            subtitleLabel.text = ""
            countView.setData(minCount: 0, maxCount: 99, count: value)
        case .childCount:
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
            titleLabel.text = "Children"
            subtitleLabel.text = "2 - 17 years old"
            countView.setData(minCount: 0, maxCount: 99, count: value)
        case .childAge:
            titleLabel.isHidden = false
            subtitleLabel.isHidden = true
            titleLabel.text = "\(indexPath.row + 1)st Child’s Age"
            subtitleLabel.text = ""
            countView.setData(minCount: 2, maxCount: 17, count: value)
        default: ()
        }
        //selectImageView.image = UIImage(named: "checkbox_\(isSelect ? "1" : "0")")
        //addressLabel.text = item.fullAddress()
    }
    
    // MARK: - Actions
    private func addCount(_ tag: Int) {
//        let count = Int(textField.text ?? "0") ?? 0
//        let minCount: Int
//        let maxCount: Int
//        switch typeCell {
//        case .adultCount, .childCount: minCount = 0; maxCount = 99
//        case .childAge: minCount = 2; maxCount = 17
//        case .none: return
//        }
//
//        switch tag {
//        case 1:
//            guard count > minCount else { return }
//            textField.text = "\(count - 1)"
//        case 2:
//            guard count < maxCount else { return }
//            textField.text = "\(count + 1)"
//        default: break
//        }
//
//        didUpdateChildCount?(Int(textField.text ?? "0") ?? 0)
    }
}

//// MARK: - UITextFieldDelegate
//extension SearchTravellerTableViewCell: UITextFieldDelegate {
//    private func setupTextField() {
//        textField.delegate = self
//    }
//
//    // MARK: - UITextFieldDelegate
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case textField: textField.resignFirstResponder()
//        default: ()
//        }
//        return true
//    }
//}



/*
 class SearchTravellerTableViewCell: UITableViewCell {
     // MARK: - IBOutlet
     @IBOutlet weak var controlView: UIView!
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var subtitleLabel: UILabel!
     @IBOutlet weak var textField: UITextField!
     // MARK: - IBAction
     @IBAction func countButtonPressed(_ sender: UIButton) { addCount(sender.tag) }
     // MARK: - Variables
     var indexPath: IndexPath!
     var item: String!
     var typeCell: TypeSearchTravellerCell!
     var isSelect: Bool = false
     var didSelect: (()->Void)?
     var didUpdateChildCount: ((Int)->Void)?
     
     // MARK: - LifeCycle
     override func awakeFromNib() {
         super.awakeFromNib()
         self.addTapGesture(self.contentView)
         setupTextField()
         controlView.decorateView_RoundBorder(4, "009D97", 1)
     }
     override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
     
     // MARK: - SetupCell
     func configureCell() {
         switch typeCell {
         case .adultCount:
             titleLabel.isHidden = false
             subtitleLabel.isHidden = true
             titleLabel.text = "Adults"
             subtitleLabel.text = ""
         case .childCount:
             titleLabel.isHidden = false
             subtitleLabel.isHidden = false
             titleLabel.text = "Children"
             subtitleLabel.text = "2 - 17 years old"
         case .childAge:
             titleLabel.isHidden = false
             subtitleLabel.isHidden = true
             titleLabel.text = "\(indexPath.row + 1)st Child’s Age"
             subtitleLabel.text = ""
         default: ()
         }
         //selectImageView.image = UIImage(named: "checkbox_\(isSelect ? "1" : "0")")
         //addressLabel.text = item.fullAddress()
     }
     
     // MARK: - Actions
     private func addCount(_ tag: Int) {
         let count = Int(textField.text ?? "0") ?? 0
         let minCount: Int
         let maxCount: Int
         switch typeCell {
         case .adultCount, .childCount: minCount = 0; maxCount = 99
         case .childAge: minCount = 2; maxCount = 17
         case .none: return
         }
         
         switch tag {
         case 1:
             guard count > minCount else { return }
             textField.text = "\(count - 1)"
         case 2:
             guard count < maxCount else { return }
             textField.text = "\(count + 1)"
         default: break
         }
         
         didUpdateChildCount?(Int(textField.text ?? "0") ?? 0)
     }
 }

 // MARK: - UITextFieldDelegate
 extension SearchTravellerTableViewCell: UITextFieldDelegate {
     private func setupTextField() {
         textField.delegate = self
     }
     
     // MARK: - UITextFieldDelegate
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         switch textField {
         case textField: textField.resignFirstResponder()
         default: ()
         }
         return true
     }
 }
 */
