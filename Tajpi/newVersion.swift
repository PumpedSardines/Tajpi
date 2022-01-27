//
//  newVersion.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

/*

 Anyone reading this, tajpi.fritiof.dev is only a s3 bucket and is used for checking if a new version has been released
 THIS DOESN'T COLLECT ANALYTICS
 
 If you want to remove this when you compile the program yourself replace all code here with this snippet:
 
 let newVersionFound = nil;
 func newVersion() {}
 
*/

var newVersionFound: String? = nil;

struct VersionInfo: Decodable {
    let version: String
    let url: String
}

func newVersion() {
    let url = URL(string: "https://tajpi.fritiof.dev/version")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return }
        
        let jsonData = String(data: data, encoding: .utf8)!.data(using: .utf8)!;
        
        let newVersion: VersionInfo = try! JSONDecoder().decode(VersionInfo.self, from: jsonData)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let appVersion = appVersion {
            if appVersion != newVersion.version {
                newVersionFound = newVersion.url;
            }
        }
    }

    task.resume();
}

