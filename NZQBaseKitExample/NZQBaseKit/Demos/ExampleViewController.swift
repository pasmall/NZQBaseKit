//
//  ExampleViewController.swift
//  NZQBaseKit
//
//  Created by Lyric on 2018/9/19.
//  Copyright © 2018年 Lyric. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        
        NZQNetworkTool.sharedTool.GET("https://cninct.com/SeeVideoData", parameters: ["page":"1","uid":"96883"]) { (response) in
            print("\(String(describing: response))")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
