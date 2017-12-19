//
//  DetailViewController.swift
//  hw9
//
//  Created by Rui Luo on 11/26/17.
//  Copyright © 2017 Rui Luo. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController  {
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var pSelector : UISegmentedControl!
    weak var currentController: UIViewController?
    
    var newsFeeds : [News] =  []
    var curDetail : [Dictionary<String, String>] = []
    var stringPassed = ""
    
    weak var NewsViewController: UIViewController!
    weak var HistoryViewController: UIViewController!
    weak var CurrentViewController: UIViewController!
    @IBAction func selectPage(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0 {
//            UIView.animate(withDuration: 0.5, animations:{
//                self.CurrentViewController.alpha = 1
//                self.HistoryViewController.alpha = 0
//                self.NewsViewController.alpha = 0
//            })
//        }else if sender.selectedSegmentIndex == 1{
//            UIView.animate(withDuration: 0.5, animations:{
//                self.CurrentViewController.alpha = 0
//                self.HistoryViewController.alpha = 1
//                self.NewsViewController.alpha = 0
//            })
//        }else {
//            UIView.animate(withDuration: 0.5, animations:{
//                self.CurrentViewController.alpha = 0
//                self.HistoryViewController.alpha = 0
//                self.NewsViewController.alpha = 1
//            })
//        }
        if pSelector.selectedSegmentIndex == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
            newViewController.str = self.stringPassed

            newViewController.curDetail = self.curDetail
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentController!, toViewController: newViewController)
            self.currentController = newViewController
        } else if pSelector.selectedSegmentIndex == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            newViewController.stringPassed = self.stringPassed
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentController!, toViewController: newViewController)
            self.currentController = newViewController
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            print(self.newsFeeds)
            newViewController.newsFeeds = self.newsFeeds
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentController!, toViewController: newViewController)
            self.currentController = newViewController
        }
    }
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
       completion: { finished in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMove(toParentViewController: self)
        })
    }
    
    
    override func viewDidLoad() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let otherVC = storyBoard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        otherVC.str = self.stringPassed
        otherVC.curDetail = self.curDetail
        otherVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(otherVC)
        
        self.addSubview(subView: otherVC.view, toView: self.containerView)
        self.currentController = otherVC
        
        super.viewDidLoad()
        self.navigationItem.title = stringPassed
        print("Detail ViewController load")
        
        
        
        
        
        
        
//        self.navigationItem.title = stringPassed
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        setupView()
    }
    
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func back(sender: UIBarButtonItem) {
        dismiss(animated: true, completion:nil)
        _ = navigationController?.popViewController(animated: true)
    }

//    //Mark: view method
//
//
//
    private func setupView() {
        setupSegmentedController()
//        UIView.animate(withDuration: 0, animations:{
//            self.CurrentViewController.alpha = 1
//            self.HistoryViewController.alpha = 0
//            self.NewsViewController.alpha = 0
//        })
    }
//
    private func setupSegmentedController() {
        pSelector.removeAllSegments()
        pSelector.insertSegment(withTitle: "Current", at: 0, animated: false)
        pSelector.insertSegment(withTitle: "History", at: 1, animated: false)
        pSelector.insertSegment(withTitle: "news", at: 2, animated: false)
        pSelector.selectedSegmentIndex = 0
    }
}
