//
//  SearchData.swift
//  Health4Food
//
//  Created by Jonathan Wong  on 2/24/19.
//  Copyright © 2019 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import BarcodeScanner
import Alamofire
import SwiftyJSON
import JSONHelper

class SearchDataViewController: UITableViewController, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
    var dataJSON: JSON?
    var upcCode: String?
    
    override func viewDidLoad() {
        navigationItem.title = "HEALTH4FOOD"
        if let window = AppDelegate.del().window as? Window {
            window.screenIsReady = true
        }
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private let headerId = "headerId"
    private let footerId = "footerId"
    private let cellId = "cellId"
    
    //
    // MARK :- HEADER
    //
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return Constants.Screen.height/5.5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
        return header
    }
    
    
    //
    // MARK :- CELL
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let jsonDerulo = self.dataJSON{
            print("yo")
            return jsonDerulo.count
        } else{
            print("oh")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.Screen.height/7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        if let jsonDerulo = self.dataJSON{
            guard let array = jsonDerulo.array else{
                return cell
            }
            let val  = array[0].dictionaryValue
            
            guard let name = val["name"]?.string else{
                return cell
            }
            cell.nameLabel.text = name
            print("name")
            guard let upc = val["upcNum"]?.string else{
                return cell
            }
            cell.upcLabel.text = upc
            print("upc")
            guard let brand = val["brand"]?.string else{
                return cell
            }
            cell.brandLabel.text = brand
            print("brand")
            guard let targetGroup = val["targetGroup"]?.string else{
                return cell
            }
            cell.targetGroupLabel.text = targetGroup
            print("targetGroup")
            guard let photo = val["photoLink"]?.string else{
                return cell
            }
            if let rl = URL(string: photo){
                downloadImage(from: rl, cell: cell)
            }
            
            
        }
        
        return cell
    }
    
    func setupTableView() {
        
        tableView.backgroundColor = .lightGray
        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
    }
    
    func getData(){
        let encodedURL = "https://ocrf6suq56.execute-api.us-east-1.amazonaws.com/dev/health/scanItems"
        
        AF.request(encodedURL, method: .get, interceptor: nil).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.dataJSON = json
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func searchBarcode(barcode: String){
        let encodedURL = "https://ocrf6suq56.execute-api.us-east-1.amazonaws.com/dev/health/" + "{" + barcode + "}"
        
        AF.request(encodedURL, method: .get, interceptor: nil).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.dataJSON = json
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, cell: CustomTableCell) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                print("lmaoooo")
                cell.productImageView.image = UIImage(data: data)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: SCAN BARCODES
    @objc func scanBarcode(){
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.headerViewController.titleLabel.text = "Scan barcode"
        viewController.headerViewController.titleLabel.textColor = Constants.Colors.darkGray
        viewController.headerViewController.closeButton.tintColor = Constants.Colors.mainBlue
        viewController.messageViewController.regularTintColor = Constants.Colors.darkGray
        viewController.messageViewController.errorTintColor = .red
        viewController.messageViewController.textLabel.textColor = Constants.Colors.darkGray
        viewController.cameraViewController.barCodeFocusViewType = .animated
        // Show camera position button
        viewController.cameraViewController.showsCameraButton = true
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        if let cod = self.upcCode{
            if cod==code{
                dismiss(animated: true, completion: nil)
            }
        }
        //send it or whatever
        let headers: HTTPHeaders = ["x-app-key": "5220d22fce42b72eb94facf26358db37", "x-app-id": "7ab8d245"]
        let encodedURL = "https://trackapi.nutritionix.com/v2/search/item"
        let params: Parameters = ["upc": code]
        AF.request(encodedURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["message"]=="resource not found"{
                    controller.resetWithError(message: "Product not found")
                }else{
                    self.upcCode = code
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
        
    }
    
    
}

//
// MARK :- HEADER
//
class CustomTableViewHeader: UITableViewHeaderFooterView {
    let scanBarcodeBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("SCAN BARCODE", for: .normal)
        buttonView.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 50/2
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = Constants.Colors.darkBlue
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        buttonView.addTarget(self, action: #selector(SearchDataViewController.scanBarcode), for: .touchUpInside)
        let image = UIImage(named:"whiteBarcode")
        buttonView.setImage(image, for: .normal)
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.imageEdgeInsets = UIEdgeInsets(top:0, left:-10, bottom:0, right:0)
        return buttonView
    }()
    let searchTF: UITextField = {
        let field = UITextField()
        field.placeholder = "  Search for Product by UPC"
        field.textColor = Constants.Colors.darkGray
//        field.layer.borderWidth = 1
        field.tintColor = Constants.Colors.darkGray
//        field.layer.cornerRadius = 4
        field.font = UIFont.systemFont(ofSize: 15)
//        field.layer.borderColor = Constants.Colors.lightGray.cgColor
        return field
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(scanBarcodeBT)
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        scanBarcodeBT.autoAlignAxis(toSuperviewAxis: .vertical)
        scanBarcodeBT.autoSetDimension(.width, toSize: (Constants.Screen.width-30)/2)
        scanBarcodeBT.autoSetDimension(.height, toSize: 50)
        
        contentView.addSubview(searchTF)
//        searchTF.autoPinEdge(.top, to: .bottom, of: scanBarcodeBT, withOffset: 10)
        let topBorder = CALayer()
        topBorder.borderColor = Constants.Colors.lightGray.cgColor
        topBorder.borderWidth = 1
        topBorder.frame = CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 1)
        searchTF.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = Constants.Colors.lightGray.cgColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRect(x: 0, y: 50, width: Constants.Screen.width, height: 1)
        searchTF.layer.addSublayer(bottomBorder)
        
        searchTF.autoMatch(.height, to: .height, of: scanBarcodeBT)
        searchTF.autoPinEdge(toSuperviewEdge: .left)
        searchTF.autoPinEdge(toSuperviewEdge: .right)
        searchTF.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// MARK :- CELL
//
class CustomTableCell: UITableViewCell {
    
    let productImageView = UIImageView()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let upcLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let targetGroupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let elements = [productImageView, nameLabel, upcLabel, brandLabel, targetGroupLabel]
        for element in elements{
            contentView.addSubview(element)
        }
        contentView.backgroundColor = .white
        productImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        productImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        productImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        productImageView.autoSetDimension(.width, toSize: productImageView.frame.size.height)
        
        nameLabel.autoPinEdge(.top, to: .top, of: productImageView, withOffset: 0)
        nameLabel.autoPinEdge(.left, to: .right, of: productImageView, withOffset: 5)
        
        upcLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 2)
        upcLabel.autoPinEdge(.left, to: .right, of: productImageView, withOffset: 5)
        
        brandLabel.autoPinEdge(.top, to: .bottom, of: upcLabel, withOffset: 2)
        brandLabel.autoPinEdge(.left, to: .right, of: productImageView, withOffset: 5)
        
        targetGroupLabel.autoPinEdge(.top, to: .bottom, of: brandLabel, withOffset: 2)
        targetGroupLabel.autoPinEdge(.left, to: .right, of: productImageView, withOffset: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
