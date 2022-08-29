//
//  PhotoItem.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import Foundation

struct PhotoItem: Decodable {
   let id: String
   let created_at: String
   let prefix: String
   let suffix: String
   let width: Int
   let height: Int
}

extension PhotoItem {
    func photoUrlStr(w: Int, h: Int) -> URL? {
        return URL(string: self.prefix + "\(w)x\(h)" + self.suffix)
    }
}

typealias Photos = [PhotoItem]


/*
"id": "5aeb7f7389ad460024c22206",
"created_at": "2018-05-03T21:30:27.000Z",
"prefix": "https://fastly.4sqi.net/img/general/",
"suffix": "/5435652_tVudly9wn9jCMpn9N6qT54RBpyx-rc3BGWg9o4E1gOk.jpg",
"width": 1440,
"height": 1828
*/
