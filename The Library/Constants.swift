//
//  Constants.swift
//  The Library
//
//  Created by Jacques Benzakein on 9/22/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import UIKit
enum Room{
    case Den
    case GuestRoom
    case LentOut(to: String)
}

enum JBError: Error{
    case IncorrectISBNLength
    case InvalicCharactersInISBN
}

