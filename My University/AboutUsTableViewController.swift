//
//  AboutUsTableViewController.swift
//  Schedule
//
//  Created by Yura Voevodin on 15.11.17.
//  Copyright © 2017 Yura Voevodin. All rights reserved.
//

import UIKit

class AboutUsTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            switch row {
            case 0:
                if let facebookPageURL = URL(string: "https://www.facebook.com/myuniversityservice") {
                    UIApplication.shared.open(facebookPageURL)
                }
            case 1:
                if let instagramURL = URL(string: "https://www.instagram.com/university.my/") {
                    UIApplication.shared.open(instagramURL)
                }
            case 2:
                if let telegramURL = URL(string: "https://t.me/university_my") {
                    UIApplication.shared.open(telegramURL)
                }
            default:
                break
            }
            
        } else if section == 1 {
            if let websiteURL = URL(string: "https://my-university.com.ua") {
                UIApplication.shared.open(websiteURL)
            }
            
        } else if section == 2 {
            if let appURL = URL(string: "https://apps.apple.com/ua/app/university-schedule/id1440425058") {
                UIApplication.shared.open(appURL)
            }
            
        } else if section == 3 {
            switch row {
            case 0:
                let page = WebPage(url: "https://my-university.com.ua/privacy-policy", title: "Privacy Policy")
                performSegue(withIdentifier: "showWebView", sender: page)
                
            case 1:
                let page = WebPage(url: "https://my-university.com.ua/terms-of-service", title: "Terms of Service")
                performSegue(withIdentifier: "showWebView", sender: page)
                
            default:
                break
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "showWebView":
            let vc = segue.destination as? WebViewController
            vc?.webPage = sender as? WebPage
            
        default:
            break
        }
    }

  // MARK: - Done

  @IBAction func done(_ sender: Any) {
    dismiss(animated: true)
  }
}
