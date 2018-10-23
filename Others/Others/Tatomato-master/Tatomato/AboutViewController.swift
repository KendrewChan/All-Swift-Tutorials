//
//  AboutViewController.swift
//  Tatomato
//
//  Created by 胡雨阳 on 16/1/11.
//  Copyright © 2016年 胡雨阳. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {

    @IBOutlet weak var github: UIButton!
    @IBOutlet weak var blog: UIButton!
    @IBOutlet weak var linkedIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let translate = CGAffineTransform(translationX: 0.0, y: 500.0)
        github.transform = translate
        blog.transform = translate
        linkedIn.transform = translate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.github.transform = CGAffineTransform.identity
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.blog.transform = CGAffineTransform.identity
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.linkedIn.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func githubButton(_ sender: UIButton) {
        openGithub()
    }
    
    @IBAction func blogButton(_ sender: UIButton) {
        openBlog()
    }
    
    @IBAction func linkedinButton(_ sender: UIButton) {
        openLinkedin()
    }
    
    
    func openGithub() {
        let safariController = SFSafariViewController(url: URL(string: "https://github.com/TAmbition/Tatomato")!)
        present(safariController, animated: true, completion: nil)
    }
    
    func openBlog() {
        let safariController = SFSafariViewController(url: URL(string: "http://tambition.me")!)
        present(safariController, animated: true, completion: nil)
    }
    
    func openLinkedin() {
        let safariController = SFSafariViewController(url: URL(string: "https://www.linkedin.com/in/tambition")!)
        present(safariController, animated: true, completion: nil)
    }
    
}
