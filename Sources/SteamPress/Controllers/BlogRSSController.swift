import Vapor

struct BlogRSSController {

    // MARK: - Properties
    fileprivate let drop: Droplet
    fileprivate let title: String?

    let xmlEnd = "</channel>\n\n</rss>"

    // MARK: - Initialiser
    init(drop: Droplet, title: String?) {
        self.drop = drop
        self.title = title
    }

    // MARK: - Route setup
    func addRoutes() {
        drop.get("rss.xml", handler: rssXmlFeedHandler)
    }

    // MARK: - Route Handler

    private func rssXmlFeedHandler(_ request: Request) throws -> ResponseRepresentable {

        var xmlFeed = getXMLStart()

        for post in try BlogPost.makeQuery().filter(BlogPost.Properties.published, true).all() {
            xmlFeed += post.getPostRSSFeed()
        }

        xmlFeed += xmlEnd

        return xmlFeed
    }

    private func getXMLStart() -> String {

        var title = "SteamPress Blog"

        if let providedTitle = self.title {
            title = providedTitle
        }

        return "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<rss version=\"2.0\">\n\n<channel>\n<title>\(title)</title>\n<link>https://www.steampress.io</link>\n<description>SteamPress is an open-source blogging engine written for Vapor in Swift</description>\n"
    }
}

extension BlogPost {
    func getPostRSSFeed() -> String {
        
        return "<item>\n<title>\n\(title)\n</title>\n<description>\n\(shortSnippet())\n</description>\n<link>\n/posts/\(slugUrl)\n</link>\n</item>\n"
    }
}
