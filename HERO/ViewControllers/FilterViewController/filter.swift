//
//  filter.swift
//  HERO
//
//  Created by Clifford Yin on 3/23/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import ChameleonFramework

/* This code manages all the possible filters for the main collectionView */
class filter: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var filters: [String] = ["Animal Welfare", "Arts and Culture", "Children", "Community","Disaster Relief", "Economic Assistance","Education", "Environment", "Health", "Poverty Alleviation","STEM", "Social Action"]
    
    // MARK: Properties
    
    var colorArray = ColorSchemeOf(colorSchemeType: ColorScheme.complementary, color: FlatYellow(), isFlatScheme: true)
    var darkOrange: UIColor!
    var goldOrange: UIColor!
    var yellowOrange: UIColor!
    var purple: UIColor!
    var darkPurple: UIColor!
    var tanColor = UIColor.init(red: 224/255, green: 211/255, blue: 153/255, alpha: 1.0)
    var filterNamed = "none"
    let cellSpacingHeight: CGFloat = 5
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        //Chameleon graphics
        self.darkOrange = colorArray[0]
        self.goldOrange = colorArray[1]
        self.yellowOrange = colorArray[2]
        self.purple = colorArray[3]
        self.darkPurple = colorArray[4]
        let colors3:[UIColor] = [
            self.darkOrange,
            UIColor.flatWhite()
        ]
        view.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: view.frame, colors: colors3)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filters.count
    }
    
    // Displays the options for filters
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let filt = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! filterCell
        let choosefilt = filters[indexPath.row]
        let colors:[UIColor] = [
            self.tanColor,
            UIColor.flatWhite()
        ]
        let colors2:[UIColor] = [
            self.darkOrange,
            UIColor.flatWhite()
        ]

        filt.contentView.backgroundColor = GradientColor(gradientStyle: .radial, frame: filt.frame, colors: colors2)
        filt.configure(categorized: choosefilt)
        filt.imageName.textColor = darkPurple
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 20, width: self.view.frame.size.width - 20, height: 180))
        let backColor = GradientColor(gradientStyle: .radial, frame: whiteRoundedView.frame, colors: colors)
        whiteRoundedView.layer.backgroundColor = backColor.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOpacity = 0.4
        
        filt.contentView.addSubview(whiteRoundedView)
        filt.contentView.sendSubview(toBack: whiteRoundedView)
       
        return filt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200 // Choose your custom row height
    }
    
    
    // When selected, redirect back to the home page with this active filer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! filterCell
        self.filterNamed = cell.imageName.text!

        let filterNaming = self.filterNamed
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! ViewController
        nextViewController.filterName = self.filterNamed
        self.present(nextViewController, animated:true, completion:nil)
        
    }

}
