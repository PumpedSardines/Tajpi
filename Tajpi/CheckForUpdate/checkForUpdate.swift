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
private var onNewUpdates: [() -> Void] = [];

struct VersionInfo: Decodable {
    let version: String
    let url: String
}

func onNewUpdate(_ f: @escaping () -> Void) {
    onNewUpdates.append(f);
}

func checkForUpdate() {
    let url = URL(string: "https://tajpi.fritiof.dev/version")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return }
        
        let jsonData = String(data: data, encoding: .utf8)!.data(using: .utf8)!;
        
        let fetchedVersion: VersionInfo = try! JSONDecoder().decode(VersionInfo.self, from: jsonData)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let appVersion = appVersion {
            if appVersion != fetchedVersion.version {
                if newVersion != fetchedVersion.url {
                    for f in onNewUpdates {
                        f();
                    }
                }
                
                newVersion = fetchedVersion.url;
            }
        }
    }

    task.resume();
    
    // Check for an update 5 minutes later
    DispatchQueue.main.asyncAfter(deadline: .now() + 60 * 5) {checkForUpdate()}
}
