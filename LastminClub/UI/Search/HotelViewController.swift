//
//  HotelViewController.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 21.04.2021.
//

import UIKit
import ImageSlideshow
import Kingfisher

class HotelViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distCityLabel: UILabel!
    @IBOutlet weak var distSeaLabel: UILabel!
    @IBOutlet weak var distAirPortLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var fDetailsPortsLabel: UILabel!
    @IBOutlet weak var fDetailsTimeLabel: UILabel!
    @IBOutlet weak var boardingLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var transferLabel: UILabel!
    @IBOutlet weak var tableView: UITableView_ContentSized!
    @IBOutlet weak var bookPriceLabel: UILabel!
    @IBOutlet weak var bookDatesLabel: UILabel!
    @IBOutlet weak var bgBookView: UIView!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { popVC() }
    @IBAction func bookButtonPressed(_ sender: UIButton) { goToOrderVC() }
    // MARK: - Variables
    var item: Tour!
    var tourList: [Tour] = Tour.demoList()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_slideShow()
        setupTableView()
        setupTapGestureRecognizer()
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
        nameLabel.text = item.hotel?.name
        locationLabel.text = item.hotel?.location
        distCityLabel.text = item.hotel?.distCity
        distSeaLabel.text = item.hotel?.distSea
        distAirPortLabel.text = item.hotel?.distAirport
        infoLabel.text = item.hotel?.info_main
        boardingLabel.text = "All Inclusive"
        roomTypeLabel.text = "Sea View"
        transferLabel.text = "Bus"
        fDetailsPortsLabel.text = item.fDetailsPorts//"LED - GRE"
        fDetailsTimeLabel.text = item.fDetailsTimeLabel//"2 Stops, 12h 35m"
        
        bookPriceLabel.text = item.priceStr()
        bookDatesLabel.text = item.periodStr()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        bgBookView.layer.applyShadow(blur: 30, x: 0, y: -5, "000000", 0.1)
        tableView.round(10)
    }

    // MARK: - Navigation
    private func goToOrderVC() {
        let vc: OrderViewController = UIStoryboard.controller(.book)
        //vc.tour = Tour.demo1()
        self.pushVC(vc)
    }
    private func goToFlightsDetailsVC() {
        let vc: FlightsDetailsViewController = UIStoryboard.controller(.flight)
        vc.list = item.flightList
        self.pushVC(vc)
    }
}

// MARK: - setupTapGestureRecognizer_
extension HotelViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        switch tag {
        case 1:
            guard let hotel = item.hotel else { return }
            let vc: HotelDescriptionViewController = UIStoryboard.controller(.search)
            vc.item = hotel
            self.pushVC(vc)
        case 2: goToFlightsDetailsVC()
        case 3:
            let list: [String] = ["All Inclusive", "Half Board", "Breakfast", "Room only"]
            let vc: HotelOptionListViewController = UIStoryboard.controller(.search)
            vc.headerText = "Boarding"
            vc.list = list
            vc.selectIndex = 0
            self.pushVC(vc)
        case 4:
            let list: [String] = ["Standard Room", "Sea View", "Swim-up Room", "Superior Deluxe"]
            let vc: HotelOptionListViewController = UIStoryboard.controller(.search)
            vc.headerText = "Room Type"
            vc.list = list
            vc.selectIndex = 0
            self.pushVC(vc)
        case 5:
            let list: [String] = ["Individual", "Individual", "Individual", "Bus"]
            let vc: HotelOptionListViewController = UIStoryboard.controller(.search)
            vc.headerText = "Transfer"
            vc.list = list
            vc.selectIndex = 0
            self.pushVC(vc)
        default: ()
        }
    }
}

// MARK: - ImageSlideshow
extension HotelViewController: ImageSlideshowDelegate {
    private func setup_slideShow() {
        slideshow.delegate = self
        
        let pathList: [String] = item.hotel?.pathPhotoList ?? []
        slideLabel.text = "1/\(pathList.count)"
        if !pathList.isEmpty {
            var sourceList: [KingfisherSource] = []
            pathList.forEach { (path) in
                guard !path.isEmpty, let url = URL(string: path)  else { return }
                //let source = KingfisherSource(url: url, placeholder: nil, options: nil)
                let ivSize = slideshow.frame.size
                //let ivSize = CGSize(width: Screen.width, height: Screen.width / 16 * 9)
                //let processor = CroppingImageProcessor(size: ivSize)
                //let processor = ResizingImageProcessor(referenceSize: ivSize, mode: .aspectFill) |> CroppingImageProcessor(size: ivSize)
                let processor = DownsamplingImageProcessor(size: ivSize)
                let source = KingfisherSource(url: url,
                                              placeholder: nil,
                                              options: [.processor(processor),
                                                        .scaleFactor(UIScreen.main.scale),
                                                        .cacheOriginalImage])
                sourceList.append(source)
            }
            slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
            slideshow.setImageInputs(sourceList)
        } else { slideLabel.isHidden = true }
        
        slideshow.slideshowInterval = 5
        slideshow.pageIndicator = nil
//        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 12))
//        
//        
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = hexToUIColor("FFFFFF")
//        pageControl.pageIndicatorTintColor = hexToUIColor("FFFFFF", 0.6)
//        slideshow.pageIndicator = pageControl
        //++
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap_slideshow))
        slideshow.addGestureRecognizer(gestureRecognizer)
        //
    }
    @objc func didTap_slideshow() {
        Screen.lockOrientation(.all)
        slideshow.presentFullScreenController(from: self)
    }
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        let pathList: [String] = item.hotel?.pathPhotoList ?? []
        slideLabel.text = "\(page+1)/\(pathList.count)"
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HotelViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(TourTableViewCell.className)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tourList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tourList[indexPath.row]
        let cell: TourTableViewCell = tableView.getCell()
        cell.item = item
        cell.configureCell()
        return cell
    }
}
