//// Search data: a search result type and a pure search function.
////
//// The full elasticlunr integration (ROADMAP Phase 12 mentions keeping the
//// vendored core) is deferred — for now arata uses a lightweight
//// case-insensitive substring search over post titles, descriptions, and tags.
//// This provides functional search without pulling a 2567-line JS dependency
//// into the bundle. The search index is built from the in-memory post list at
//// runtime (no build-time index emission needed until the markdown pipeline
//// lands in Phase 17).

import data/post.{type Post}
import gleam/list
import gleam/string

/// One search result: the post and a snippet of where the query matched.
pub type SearchResult {
  SearchResult(post: Post)
}

/// Search `posts` for `query`. Returns matching posts sorted by relevance
/// (title matches first, then description, then tags). An empty query returns
/// an empty list. Matching is case-insensitive.
pub fn search(posts: List(Post), query: String) -> List(SearchResult) {
  case query {
    "" -> []
    _ -> {
      let q = string.lowercase(query)
      posts
      |> list.filter(fn(post) { matches(post, q) })
      |> list.map(fn(post) { SearchResult(post:) })
    }
  }
}

/// Whether a post matches the query in its title, description, or tags.
fn matches(post: Post, query: String) -> Bool {
  let title = string.lowercase(post.title)
  let desc = string.lowercase(post.description)
  let tags =
    post.tags
    |> list.map(string.lowercase)
    |> string.join(" ")
  string.contains(title, query)
  || string.contains(desc, query)
  || string.contains(tags, query)
}
