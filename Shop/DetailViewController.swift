//
//  DetailViewController.swift
//  Shop
//
//  Created by Martin Frick on 11.02.18.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit
import SAPCommon
import SAPFiori
import SAPOData

class DetailViewController: UIViewController {

    let logger = Logger.shared(named: "DetailViewController")
    var productID: String?
    
    fileprivate var product: Product? {
        didSet {
            productView.product = product
            navigationController?.title = product?.name
            productView.delegate = self
        }
    }
    
    @IBOutlet var productView: ProductDetailView!
    
    func loadProductDetails() {
        if let productID = productID {
            
            var query = DataQuery().withKey(Product.key(id: productID))
            query = query.expand(Product.images)
            query = query.expand(Product.reviews, withQuery: DataQuery().orderBy(Review.helpfulCount, .descending).top(3))
            
            let loadingIndicator = FUIModalLoadingIndicator.show(inView: view)
            
            Shop.shared.oDataService?.product(query: query) { products, error in
                loadingIndicator.dismiss()
                
                guard error == nil else {
                    self.logger.warn("Error while loading product details", error: error)
                    self.product = nil
                    return
                }
                
                self.product = products?.first
            }
        }
        
        NotificationCenter.default.post(name: Shop.shoppingCartDidUpdateNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProductDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension DetailViewController: ProductDetailViewDelegate {
    
    func didSelectAddToCart(_ button: FUIButton){
        
    }
    
    func didSelectReview(_ review: Review) {
        
    }
    
    func didSelectShowAllReviews(_ button: FUIButton) {
        
    }
    
    func didSelectWriteReview(_ button: FUIButton) {
        
    }
    
}
