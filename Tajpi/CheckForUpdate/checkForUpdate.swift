//
//  checkForUpdate.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-28.
//

import Foundation

/*

 IMPORTANT NOTE
 
 https://tajpi.fritiof.dev/version does not store analytics.
 It's just a link to a json file stored in an AWS S3 bucket.
 
 You might want to have a version without any calls to a webpage,
 if that's the case replace everything in this file with this:
 
 ```
 var newVersion: String? = nil;
 func checkForUpdate() {}
 ```

 The code above will ensure that everything else works correctly
*/


var newVersion: String? = nil;

struct VersionInfo: Decodable {
    let version: String
    let url: String
}

func pollCheckForUpdate() {
    
    Timer.scheduledTimer(withTimeInterval: 60 * 5, repeats: true) { timer in
        let url = URL(string: "https://tajpi.fritiof.dev/version")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let jsonData = String(data: data, encoding: .utf8)!.data(using: .utf8)!;
            
            let fetchedVersion: VersionInfo = try! JSONDecoder().decode(VersionInfo.self, from: jsonData)
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            if let appVersion = appVersion {
                if appVersion != fetchedVersion.version {
                    newVersion = fetchedVersion.url;
                    delegate.rerender();
                }
            }
        }

        task.resume();
    }
    
}
