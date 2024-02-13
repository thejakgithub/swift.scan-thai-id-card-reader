//
//  ScanBleViewCtrl.swift
//  Swift.NiOSDemo
//
//  Created by Apirak on 13/4/2565 BE.
//  Copyright © 2565 BE mac. All rights reserved.
//

import UIKit

class scanBleViewCtrl:   UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var processLabel: UILabel!
    

    internal var mNiOS:niosLib!
    internal var detectReaderList:NSMutableArray!
    internal var nEventMsg:Int = -1
    
    weak var delegate:senderDelegate?

    
    init( )
    {
        super.init(nibName: "scanBleViewCtrl", bundle: nil)
        
        self.delegate = nil
        
        detectReaderList = NSMutableArray()
        mNiOS = niosLib.getNiOSLib()
        
        var rect0:CGRect
        rect0 = CGRect(x: 0, y: 0, width: 450, height: 340)
        self.preferredContentSize = rect0.size
        self.modalPresentationStyle = .formSheet
       
        return;
        

         
        //self.modalPresentationStyle = .formSheet
       
          /*
        let targetSize = CGSize(width: view.bounds.width*0.3,
                                height: 340)//UIView.layoutFittingCompressedSize.height*0.5)
        self.preferredContentSize = targetSize
        self.modalPresentationStyle = .formSheet
           */
    }
    
    @objc func updateProgressView(_ notification: Notification) {
        var userInfo: [AnyHashable: Any] = notification.userInfo!
        var NotifyId: String? = (userInfo["NotifyId"] as?  String)
        var MessageType: String? = (userInfo["MessageType"] as?  String)
        let Caller: String? = (userInfo["Caller"] as! String)
        let perc: Int? = (userInfo["Percent"] as? Int)
        let arg: NSObject? = (userInfo["ArgData"] as?  NSObject)
        

        if Caller!.compare("scanReaderListBleNi") == ComparisonResult.orderedSame {
            let readerName:String! = arg as! String
            detectReaderList.add(readerName)
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.OnRDNID_NotifyMessage(_:)),
                                               name: NSNotification.Name(rawValue: NiOS_NotifyMessage), object: nil)
     
        
    }
    
    
    @objc func OnRDNID_NotifyMessage(_ notification: Notification) {
        self.performSelector(onMainThread: #selector(ViewController.updateProgressView(_:)), with: notification, waitUntilDone: false)
        return
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if( animated==true) {
            
            mNiOS.stopReaderListBleNi()
            NotificationCenter.default.removeObserver(self)
            
           
        }
    }
    
    

    //https://swiftdeveloperblog.com/code-examples/create-uitableview-programmatically-example-in-swift/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        
        
      
        
        let _actReaderName: String? = (detectReaderList[indexPath.row]as! String)
        cell.textLabel!.text = _actReaderName

        return cell
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detectReaderList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            
            let _actReaderName: String? = (self.detectReaderList[indexPath.row]as! String)
            
            var obj:EventObj
            obj = EventObj()
            obj.idMsg       = _actReaderName
            obj.nEventMsg   = self.nEventMsg
            self.delegate?.doMessageEvent(obj)

        }
    }
    
    @objc func scanBleReaderThread() {

        var detectReaderListBLE:NSMutableArray!

        detectReaderListBLE = NSMutableArray()
        let nresBLE:Int = Int(exactly: mNiOS.scanReaderListBleNi(detectReaderListBLE,5))!
        
        DispatchQueue.main.async { [self] in
            let nReader:Int = detectReaderListBLE.count
            
//            if (nReader>0) {
//                self.processLabel.text = "Please select a reader."
//            }
//            else {
//                self.processLabel.text = "Reader not found."
//            }

//            self.scanBtn.setTitle("Re-scan",   for: .normal)
        }

        return
    }
    

    func showViewCtrl(parent:UIViewController, nEvent:Int) {
        
        
        nEventMsg = nEvent
        self.delegate = parent as! senderDelegate


        Thread.detachNewThreadSelector(#selector(scanBleReaderThread), toTarget: self, with: nil)
        
        
        parent.present(self, animated:true, completion: {

            return
        })

    }
    
    
 
    
    @IBAction  func onScanReader(_ sender: Any) {
        

        //
        let title:String! = scanBtn.titleLabel?.text

        
        if(title.caseInsensitiveCompare("Stop") == .orderedSame){
            // Both strings are equal with respect to their case.
             let nres:Int = Int(mNiOS.stopReaderListBleNi())

            if (detectReaderList.count>0) {
                 processLabel.text = "Please select a reader."
             }
             else {
                 processLabel.text = "Reader not found."
             }
            

            scanBtn.setTitle("Re-scan", for: .normal)

        }

        if (title.caseInsensitiveCompare("Re-scan") == .orderedSame)
        {

            detectReaderList = NSMutableArray()
            self.tableView.reloadData()
            //
            processLabel.text = "Reader scanning..."
            scanBtn.setTitle("Stop", for: .normal)
            
            Thread.detachNewThreadSelector(Selector(("scanBleReaderThread")), toTarget: self, with: nil)
            
 
        }

    
        return
    }
 
    
    @IBAction func onClose(_ sender: Any) {
        mNiOS.stopReaderListBleNi()
        dismiss(animated: true) {
            
        }
    }
    

}
