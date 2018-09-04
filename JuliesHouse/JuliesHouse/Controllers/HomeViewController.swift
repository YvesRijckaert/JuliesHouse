//
//  HomeViewController.swift
//  JuliesHouse
//
//  Created by Yves Rijckaert on 10/05/2018.
//  Copyright © 2018 Yves Rijckaert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageVC:UIPageViewController?
    var index = 0
    
    var storyboardIds = ["page0", "page1", "page2", "page3"]
    
    @IBAction func instagramButtonClicked(_ sender: Any) {
        let Username =  "julieshouse"
        let appURL = NSURL(string: "instagram://user?username=\(Username)")!
        let webURL = NSURL(string: "https://instagram.com/\(Username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    //protocol implementatie
    //BEFORE -> wat is de vorige?
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if (index > 0 && index < storyboardIds.count) {
            //storyboard aanspreken en juiste scherm tonen
            let viewVC = self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[index-1])
            return viewVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if (index+1 < storyboardIds.count) {
            //storyboard aanspreken en juiste scherm tonen
            let viewVC = self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[index+1])
            return viewVC
        }
        return nil
    }
    
    //initiele scherm / pagina tonen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pageVC = segue.destination as? UIPageViewController
        pageVC?.delegate = self
        pageVC?.dataSource = self
        
        let firstPage = self.storyboard?.instantiateViewController(withIdentifier: storyboardIds[index])
        
        pageVC?.setViewControllers([firstPage!], direction: .forward, animated: true, completion: nil)
        
        //kleur van bolletjes aanpassen
        let stijl = UIPageControl.appearance()
        stijl.currentPageIndicatorTintColor = UIColor(red:0.90, green:0.51, blue:0.47, alpha:1.0)
        stijl.pageIndicatorTintColor = UIColor(red:0.91, green:0.89, blue:0.86, alpha:1.0)

    }
    
    //bolletjes
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return storyboardIds.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return index
    }
    
    //voor de juiste scroll logica
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //huidige viewController, die op dat moment in de array zit
        let viewVC = pageViewController.viewControllers?.first
        
        //nu kan je die restoration identifier bekijken
        let id = viewVC?.restorationIdentifier
        
        //de globale variabele index stel je nu in op deze waarde
        index = storyboardIds.index(of: id!)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
