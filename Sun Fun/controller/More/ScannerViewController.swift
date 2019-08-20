//
//  ScannerViewController.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/4/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,UITableViewDelegate,UITableViewDataSource {
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")

    @IBOutlet weak var scanBTN: UIButton!
    @IBOutlet weak var ticNum: UILabel!
    @IBOutlet weak var barcode: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscriberNumber: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ticketNumber: UILabel!
    
    
    @IBOutlet weak var resultLB: UILabel!
    @IBOutlet weak var viewScan: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var codeData = ""
    var booking:MyTicketModel.Booking?
    var details = [MyTicketModel.booking_details]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MyActivityCel", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyActivityCel")
        tableView.delegate = self
        tableView.dataSource = self
        
        scanBTN.roundCorners(cornerRadius: 20.0)
        viewScan.backgroundColor = UIColor.black
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        //dismiss(animated: true)
    }
    
    func found(code: String) {
        resultLB.text = code
        self.codeData = code
        getData()
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func scanNow(_ sender: UIButton) {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewScan.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewScan.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()

    }
    
    func getData(){
        details.removeAll()
        MyOrder_API().getDataBy_QRCODE(booking_code: codeData) { (success:Bool, result_Booking:MyTicketModel.Booking?, result_Details:[MyTicketModel.booking_details]?) in
            if success{
                self.booking = result_Booking!
                self.setEventData()
                self.details.append(contentsOf: result_Details!)
                print("details count \(self.details.count) \(self.details.description)")
                self.tableView.reloadData()
                print("success to get data by qr code")
            }else{
                print("success to get data by qr code")

            }
        }
    }
    func setEventData(){
        ticNum.text = "\(booking!.booking_code!.replacingOccurrences(of: "-", with: ""))"
        price.text = "\(booking!.total_booking_price!)"
        subscriberNumber.text = "\(booking!.subscribers_num!)"
        if booking!.booking_image != nil{
            print("image found")
            barcode.kf.setImage(with: URL(string:QRCodeImageURL +  booking!.booking_image!),options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
                ])
            barcode.contentMode = .scaleToFill
        }else{
            print("image not found")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if details.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No_data_available".localized()
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityCel",for: indexPath) as! MyActivityCel
        let pos = indexPath.row
        if details.count > 0 {
            
            let item = details[pos]
            cell.activityNumber.text = "\("activity_Name_number".localized())\((pos + 1).asWord) : "
            if isArabic{
                cell.activityName.text = item.activitie_ar_title
            }else{
                cell.activityName.text = item.activitie_ar_title
            }
            cell.subscribNumber.text = "\(item.subscribers_num!)"
            if item.activitie_image != nil{
                cell.activityImage.kf.setImage(with: URL(string:uploadEventImageURL + item.activitie_image!),options: [
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                    ])
                cell.activityImage.contentMode = .scaleToFill
            }
            
        }
        
        return cell
    }
}
