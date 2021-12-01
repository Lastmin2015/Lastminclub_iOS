//
//  DurationViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

class DurationViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgDateView: UIView!
    @IBOutlet weak var bgDurationWeekView: UIView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var calendarCV: UICollectionView!
    @IBOutlet weak var dur3Button: UIButton!
    @IBOutlet weak var dur7Button: UIButton!
    @IBOutlet var durWeekStackViewList: [UIStackView]!
    @IBOutlet var durWeekImageViewList: [UIImageView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func durDaysButtonPressed(_ sender: UIButton) { selectDurDays(sender.tag) }
    @IBAction func nextMonthButtonPressed(_ sender: UIButton) { nextMonth(sender.tag) }
    // MARK: - Variables
    var durDays: Int = 3
    var calendarMonth = CalendarMonth(year: Date().year(), month: Date().month())
    var date: Date = Date().startOfDay()
    var durationWeek: Int = 1
    var didSelect: ((Period)->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupCollectionView()
        setupFormData()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Screen.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Screen.lockOrientation(.all)
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        // Calendar
        setupData_calendar()
    }
    
    
    // MARK: - Actions
    private func selectDurDays(_ tag: Int) {
        durDays = (tag == 1) ? 3 : 7
        setupUI_durDays()
        calendarCV.reloadData()
    }

    // MARK: - SetupUI
    private func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        bgDateView.decorateView_shadow()
        bgDurationWeekView.decorateView_shadow()
        setupUI_durDays()
        setupUI_durationWeek()
    }
    private func setupUI_durDays() {
        let im0 = UIImage(named: "checkbox0")
        let im1 = UIImage(named: "checkbox1")
        dur3Button.setImage((durDays == 3) ? im1 : im0, for: .normal)
        dur7Button.setImage((durDays == 7) ? im1 : im0, for: .normal)
    }

    // MARK: - Navigation
    private func goToVC() {
        //let vc: PswViewController = UIStoryboard.controller(.auth)
        //vc.email = Validator().email_clear(emailTextField.text)
        //self.pushVC(vc)
    }
}

// MARK: - CALENDAR
extension DurationViewController {
    private func setupData_calendar() {
        monthYearLabel.text = "\(calendarMonth.nameMonth()) \(calendarMonth.year)"
        calendarCV.reloadData()
    }
    private func nextMonth(_ tag: Int) {
        let newDate = calendarMonth.firstDate().addMonth((tag == 1) ? -1 : 1)
        calendarMonth = CalendarMonth(date: newDate)
        setupData_calendar()
    }
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DurationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        calendarCV.delegate = self
        calendarCV.dataSource = self
        calendarCV.registerCellNib(CalendarCollectionViewCell.className)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarMonth.dayList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalendarCollectionViewCell = collectionView.getCell(indexPath)
        cell.calendarDay = calendarMonth.dayList[indexPath.row]
        cell.calendarMonth = calendarMonth
        cell.durDays = durDays
        cell.configureCell()
        cell.didSelect = { self.didSelectDay(indexPath) }
        return cell
    }
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension DurationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCVCell = (collectionView.bounds.width - 6) / 7
        return CGSize(width: widthCVCell, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    } //интервал между ячейками в строке
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    } //интервал между последовательными строками или столбцами раздела
}
// MARK: - ActionCell
extension DurationViewController {
    private func didSelectDay(_ indexPath: IndexPath) {
        let calendarDay = calendarMonth.dayList[indexPath.row]
        guard calendarDay.inMonth else { return }
        //calendarCV.reloadData()
        //calendarCV.reloadItems(at: calendarMonth.selectDate(calendarDay.date))
        _ = calendarMonth.selectDate(calendarDay.date)
        calendarCV.reloadData()
        //
        let d0 = calendarDay.date.addDay(-1*durDays)
        let d1 = calendarDay.date.addDay(+1*durDays)
        didSelect?(Period(d0, d1))
        //dateLabel.text = calendarDay.date.toString(dateF2_EEEEdMMMMyy)
        //updateEventList(calendarDay.date)
    }
    private func updateEventList(_ date: Date) {
//        let item = Event(id: 1, date: date, name: "test name", infoSmall: "test small info", text: "test", city: "Kiev")
//        list = [item, item, item, item, item, item, item, item, item, item]
//        //tableView.frame.size.height = tableView.contentSize.height
//        tableView.reloadData()
//        //tableView.frame.size.height = tableView.contentSize.height
//        heightTableViewConstraint.constant = CGFloat(116 * list.count)
    }
}

// MARK: - setupTapGestureRecognizer_
extension DurationViewController {
    private func setupTapGestureRecognizer() {
        durWeekStackViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_durWeek))) }
    }
    @objc private func tap_durWeek(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        durationWeek = tag
        setupUI_durationWeek()
    }
    private func setupUI_durationWeek() {
        durWeekImageViewList.forEach {
            let imageName = "radiocheck\((durationWeek == $0.tag) ? "1" : "0")"
            $0.image = UIImage(named: imageName)
        }
    }
}
