//
//  ViewController.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/12/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    //UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bottomModalView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //Class porperties
    private var disposeBag = DisposeBag()
    private var jobsViewModel=[JobsViewModel]()//viewModel
    private var refreshControl = UIRefreshControl()
    private let TABLEVIEW_HEIGHT = 285
    private let CELL_ID = "Cell"
    private let MODALVIEW_STORYBOARD_ID = "ModallyVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        
    }
    
    //Refresh on pulling down the tableview
    @objc func refresh(sender:AnyObject) {
        fetchData()
        refreshControl.endRefreshing()
        
    }

    //Load data from api
    fileprivate func fetchData(){
        view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        var jobsArray = [Dates]()
        let jobsObservable = Network.shared.retrieveJobDetails()
        
        jobsObservable.subscribe(onNext:{ [weak self] response in
            
            //Append items to initialize the View Model
            for items in response.data[Utils.getCurrentDate()] ?? [] {
                if ((items.client?.photos.count ?? 0 > 0)){
                    jobsArray.append(items)
                }
            }
            //Initializin the View Model
            self?.jobsViewModel =  jobsArray.map({return JobsViewModel(mainData: $0)})
            
            DispatchQueue.main.sync(execute: {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
            })
            
            
            },onError:{(error) in
                //Error Handling
                DispatchQueue.main.sync(execute: {
                    Utils.handleWebserviceErrors(errorCode: Constants.STATUS_CODE_UNAUTHORIZED, activityIndicator: self.activityIndicator, presentVC: self,alertActionMesasage:Constants.OK_ACTION)
                    self.view.isUserInteractionEnabled = true
                })
                
        },onCompleted:{
            //calls upon recieving all the objects
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.filterView.isHidden = false
                self.bottomModalView.isHidden = false
            }
            
        },onDisposed:{
            
        }).disposed(by: disposeBag)
        
        
    }

    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
            //Show modal on Swipe UP
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier:MODALVIEW_STORYBOARD_ID) as! ModallyViewController
            
            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.transitioningDelegate = self
            self.present(pvc, animated: true, completion: nil)
       
    }
    private func setupUI(){
        //Configure UI elements to display
        self.headerLabel.text = "\(Date().string(format: "EEEE d")) \(Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date())-1])"
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.tableView.tableFooterView = UIView()
        self.filterView.layer.cornerRadius = 20
        self.filterView.layer.shadowColor = UIColor.gray.cgColor
        self.self.filterView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.self.filterView.layer.shadowOpacity = 0.5
        self.self.filterView.layer.shadowRadius = 1.0
        self.filterView.isHidden = true
        self.bottomModalView.isHidden = true
        signupBtn.layer.cornerRadius = 5
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.black.cgColor
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.bottomModalView.addGestureRecognizer(swipeUp)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
       
        
    }
}

/*  Extentions  */
extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobsViewModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        if self.jobsViewModel.count > 0 {
            JobsTableViewCell.populateTable(cell, self.jobsViewModel[indexPath.row], tableView, indexPath)
        }
        
        return cell
    }
    
    
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TABLEVIEW_HEIGHT)
        
    }
    
}
extension ViewController: UIViewControllerTransitioningDelegate {
    

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)

    }
    
}

