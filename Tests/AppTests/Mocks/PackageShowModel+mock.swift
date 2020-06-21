@testable import App

import Foundation


extension PackageShow.Model {
    static var mock: PackageShow.Model {
        .init(
            activity: .init(
                openIssuesCount: 27,
                openIssues: .init(label: "27 open issues",
                                  url: "https://github.com/Alamofire/Alamofire/issues"),
                openPullRequests: .init(label: "5 open pull requests",
                                        url: "https://github.com/Alamofire/Alamofire/pulls"),
                lastIssueClosedAt: "5 days ago",
                lastPullRequestClosedAt: "6 days ago"),
            authors: [
                .init(label: "Christian Noon", url: "https://github.com/cnoon"),
                .init(label: "Mattt", url: "https://github.com/mattt"),
                .init(label: "Jon Shier", url: "https://github.com/jshier"),
                .init(label: "Kevin Harwood", url: "https://github.com/kcharwood"),
                .init(label: "186 other contributors", url: "https://github.com/Alamofire/Alamofire/graphs/contributors"),
            ],
            history: .init(
                since: "over 5 years",
                commitCount: .init(label: "1,433 commits",
                                   url: "https://github.com/Alamofire/Alamofire/commits/main"),
                releaseCount: .init(label: "79 releases",
                                    url: "https://github.com/Alamofire/Alamofire/releases"),
                releaseCadence: "10 days"
            ),
            languagePlatforms: .init(
                stable: .init(
                    link: .init(label: "5.2.0",
                                url: "https://github.com/Alamofire/Alamofire/releases/tag/5.2.0"),
                    swiftVersions: ["5", "5.2"],
                    platforms: [.ios("10.0"), .macos("10.12"), .watchos("3.0"), .tvos("10.0")]),
                beta:.init(
                    link: .init(label: "5.3.1-beta.1",
                                url: "https://github.com/Alamofire/Alamofire/releases/tag/5.3.1-beta1"),
                    swiftVersions: ["5.2"],
                    platforms: [.ios("13.0"), .macos("10.15"), .watchos("6.0"), .tvos("13.0")]),
                latest: .init(
                    link: .init(label: "main",
                                url: "https://github.com/Alamofire/Alamofire"),
                    swiftVersions: ["5.2"],
                    platforms: [.ios("13.0"), .macos("10.15"), .watchos("6.0"), .tvos("13.0")])),
            license: .mit,
            products: .init(libraries: 3, executables: 1),
            releases: .init(stable: .init(date: "12 days ago",
                                          link: .init(label: "5.2.0",
                                                      url: "https://github.com/Alamofire/Alamofire/releases/tag/5.2.0")),
                            beta: .init(date: "4 days ago",
                                        link: .init(label: "5.3.0-beta.1",
                                                    url: "https://github.com/Alamofire/Alamofire/releases/tag/5.3.0-beta.1")),
                            latest: .init(date: "12 minutes ago",
                                          link: .init(label: "main",
                                                      url: "https://github.com/Alamofire/Alamofire"))),
            stars: 17,
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis porttitor erat. Vivamus porttitor mi odio, quis imperdiet velit blandit id. Vivamus vehicula urna eget ipsum laoreet, sed porttitor sapien malesuada. Mauris faucibus tellus at augue vehicula, vitae aliquet felis ullamcorper. Praesent vitae leo rhoncus, egestas elit id, porttitor lacus. Cras ac bibendum mauris. Praesent luctus quis nulla sit amet tempus. Ut pharetra non augue sed pellentesque.",
            title: "Alamofire",
            url: "https://github.com/Alamofire/Alamofire.git"
        )
    }
}
