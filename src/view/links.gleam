//// Links page view: renders friend links as a simple list.

import data/link.{type Link}
import gleam/list
import gleam/option
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Render the links page: a `.page-header` and a `.links-list` of link items.
pub fn view(links: List(Link)) -> Element(msg) {
  html.div([], [
    html.div([attribute.class("page-header")], [html.text("Links")]),
    html.main([], [
      html.ul([attribute.class("links-list")], list.map(links, view_link)),
    ]),
  ])
}

/// Render one friend-link card. Fix 5: the card itself (`<li class="link-item">`)
/// is no longer a single `<a>` — the whole card has `role="generic"` (i.e. it's
/// just a `<div>`/`<li>`). Only the title is a link now, so the card no longer
/// behaves as one giant clickable surface. The avatar and description are
/// non-interactive siblings of the title link.
fn view_link(link: Link) -> Element(msg) {
  let avatar = case link.image {
    option.Some(url) -> [
      html.img([
        attribute.src(url),
        attribute.alt(link.title),
        attribute.class("link-avatar"),
      ]),
    ]
    option.None -> []
  }
  html.li([attribute.class("link-item")], [
    html.div(
      [attribute.class("link-content")],
      list.append(avatar, [
        html.div([attribute.class("link-text")], [
          html.div([attribute.class("link-title")], [
            html.a(
              [
                attribute.href(link.url),
                attribute.target("_blank"),
                attribute.rel("noopener"),
              ],
              [html.text(link.title)],
            ),
          ]),
          html.p([attribute.class("link-description")], [
            html.text(link.description),
          ]),
        ]),
      ]),
    ),
  ])
}
