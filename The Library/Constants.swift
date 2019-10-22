//
//  Constants.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/22/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit

//MARK:- enum Room
enum Room{
    case Den
    case GuestRoom
    case LentOut(to: String)
}

//MARK:- ISBNError
enum ISBNError: Error{
    case IncorrectISBNLength
    case InvalicCharactersInISBN
}

