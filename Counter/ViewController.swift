//
//  ViewController.swift
//  Counter
//
//  Created by RaghuKV on 12/14/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var tblView: UITableView!
    
    var textCellIdentifier = "cell";
    var counterArray : [NSManagedObject] = [NSManagedObject]()
    
    var snapShot : UIView!
    var sourceIndexPath = NSIndexPath()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CounterCell", bundle: nil)
        tblView.registerNib(nib, forCellReuseIdentifier: textCellIdentifier)
        self.automaticallyAdjustsScrollViewInsets=false
        self.navigationItem.title="Table View"
       
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        fetchSortedCounters()
            
    }
    
    func fetchSortedCounters() {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Counter")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        //3
        let error: NSError?
        
        let fetchedResults =
        try {
            managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]

        }
        
        if let results = fetchedResults {
            counterArray = results
            self.tblView.reloadData()
        } else {
            print("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                var cell : CounterCell = self.tblView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! CounterCell
        
            return 82.0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y + scrollView.frame.size.height
        var height = scrollView.frame.size.height
        
        
        
        if(((offset/height) * 100) < 80) {
            
            var titleEntered = false;
            var initialEntered = false;

            scrollView.panGestureRecognizer.enabled = false
            
            let alertController = UIAlertController(title: "Add", message: "", preferredStyle: .Alert)
            
            let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
                
                scrollView.panGestureRecognizer.enabled = true
                let titleTextField = alertController.textFields![0] 
                let initialCountTextField = alertController.textFields![1] 
                
                
                
                self.addAndSaveCounter(titleTextField.text!, count: initialCountTextField.text!)
                self.fetchSortedCounters()
            }
            addAction.enabled = false
            

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
                scrollView.panGestureRecognizer.enabled = true
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Title"
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    var initialCountField = alertController.textFields?.last
                    addAction.enabled = textField.text != "" && initialCountField!.text != ""

                    
                }
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textFieldTwo) in
                textFieldTwo.placeholder = "Initial Count"
                textFieldTwo.secureTextEntry = false
                textFieldTwo.keyboardType = UIKeyboardType.NumberPad
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textFieldTwo, queue: NSOperationQueue.mainQueue()) { (notification) in
                  //  var initialCountField = alertController.textFields?.last as! UITextField
                   // addAction.enabled = textField.text != "" && initialCountField.text != ""
                    var titleField = alertController.textFields?.first
                    addAction.enabled = textFieldTwo.text != "" && titleField!.text != ""
                }
            }
            
            alertController.addAction(addAction)

            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                //
            })
        }
  }

    
    func addAndSaveCounter(title: String, count: String) {
        
        let index = getMaxIndex() + 1;
        
        print(index)
        //INCREMENT and DECREMENT are defaulted to 1. Changeable in future updates.
        let increment = 1
        let decrement = 1
        
        let countInt = Int(count)
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Counter",
            inManagedObjectContext:
            managedContext)
        
        let counter = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        counter.setValue(title, forKey: "title")
        counter.setValue(countInt, forKey: "count")
        counter.setValue(increment, forKey: "increment")
        counter.setValue(decrement, forKey: "decrement")
        counter.setValue(index, forKey: "index")
        
        
        //4
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }  
        //5
//        self.counterArray.append(counter)
    }
    
    func getMaxIndex() -> Int {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Counter")
        
        fetchRequest.fetchLimit = 1;
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        var error: NSError?
        
        let fetchedResults =
                    managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if(fetchedResults?.count > 0){
            let counterWithMaxIndex = fetchedResults?.last
        
            return counterWithMaxIndex?.valueForKey("index") as! Int
        }else{
            return 0
        }
    }
    
    func refresh(sender:AnyObject)
    {
       print("new entry bro!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counterArray.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : CounterCell = self.tblView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! CounterCell
        
        let object = counterArray[indexPath.row] as NSManagedObject
        
        cell.countNum = object.valueForKey("count") as! Int
        let countString = String(cell.countNum)
        (cell.contentView.viewWithTag(1) as! UILabel).text = (countString as String)
        (cell.contentView.viewWithTag(2) as! UILabel).text = (object.valueForKey("title") as! String)
        
        cell.plusButton.addTarget(self, action: "plusButtonPressed:", forControlEvents: .TouchUpInside)
        cell.minusButton.addTarget(self, action: "minusButtonPressed:", forControlEvents: .TouchUpInside)
        
        let row = indexPath.row
        
        cell.plusButton.tag = row
        cell.minusButton.tag = row
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        cell.addGestureRecognizer(longPress)
        
        //cell.minusButton.description = String("minus" + row)

        return cell
    }
    

    func handleLongPress(longPress: UIGestureRecognizer) -> Void {
        
        
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        context.deleteObject(counterArray[indexPath.row] as NSManagedObject)
        do {
            try context.save()
        } catch _ {
        }

        
        counterArray.removeAtIndex(indexPath.row)
        self.tblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tblView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        }
    
    func plusButtonPressed(sender: UIButton){
        
        
        let row = sender.tag
    
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Counter")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        //3
        let error: NSError?
        
        let fetchedResults =
        (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        
        if error != nil {
            print("An error occurred loading the data")
        } else {
            let result = fetchedResults[row]
            var count = result.valueForKey("count") as! Int
            let increment = result.valueForKey("increment") as! Int
            count += increment
            result.setValue(count, forKey: "count")

            var saveError : NSError? = nil
            
            do {
                try managedContext.save()
                self.counterArray[row] = result
                self.tblView.reloadData()
            } catch let error as NSError {
                saveError = error
                print("Could not update record")
            }
        }
        
        self.tblView.reloadData()
    }
    
    func minusButtonPressed(sender: UIButton){
        
        let row = sender.tag
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Counter")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        //3
        let error: NSError?
        
        let fetchedResults =
        (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        
        if error != nil {
            print("An error occurred loading the data")
        } else {
            let result = fetchedResults[row]
            var count = result.valueForKey("count") as! Int
            let decrement = result.valueForKey("decrement") as! Int
            count -= decrement
            result.setValue(count, forKey: "count")
            
            var saveError : NSError? = nil
            
            do {
                try managedContext.save()
                self.counterArray[row] = result
                //  counterArray[row] = result
                self.tblView.reloadData()
            } catch let error as NSError {
                saveError = error
                print("Could not update record")
            }
        }
        
        self.tblView.reloadData()
    }
}
 