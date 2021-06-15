//
//  WalkthroughViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/15.
//

import UIKit

class WalkthroughViewController: UIViewController, PageViewControllerDelegate, UIPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var walkthroughPageViewController: PageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 25
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? PageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.delegate = self
        }
    }
    
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.setValue(true, forKey: "hasViewed")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        updateUI()
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "hasViewed")
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextBtn.setTitle("NEXT", for: .normal)
            case 2:
                nextBtn.setTitle("GET STARTED", for: .normal)
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
}
