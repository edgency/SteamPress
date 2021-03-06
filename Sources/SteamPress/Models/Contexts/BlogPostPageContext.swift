struct BlogPostPageContext: Encodable {
    let title: String
    let post: ViewBlogPost
    let author: BlogUser
    let blogPostPage = true
    let pageInformation: BlogGlobalPageInformation
    let postImage: String?
    let postImageAlt: String?
    let shortSnippet: String
}
