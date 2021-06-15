//
//  AboutTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/15.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Facebook", "Follow Us"]
    var sectionContent = [[
                            (image: "homekit", text: "Rate us on App Store", link: "https://www.apple.com/itunes/charts/paid-apps/"),
                            (image: "speaker.fill", text: "Tell us your feedback", link: "https://www.google.com.tw/")
                        ], [
                            (image: "terminal", text: "Twitter", link: "https://www.twitter.com/appcodamobile"),
                            (image: "face.smiling", text: "Facebook", link: "https://www.facebook.com/appcodamobile"),
                            (image: "rectangle.inset.topright.fill", text: "Instagram", link: "https://www.instagram.com/appcodadotcom")
                        ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.largeContentTitle = "About"
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell",for: indexPath)
        
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(systemName: cellData.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sectionContent[indexPath.section][indexPath.row].link
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self)
            }
        case 1:
            if let url = URL(string: link) {
                let safariController = SFSafariViewController(url: url)
                safariController.modalPresentationStyle = .fullScreen
                
                present(safariController, animated: true, completion: nil)
            }
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            if let destination = segue.destination as? WebViewController {
                let indexPath = tableView.indexPathForSelectedRow
                
                destination.targetURL = sectionContent[indexPath!.section][indexPath!.row].link
            }
        }
    }

}
