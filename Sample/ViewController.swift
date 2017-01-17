//
//  ViewController.swift
//  Sample
//
//  Created by Noor Mustafa on 13/01/17.
//  Copyright © 2017 Noor Mustafa. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController{
    
    let defaults = UserDefaults.standard
    
    //vimeo client ID
    var vimeoClientID : String = ""
    
    //vimeo client Secret
    var vimeoClientSecret : String = ""
    
    //callback URL should be same on the https://developer.vimeo.com/apps/ authentication tab
    var redirectURL : String = "radical://vimeo-callback"
    
    //for supported scopes goto the end of page : https://developer.vimeo.com/api/authentication
    var scope : String = "public%20private"
    
 

    @IBOutlet weak var vimeoSafariButton: UIButton!
    @IBOutlet weak var vimeoWebViewButton: UIButton!
    @IBOutlet weak var vimeoSFSafariButton: UIButton!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        //Obderver to watch when app comes to foreground
        //and calls a custom function
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func vimeoSafariButtonPressed(_ sender: AnyObject) {
        
        //function to make vimeo calls
        self.manualVimeoAuth2(code: "")
    }
  
    //custom function runs when app becomes active
    //appDelegates function "applicationDidBecomeActive" is observed
    func didBecomeActive(){
       
        if let vimeoCode = defaults.string(forKey: "vimeo_code") {
            //if app is initiated by vimeo url
            self.manualVimeoAuth2(code: vimeoCode)
        }else{
            //if started from any other url
        }
        
    }
    
    //function to handle vimeo calls
    func manualVimeoAuth2(code : String){
        
        if (code == ""){
            
            //open the vimeo auth page
            var urlVimeo = "https://api.vimeo.com/oauth/authorize?"
            urlVimeo = urlVimeo.appending("client_id=" + self.vimeoClientID)
            urlVimeo = urlVimeo.appending("&redirect_uri=" + self.redirectURL)
            urlVimeo = urlVimeo.appending("&response_type=code")
            urlVimeo = urlVimeo.appending("&scope=" + self.scope)
            urlVimeo = urlVimeo.appending("&state=VIMEO")
            
            UIApplication.shared.openURL(URL(string: urlVimeo)!)
            
        }else{
            
            let urlAuthVimeo = "https://api.vimeo.com/oauth/access_token"
            let str = self.vimeoClientID + ":" + self.vimeoClientSecret
            let utf8str = str.data(using: String.Encoding.utf8)
            let base64Encoded = utf8str?.base64EncodedString()
            let authHeader = "basic " + base64Encoded!
            let headers: HTTPHeaders = [
                "Authorization": authHeader
            ]
            let parameters: Parameters = [
                "grant_type": "authorization_code",
                "redirect_uri": self.redirectURL,
                "code": code
            ]
            
            Alamofire.request(urlAuthVimeo, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
                debugPrint(response)
                let response = response.result.value! as! NSDictionary
                let accessToken = response.object(forKey: "access_token") as! String
                let userInfoDictionary = response.object(forKey: "user") as! NSDictionary
                var userName = userInfoDictionary.object(forKey: "name") as! String
                
                
                let defaults = UserDefaults.standard
                defaults.set(accessToken, forKey: "access_token")
                defaults.set(userName, forKey: "user_name")
                
                let loggedInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoggedInView") as! LoggedInViewController
                self.navigationController?.pushViewController(loggedInViewController, animated: true)
                
                
            }
            
        }
        
    }

}



