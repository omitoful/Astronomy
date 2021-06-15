//
//  PageViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/15.
//

import UIKit

// 在使用滑動時也可以更新指示
protocol PageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageViewController.imagefile = pageImages[index]
            pageViewController.heading = pageHeadings[index]
            pageViewController.subheading = pageSubHeadings[index]
            pageViewController.index = index
            
            return pageViewController
        }
        
        return nil
    }
    
    weak var walkthroughDelegate: PageViewControllerDelegate?
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
    
    var pageHeadings = ["CREATE YOUR OWN PICTURE", "SHOW THE LOCATION", "DISCOVER GREAT PICTURE"]
    var pageSubHeadings = ["1st", "2nd", "3rd"]
    var pageImages = ["love", "happy", "sad"]
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}
