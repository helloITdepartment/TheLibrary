//
//  Book.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/21/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit
class Book {
    var Title: String
    var Subtitle: String?
    var Author: String
    var Cover: UIImage?
    var ISBN: String?
    var Location: Location?
    var PublicationYear: String?
    
    init(title: String, subtitle: String?, author: String, cover: UIImage?, isbn: String?, location: Location) {
        Title = title
        Subtitle = subtitle
        Author = author
        Cover = cover
        ISBN = isbn
        Location = location
    }
}
