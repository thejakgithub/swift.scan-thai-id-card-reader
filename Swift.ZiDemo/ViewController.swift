//
//  ViewController.swift
//  Swift.NiOSDemo
//
//  Created by R&D Computer System Co., Ltd.
//  Copyright 2020 R&D Computer System Co., Ltd. All rights reserved.
//

/*
 The program must add the "NSBluetoothAlwaysUsageDescription" key into "Info.plist file.
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Our app uses bluetooth to find, connect and transfer data between different devices</string>
 */
import UIKit


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let VL_OPENLIB_MODE=0
let FLVL_OPENLIB_MODE=1

let EVT_WRITE_BOUND    =   0
let EVT_BIND_READER    =   1


#if BUILD_OPT_CONNECT_BUL
      
//let AppVersionTitle =  "NiBTU Sample 4.09A"
let ACTIVE_OPENLIB_MODE = FLVL_OPENLIB_MODE;
let LIC_FILE = "lic/rdnidlib.dlt"

#elseif BUILD_OPT_CONNECT_BLE

//let AppVersionTitle  = "NiBLE Sample 4.09A"
let ACTIVE_OPENLIB_MODE = VL_OPENLIB_MODE;
let LIC_FILE  = ""

#endif



class ViewController: UIViewController ,UITextFieldDelegate ,senderDelegate  {

    @IBOutlet weak var cardState: UISwitch!
    
    @IBOutlet weak var hardwareState: UISwitch!
    @IBOutlet weak var mNIDPhotoImgv: UIImageView!
 
    @IBOutlet weak var mAppVersion: UILabel!
    @IBOutlet weak var mProgressReadTextView: UITextView!
    var mNiOS : niosLib?
    fileprivate var mZI: ZI?
    
    
    @IBOutlet weak var readerDetailsBtn: UIButton!
 
    @IBOutlet weak var updateLICBtn: UIButton!
    
    @IBOutlet weak var disTextView: UITextView!
    
    @IBOutlet weak var disconectReaderBtn: UIButton!
    @IBOutlet weak var connectReaderBleLtUsbBtBtn: UIButton!

    @IBOutlet weak var readCardBtn: UIButton!
    
    @IBOutlet weak var libraryInfoBtn: UIButton!
    
    @IBOutlet weak var licenseInfoBtn: UIButton!
    
    @IBOutlet weak var mLogText: UITextView!
    
    var startBtnReadCardTime : CFTimeInterval!
    

    override func viewDidLoad() {
        super.viewDidLoad()


        
        disTextView.text = "";

      
        var appName:String = "";
        var appVers:String = "";

        appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "";
        appVers = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "";

        mAppVersion.text = String(format: "%@ %@", appName , appVers);

        
        // create nid object for interfacing with smartcard reader
        mNiOS =  niosLib.getNiOSLib()
        mZI = ZI()
     
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.OnRDNID_NotifyMessage(_:)),
                                               name: NSNotification.Name(rawValue: NiOS_NotifyMessage), object: nil)
 
        
        cardState.isEnabled = false;
        hardwareState.isEnabled=false;
      
 
    
        connectReaderBleLtUsbBtBtn.isEnabled=true;
        connectReaderBleLtUsbBtBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        connectReaderBleLtUsbBtBtn.titleLabel?.lineBreakMode = .byClipping //<-- MAGIC LINE
        connectReaderBleLtUsbBtBtn.titleLabel?.numberOfLines = 1
        
        disconectReaderBtn.isEnabled = false;
        disconectReaderBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        disconectReaderBtn.titleLabel?.lineBreakMode = .byClipping //<-- MAGIC LINE
        disconectReaderBtn.titleLabel?.numberOfLines = 1
        
        readCardBtn.isEnabled = false;
        libraryInfoBtn.isEnabled = true;
        //
        readerDetailsBtn.isEnabled = true;
        licenseInfoBtn.isEnabled = true;
        updateLICBtn.isEnabled = false;
        
      
        
#if BUILD_OPT_CONNECT_BUL
        
//        print("eiei1")
        
        connectReaderBleLtUsbBtBtn.setTitle("Connect BUL Reader", for: .normal)
        updateLICBtn.isEnabled = true
        
#elseif BUILD_OPT_CONNECT_BLE
//        print("eiei2")
        connectReaderBleLtUsbBtBtn.setTitle("Connect BLE Reader", for: .normal)
        updateLICBtn.isEnabled = false
#else

        #error("Not define compile option" )
//        print("eiei3")
        exit(-1);
#endif
        
//        
//#if BUILD_OPT_CONNECT_BUL
//        
//        print("b1")
//        //define Reader Type
//        let readerList :NSMutableArray=NSMutableArray();
//        
//        var res :Int32?;
//       res =  mNiOS?.getReaderListNi(readerList);
//       if res <= 0 {
//           var msg :String;
//           msg = String(format: "function getReaderListNi (error code: %d)" ,
//                       res! );
//           disTextView.text = msg;
//           
//           //mbConnectReader = true;
//          // ConectReaderBtn.isEnabled = true
//          // DisconectReaderBtn.isEnabled = false
//         
//           return ;
//       }
//
//        mActiveReaderName = readerList[0] as! String;
//        let mactiveReaderNameMut = NSMutableString(string: mActiveReaderName)
//        
//        var obj:EventObj
//        obj = EventObj()
//        obj.idMsg       = mActiveReaderName
//        obj.nEventMsg   = EVT_BIND_READER
//        doMessageEvent(obj)
//        
//      
//
//#elseif BUILD_OPT_CONNECT_BLE
//        
//        print("b1")
//      
//        var scan: scanBleViewCtrl!
//        scan = scanBleViewCtrl()
//        scan.showViewCtrl(parent: self,nEvent: EVT_BIND_READER)
//                
//#else
//        print("b2")
//        #error("Not define compile option" )
//        exit(-1);
//#endif
//        print("b3")
//        var res: Int32?;
//        
//        startBtnReadCardTime = CACurrentMediaTime() ;
//        
//        res = mNiOS?.connectCardNi()
//        if res != 0 {
//    
//            let msg:String;
//             msg = String(format: "function connectCardNi (error code: %d (0x%X) )" , res! ,res!);
//     
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//                DispatchQueue.main.async {
//                     self.disTextView.text  = msg
//                }
//            }
//            
//         
//            return
//        }
//        let nsData: NSMutableString = NSMutableString()
//        
//        res = mNiOS?.getATextNi(nsData)
//   //     res = mNiOS?.getNIDTextNi(nsData)
//        
//        var _t_getNIDTextNi:CFTimeInterval = CACurrentMediaTime() - startBtnReadCardTime
//
//        if res != 0 {
//     
//            let msg:String;
//            msg = String(format: "function getNIDTextNi (error code: %d)" , res! );
//            
//            
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//                DispatchQueue.main.async {
//                    self.disTextView.text  = msg
//                }
//            }
//            
//    
//            res = mNiOS?.disconnectCardNi()
//            return
//        }
//        
//         //----------------
//         let dataPhoto = NSMutableData.init();
//         res = mNiOS?.getNIDPhotoNi(dataPhoto)
//         if res != 0 {
//             let msg:String;
//             msg = String(format: "function getNIDPhotoNi (error code %d)" , res! );
//             
//             DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//                 DispatchQueue.main.async {
//                     self.disTextView.text  = msg
//                 }
//             }
//
//             res = mNiOS?.disconnectCardNi()
//             return
//         }
//         
//         let img: UIImage = UIImage(data: dataPhoto as Data)!
//         mNIDPhotoImgv.image = img
//
//        var _t_getNIDPhotoNi:CFTimeInterval = CACurrentMediaTime() - self.startBtnReadCardTime;
//
//        
//        res = mNiOS?.disconnectCardNi()
//        
//        //ZILib
//        var strTextData:String;
//        strTextData = String(format: "%@" ,nsData  );
//        let arryTextData = strTextData.split{$0 == "#"}.map(String.init)
//        
//                
//        //IKey: NID[11] [12] [3] [4] [5] ,Verification Key, NID number digit 11,12,3,4,5
//        let strPID:String;
//        strPID = String(format: "%@" , arryTextData[0] );
//        var aryPID = [Character](strPID);
//        var strKey:String = ""
//        strKey = String(aryPID[10])+String(aryPID[11])+String(aryPID[2])+String(aryPID[3])+String(aryPID[4]);
//            
//        
//        let  myNSKey = strKey as NSString
//        let nsZiData = NSMutableString.init();
//        var nsMutKey: NSMutableString
//        nsMutKey =  myNSKey.mutableCopy() as! NSMutableString;
//
//        var _t_startSTextZI:CFTimeInterval = CACurrentMediaTime() ;
//
//        
//        
//       res = mZI?.getSTextZI(mNiOS , nsMutKey, nsZiData);
//    
//        if res != 0 {
//            
//            let msg:String;
//            msg = String(format: "function getSTextZI (error code %d)" , res! );
//            
//            
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//                DispatchQueue.main.async {
//                    self.disTextView.text  = msg
//                }
//            }
//            
//
//            return
//        }
//    
//        var _t_getSTextZI:CFTimeInterval = CACurrentMediaTime() - _t_startSTextZI
//
//        var strZIData:String;
//        strZIData = String(format: "%@" ,nsZiData  );
//        let arryZIData = strZIData.split{$0 == "#"}.map(String.init)
//        
//
// 
//        if res != 0 {
//         
//            let msg:String;
//            msg = String(format: "disconnectCardNi (error code: %d)" , res! );
//      
//            
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//                DispatchQueue.main.async {
//                    self.disTextView.text  = msg
//                }
//            }
//            
// 
//            return
//        }
//
// 
//        
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
//            DispatchQueue.main.async {
//
//                let disText:String;
//                disText = String(format: "NID Number: %@\nFirst Name: %@\nLast Name: %@\nBirth Date: %@\nLaser ID: %@\nChip ID: %@\nBP1 Number: %@" , arryTextData[0], arryTextData[2],arryTextData[3],arryTextData[13],arryZIData[0],arryZIData[1],arryZIData[2] );
//                
//                let msg = String(format: "Read Text: %.2f s\nRead Text + Photo: %.2f s\nRead SText: %.2f s\nRead Text + Photo + SText: %.2f s\n\n%@",_t_getNIDTextNi,
//                _t_getNIDPhotoNi,
//                _t_getSTextZI,
//                _t_getNIDPhotoNi+_t_getSTextZI,
//                disText )
//                
//                print("Back id card \(arryZIData[0])")
//                
//                
//                self.disTextView.text =  msg;
//
//            }
//        }

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func OnRDNID_NotifyMessage(_ notification: Notification) {
        self.performSelector(onMainThread: #selector(ViewController.updateProgressView(_:)), with: notification, waitUntilDone: false)
        return
    }

    @objc func updateProgressView(_ notification: Notification) {
        var userInfo: [AnyHashable: Any] = notification.userInfo!
        var NotifyId: String? = (userInfo["NotifyId"] as? String)
        var MessageType: String? = (userInfo["MessageType"] as? String)
        let Caller: String? = (userInfo["Caller"] as! String)
        let perc: Int? = (userInfo["Percent"] as? Int)
        let arg: NSObject? = (userInfo["ArgData"] as? NSObject)
  
        if ( Caller!.caseInsensitiveCompare("getNIDTextNi") == ComparisonResult.orderedSame ||
             Caller!.caseInsensitiveCompare("getATextNi") == ComparisonResult.orderedSame )
        {
 
            let s = String(format: "function %@: %d %%",Caller!,  perc! )
            mProgressReadTextView!.text = s;
            
            if perc! >= 100 {
                let nsData =  arg as! String
                let listItems: [String] = nsData.components(separatedBy: "#")
                var disText: String ;
                disText = "";
                for i in 0 ..< listItems.count {
                    var s: String;
                    s = listItems[i] as! String;
                    disText = disText + s + "\n"
                }
                disTextView.text = disText;
            }
                
        }
        if( Caller!.compare("getNIDPhotoNi") == ComparisonResult.orderedSame )
        {
            let s = String(format: "function getNIDPhotoNi: %d %%",  perc! )
            mProgressReadTextView!.text = s;
            if perc! >= 100 {
                let dataPhoto: NSMutableData = arg as! NSMutableData
                let img: UIImage = UIImage(data: dataPhoto as Data)!
                mNIDPhotoImgv.image = img
            }
        }
        
        if( Caller!.compare("CardStatus") == ComparisonResult.orderedSame )
        {
 
            let Status: Int? = (userInfo["Status"] as? Int)
            
            if let _Status = Status {
                if(_Status==0) {
                    cardState!.isOn = false;
                }
                else {
                    cardState!.isOn = true;
                }
            }
            
        }
        
        if( Caller!.compare("ReaderStatus") == ComparisonResult.orderedSame )
        {
            let Status: Int? = (userInfo["Status"] as? Int)
            
            if let _Status = Status {
                if(_Status==0) {
                    hardwareState!.isOn = false;
                }
                else {
                    hardwareState!.isOn = true;
                }
            }
            
        }
    }
    
    func ResetProgressbar()
    {
        mProgressReadTextView!.text = "";
        let img: UIImage? = UIImage(named: "ICON-Small-50.png")
        mNIDPhotoImgv.image = img
    }
    
    
    func getLICPath(path:inout String ) -> Int {
        var type: Int = -1;
        
        type = ACTIVE_OPENLIB_MODE

        switch type
        {
            case VL_OPENLIB_MODE:
                path = "\(LIC_FILE)"
                break;
            case FLVL_OPENLIB_MODE:
                var libpath :[ String];
                libpath = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);

                path = libpath[0]+"/"+LIC_FILE;
                break;
            default:
                break
        }
        return type;
    }


    
    @IBAction func onDisconnectBtn(_ sender: AnyObject) {
        var res:Int32?;
        
  
        ResetProgressbar()
        disTextView.text = "Smart card reader disconnected"

        res = mNiOS?.deselectReaderNi()
        if res != 0 {
            var msg :String;
            msg = String(format: "function deselectReaderNi (error code: %d)" , res! );
            disTextView.text = msg
        }

        res =  mNiOS?.closeLibNi()
        if res != 0 {
            var msg :String;
            msg = String(format: "function closeLibNi (error code: %d)" , res! );
            disTextView.text = msg
        }
        
      
      
        connectReaderBleLtUsbBtBtn.isEnabled=true;
        disconectReaderBtn.isEnabled = false;
    
          //
        readCardBtn.isEnabled = false;
        libraryInfoBtn.isEnabled = true
        //
        //readerDetailsBtn.isEnabled = false;
        licenseInfoBtn.isEnabled = true;
        //updateLICBtn.isEnabled = false;
        
    }
    
    
    // The output below is limited by 1 KB.
    // Please Sign Up (Free!) to remove this limitation.
    
    @objc func ReadNIDDataThread() {
      
        var res: Int32?;
        
        startBtnReadCardTime = CACurrentMediaTime() ;
        
        res = mNiOS?.connectCardNi()

        if res != 0 {
    
            let msg:String;
             msg = String(format: "function connectCardNi (error code: %d (0x%X) )" , res! ,res!);
     
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                DispatchQueue.main.async {
                     self.disTextView.text  = msg
                }
            }
            
         
            return
        }
        let nsData: NSMutableString = NSMutableString()
        
        res = mNiOS?.getATextNi(nsData)
   //     res = mNiOS?.getNIDTextNi(nsData)
        
        var _t_getNIDTextNi:CFTimeInterval = CACurrentMediaTime() - startBtnReadCardTime

        if res != 0 {
        
            
            
            let msg:String;
            msg = String(format: "function getNIDTextNi (error code: %d)" , res! );
            
     
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                DispatchQueue.main.async {
                    self.disTextView.text  = msg
                }
            }
            
    
            res = mNiOS?.disconnectCardNi()
            return
        }
        
         //----------------
         let dataPhoto = NSMutableData.init();
         res = mNiOS?.getNIDPhotoNi(dataPhoto)
         if res != 0 {
             let msg:String;
             msg = String(format: "function getNIDPhotoNi (error code %d)" , res! );
             
             DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                 DispatchQueue.main.async {
                     self.disTextView.text  = msg
                 }
             }

             res = mNiOS?.disconnectCardNi()
             return
         }
         
         let img: UIImage = UIImage(data: dataPhoto as Data)!
         mNIDPhotoImgv.image = img

        var _t_getNIDPhotoNi:CFTimeInterval = CACurrentMediaTime() - self.startBtnReadCardTime;

        
        res = mNiOS?.disconnectCardNi()
        
        //ZILib
        var strTextData:String;
        strTextData = String(format: "%@" ,nsData  );
        let arryTextData = strTextData.split{$0 == "#"}.map(String.init)
        
                
        //IKey: NID[11] [12] [3] [4] [5] ,Verification Key, NID number digit 11,12,3,4,5
        let strPID:String;
        strPID = String(format: "%@" , arryTextData[0] );
        var aryPID = [Character](strPID);
        var strKey:String = ""
        strKey = String(aryPID[10])+String(aryPID[11])+String(aryPID[2])+String(aryPID[3])+String(aryPID[4]);
            
        
        let  myNSKey = strKey as NSString
        let nsZiData = NSMutableString.init();
        var nsMutKey: NSMutableString
        nsMutKey =  myNSKey.mutableCopy() as! NSMutableString;

        var _t_startSTextZI:CFTimeInterval = CACurrentMediaTime() ;

        
        
       res = mZI?.getSTextZI(mNiOS , nsMutKey, nsZiData);
    
        if res != 0 {
            
            let msg:String;
            msg = String(format: "function getSTextZI (error code %d)" , res! );
            
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                DispatchQueue.main.async {
                    self.disTextView.text  = msg
                }
            }
            

            return
        }
    
        var _t_getSTextZI:CFTimeInterval = CACurrentMediaTime() - _t_startSTextZI

        var strZIData:String;
        strZIData = String(format: "%@" ,nsZiData  );
        let arryZIData = strZIData.split{$0 == "#"}.map(String.init)
        

 
        if res != 0 {
         
            let msg:String;
            msg = String(format: "disconnectCardNi (error code: %d)" , res! );
      
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                DispatchQueue.main.async {
                    self.disTextView.text  = msg
                }
            }
            
 
            return
        }

 
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            DispatchQueue.main.async {

                let disText:String;
                disText = String(format: "NID Number: %@\nFirst Name: %@\nLast Name: %@\nBirth Date: %@\nLaser ID: %@\nChip ID: %@\nBP1 Number: %@" , arryTextData[0], arryTextData[2],arryTextData[3],arryTextData[13],arryZIData[0],arryZIData[1],arryZIData[2] );
                
                let msg = String(format: "Read Text: %.2f s\nRead Text + Photo: %.2f s\nRead SText: %.2f s\nRead Text + Photo + SText: %.2f s\n\n%@",_t_getNIDTextNi,
                _t_getNIDPhotoNi,
                _t_getSTextZI,
                _t_getNIDPhotoNi+_t_getSTextZI,
                disText )
                
                print("Back id card \(arryZIData[0])")
                
                self.disTextView.text =  msg;

            }
        }

    }
    
    

    @IBAction func onReadCardBtn(_ sender: AnyObject) {

        let st: Int32 = (mNiOS?.getCardStatusNi())!
        if Int(st) != 1 { 
            self.disTextView.text  = "getCardStatusNi (error code: \(st))"
            return
        }

        ResetProgressbar();
        disTextView.text = "Reading...";
        
        startBtnReadCardTime = CACurrentMediaTime();

        Thread.detachNewThreadSelector(#selector(ViewController.ReadNIDDataThread), toTarget: self, with: nil)
        
        return ;
        
    }
    
    
    @IBAction func onLibraryInfoBtn(_ sender: AnyObject) {

        ResetProgressbar()

        var LibVerMsg:String;
        var msg:String;
        
        var res: Int32?;
        
        //NIOSLib
        let ver = NSMutableString.init();
        res = mNiOS?.getSoftwareInfoNi(ver)
        if res != 0 {
            LibVerMsg = String(format: "function getSoftwareInfoNi (error code: %d)" , res! );
        }
        else
        {
            LibVerMsg = String(format: "%@" ,ver);
       }

        //ZILib
        var ZiLibVerMsg:String;
        let Ziver = NSMutableString.init();
        res = mZI?.getSoftwareInfoZI( mNiOS, Ziver);
        if res != 0 {
            ZiLibVerMsg = String(format: "function getSoftwareInfoZI (error code %d)" , res! );
        }
        else
        {
            ZiLibVerMsg = String(format: "%@" ,Ziver);
        }


        let  FTlibBuffer = UnsafeMutablePointer<Int8>.allocate(capacity: 200)
        FTlibBuffer.initialize(to: 0)
        FtGetLibVersion( FTlibBuffer);
        let strFTlib = String(validatingUTF8: UnsafePointer<CChar>(FTlibBuffer))
        
        
        msg = String(format: "R&D Library: %@\n\nFeitian Library: %@\n\nZi Library: %@\n" ,LibVerMsg, strFTlib! ,ZiLibVerMsg);
        disTextView.text = msg
        
    }
    
    
    @IBAction func onExitBtn(_ sender: AnyObject) {
        //show confirmation message to user

        exit(0)
    
    }
    
    
    @IBAction func onLicenseInfoBtn(_ sender: AnyObject) {
        
        
        var res : Int32?;
        var paths :[ String];
        let Lic = NSMutableString.init();

        ResetProgressbar()
        
        var libpath="";
        var openModeLib : Int;
        openModeLib = getLICPath(path: &libpath );
        var LICpath  : NSMutableString
        
        var msg :String;
        
        if( connectReaderBleLtUsbBtBtn.isEnabled==true) {
            LICpath =  libpath.mutableCopy() as! NSMutableString;
            res =  mNiOS?.openLibNi(LICpath)
            if(res==0) {
                    
                res = mNiOS?.getLicenseInfoNi(Lic);

                mNiOS?.closeLibNi();
                
               
                msg = String(format: "License info: %@ \n " ,Lic );
           
            
            }
            else
            {
                
                msg = String(format: "function openLibNi  (error code: %d)" ,res! );
                
            }
            
            connectReaderBleLtUsbBtBtn.isEnabled=true;
            disconectReaderBtn.isEnabled = false;
            //
            readCardBtn.isEnabled = false;
            libraryInfoBtn.isEnabled = true
            licenseInfoBtn.isEnabled = true;
  
            
            
        }
        else
        {
            res = mNiOS?.getLicenseInfoNi(Lic);
            msg = String(format: "License info: %@ \n " ,Lic );
            
        }
        

        disTextView.text = msg

    }

    
    @IBAction func onUpdateLICBtn(_ sender: AnyObject) {
    
#if BUILD_OPT_CONNECT_BUL

        var res : Int32?;
        var paths :[ String];


        var msg :String;
        var libpath="";
        var openModeLib : Int;
        openModeLib = getLICPath(path: &libpath );

        if VL_OPENLIB_MODE==openModeLib
        {
            msg = String("VL license");
            disTextView.text = msg
            return ;
        }
        
        var LICpath  : NSMutableString
        LICpath =  libpath.mutableCopy() as! NSMutableString;
        res =  mNiOS?.openLibNi(LICpath)
        res =  mNiOS?.updateLicenseFileNi()
        
        switch(res)
        {
            case 0,1,2, 3:
                msg = String(format:"The new license file has been successfully updated.(%d)",res!  );
                 
            case 100, 101,102,103:
                msg = String(format:"The lastest license file has already been installed.(%d)",res!  );
               
            default:
                msg = String(format:"function updateLicenseFileNi (error code: %d)" ,res!);
        }
        
        disTextView.text = msg
        mNiOS?.closeLibNi();
        
        
        connectReaderBleLtUsbBtBtn.isEnabled=true;
        disconectReaderBtn.isEnabled = false;
        //
        readCardBtn.isEnabled = false;
        libraryInfoBtn.isEnabled = true
        //
        //readerDetailsBtn.isEnabled = false;
        licenseInfoBtn.isEnabled = true;
        //updateLICBtn.isEnabled = false;
        
#endif
        
        return ;
    }
    
    
    func getReaderInfo( nsData: NSMutableString ) -> Int32 {
         
        let res : Int32 = (mNiOS?.getReaderInfoNi(nsData))!
        if res != 0 {
            nsData.append("---#--#-")
        }
        return res;
    }
    

    func _getFTDevVer(hContext: UInt32, firmware:inout String , hardware:inout String ) -> Int {
        
        var iRet: Int
        firmware = "";
        hardware = "";
        
        let firmwareRevision = UnsafeMutablePointer<Int8>.allocate(capacity: 100)
        firmwareRevision.initialize(to: 0)
        
        let hardwareRevision = UnsafeMutablePointer<Int8>.allocate(capacity: 100)
        hardwareRevision.initialize(to: 0)
        
        
        iRet = Int(FtGetDevVer( SCARDCONTEXT((hContext)), firmwareRevision, hardwareRevision))
        if(iRet==0)
        {
            firmware = String(validatingUTF8: UnsafePointer<CChar>(firmwareRevision))!
            hardware = String(validatingUTF8: UnsafePointer<CChar>(hardwareRevision))!
            
        }
        
        return iRet
    }
    
 
    func _getFTSerialNum( hContext:UInt32 , SN:inout String  ) -> Int {
        var iRet: Int
        SN = "";

        
        let  buf = UnsafeMutablePointer<Int8>.allocate(capacity: 200)
        buf.initialize(to: 0)
        
        let  n100 = UnsafeMutablePointer<UInt32>.allocate(capacity: 200)
        n100.initialize(to: 0)

        iRet = Int( FtGetSerialNum(SCARDHANDLE(hContext),n100, buf ) );
        if( iRet == 0)
        {
      
#if BUILD_OPT_CONNECT_BUL
            var xlen : Int;
            let xSN = String(cString: buf );
            xlen = Int(n100[0]);
            let endIndex = xSN.index(xSN.startIndex, offsetBy: xlen)
            SN = String(xSN[xSN.startIndex..<endIndex])
            
#elseif BUILD_OPT_CONNECT_BLE
            SN =  bin2hex(bi: buf, bilen: Int(n100[0] ) ,spc:"");
#endif
        
        }
        return iRet
    }
    
    
    
    func bin2hex(bi: UnsafePointer<Int8>?, bilen: Int , spc:String ) ->  String {
        let hex : [Character] =
            [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" ]
        
        var stringToReturn = ""
        
    
        for i in 0..<bilen {
            let uc = bi![i]
            let c = UInt8( truncatingIfNeeded: uc )
            stringToReturn.append(hex[Int(c) >> 4])
            
            stringToReturn.append(  hex[Int(c) & 0xf] )
            stringToReturn.append(spc)
            
        }
        
        return stringToReturn
    }
    
    func bin2hex(bi: UnsafePointer<UInt8>?, bilen: Int, spc:String ) ->  String {
        let hex : [Character] =
            [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" ]
        
        var stringToReturn = ""
        
    
        for i in 0..<bilen {
            let c = UInt8( bi![i] )
            stringToReturn.append(hex[Int(c) >> 4])
            
            stringToReturn.append(  hex[Int(c) & 0xf] )
            stringToReturn.append(spc)
            
        }
        
        return stringToReturn
    }
    
 
    
    @IBAction func onReaderDetailsBtn(_ sender: Any)
    {
       ResetProgressbar()
     
      var serialno:String=""
      var iRet: Int
      var firmwareRevision:String=""
      var hardwareRevision:String=""
      let hContext: UInt32? = (mNiOS?.getContextNi() as UInt32?)



         let activeReaderName = getActiveReader() as String
        
        iRet = _getFTDevVer( hContext: UInt32(hContext!), firmware: &firmwareRevision, hardware: &hardwareRevision)
        if iRet != 0 {
            firmwareRevision = String(format: "function FtGetDevVer (error code: 0x%X)", iRet)
            hardwareRevision =  String(format: "function FtGetDevVer (error code: 0x%X)", iRet)
        }
                
        var readerInfo = NSMutableString.init()
        var ntype = getReaderInfo( nsData: readerInfo );
        if ntype != 0 {
            disTextView.text = String(format: "function getReaderInfo (error code: %d)", ntype)
            return ;
        }

        iRet = _getFTSerialNum( hContext:hContext!, SN: &serialno)
        if iRet != 0 {
            serialno = String(format: "function FtGetSerialNum (error code: 0x%X)", iRet)
        }
        

        //Read RID
        let  RIDBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        RIDBuffer.initialize(to: 0)
        let iRetRidNi = mNiOS?.getRidNi( RIDBuffer)
        if(iRetRidNi==16) {
            let strFTlib = bin2hex(bi: RIDBuffer,bilen: 16, spc:" ")
            
            disTextView.text = String(format: "Reader Name: %@\nReader Info: %@\nVendor-SN: %@\nFirmware: %@\nHardware: %@\nRID: %@",mActiveReaderName,readerInfo, serialno,firmwareRevision,hardwareRevision,strFTlib)
        }
        else {
            
            disTextView.text = String(format: "Reader Name: %@\nReader Info: %@\nVendor-SN: %@\nFirmware: %@\nHardware: %@\nRID: %d\n",mActiveReaderName,readerInfo, serialno,firmwareRevision,hardwareRevision,iRetRidNi!)

        }
    }
    
    
    @IBAction func onConnectReaderBleLtUsbBt(_ sender: Any) {
        
        
        
#if BUILD_OPT_CONNECT_BUL
        //define Reader Type
        let readerList :NSMutableArray=NSMutableArray();
        
        var res :Int32?;
       res =  mNiOS?.getReaderListNi(readerList);
       if res <= 0 {
           var msg :String;
           msg = String(format: "function getReaderListNi (error code: %d)" ,
                       res! );
           disTextView.text = msg;
           
           //mbConnectReader = true;
          // ConectReaderBtn.isEnabled = true
          // DisconectReaderBtn.isEnabled = false
         
           return ;
       }

        mActiveReaderName = readerList[0] as! String;
        let mactiveReaderNameMut = NSMutableString(string: mActiveReaderName)
        
        var obj:EventObj
        obj = EventObj()
        obj.idMsg       = mActiveReaderName
        obj.nEventMsg   = EVT_BIND_READER
        doMessageEvent(obj)

#elseif BUILD_OPT_CONNECT_BLE
      
        var scan: scanBleViewCtrl!
        scan = scanBleViewCtrl()
        scan.showViewCtrl(parent: self,nEvent: EVT_BIND_READER)
                
#else

        #error("Not define compile option" )
        exit(-1);
#endif
        


    }
    
 


    var mActiveReaderName:String = ""
    func setActiveReader(_ActiveReader:String!) -> String {
        mActiveReaderName = _ActiveReader
        return mActiveReaderName
    }
    

    func getActiveReader() -> String {
        return mActiveReaderName
    }
    
    
    func doMessageEvent(_ evtObj: EventObj) {
        var msg :String;
        ResetProgressbar()
        
        var reader:String! = evtObj.idMsg as?String
        
//        reader = "TDAi301BLx_FT_E79E86470296"
//        
//        // select reader
//        print(reader)
        
        var libpath="";
        var openModeLib : Int;
        
        openModeLib = getLICPath(path: &libpath );
            
        var LICpath  : NSMutableString
        LICpath =  libpath.mutableCopy() as! NSMutableString;
        var res :Int32?;
        res = mNiOS?.openLibNi(LICpath)
        if (res != 0)
        {
            msg = String(format: "function openLibNi  (error code: %d)" ,res! );
            if(res == NI_LICENSE_FILE_ERROR /*-12*/)
            {
                //FLVL_OPENLIB_MODE
                res = mNiOS?.updateLicenseFileNi()
                switch(res)
                {
                    case 0, 1,2,3:
                        msg = String(format:"Now the new license file has been successfully updated, please connect the reader again.(%d)",res!  );
                         
                    case 100,101,102,103:
                        msg = String(format:"Now the lastest license file has already been installed, please connect the reader again.(%d)",res!  );
                         
                    default:
                        msg = String(format:"function updateLicenseFileNi (error code: %d)" ,res!);
                }
                
            } //if(res == NI_LICENSE_FILE_ERROR /*-12*/)
            
            disTextView.text = msg
            mNiOS?.closeLibNi();
            
            connectReaderBleLtUsbBtBtn.isEnabled=true;
            
            return ;
            
        } //res = mNiOS?.openLibNi(LICpath))
        
    connectReaderBleLtUsbBtBtn.isEnabled=false;
        
    let nsreader = NSMutableString(string: reader!)
    
    res = mNiOS?.selectReaderNi( nsreader );
        if( res != 0 ) {
            var msg :String;
            if( res != NI_READER_NOT_FOUND ) {
                msg = String(format: "Reader Name: %@\nfunction selectReaderNi: (error code: %d)" ,reader!, res! );
                
                disTextView.text = msg
                mNiOS?.closeLibNi();
                
                connectReaderBleLtUsbBtBtn.isEnabled=true;
                
                return ;
            } //if( res != NI_READER_NOT_FOUND )
            
            var readerInfo = NSMutableString.init()
            var ntype = getReaderInfo( nsData: readerInfo );
             
            msg = String(format: "Reader Name: %@\nReader Info: %@\nfunction selectReaderNi: (error code: %d)" ,reader,readerInfo ,res! );
      
            disTextView.text = msg
            
            mNiOS?.closeLibNi();
            
            connectReaderBleLtUsbBtBtn.isEnabled=true;
            return ;
            
        } //if( res != 0 ) res = mNiOS?.selectReaderNi( mActiveReaderName as! NSMutableString );
        
        var readerInfo = NSMutableString.init()
        var ntype = getReaderInfo( nsData: readerInfo );

        setActiveReader( _ActiveReader: reader )
              
        msg = String(format: "Reader Name: %@\nReader Info: %@" ,reader,readerInfo );
        disTextView.text = msg
        
        connectReaderBleLtUsbBtBtn.isEnabled=false;
        disconectReaderBtn.isEnabled = true;
    
        //
        readCardBtn.isEnabled = true;

    } // func doMessageEvent(_ evtObj: EventObj)
    
}
 


