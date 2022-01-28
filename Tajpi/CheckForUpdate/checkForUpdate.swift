//
//  checkForUpdate.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-28.
//

import Foundation

var newVersion: String? = nil;

struct VersionInfo: Decodable {
    let version: String
    let url: String
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
                newVersion = fetchedVersion.url;
            }
        }
    }

    task.resume();
}
