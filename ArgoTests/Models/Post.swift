import Argo

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: List<Comment>
}

extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
      <*> j <|| "comments"
  }
}