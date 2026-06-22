//// Site footer: social links and a copyright line.
////
//// apollo's `base.html` has no explicit `<footer>`; arata adds a minimal one
//// so the bottom of every page has the standard social row and copyright.
//// The structure reuses the apollo `.socials` / `.social` classes from the
//// nav so the same Phase 1 CSS applies.

import config.{type Config}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Hardcoded copyright year. Phase 4+ replaces this with a small FFI call to
/// `new Date().getFullYear()` so the footer stays current without a rebuild.
const current_year = "2025"

/// Render the site footer.
pub fn view(config: Config) -> Element(msg) {
  html.footer([], [
    html.div([attribute.class("socials")], view_socials(config.socials)),
    html.span([], [
      html.text("© " <> current_year <> " " <> config.title),
    ]),
  ])
}

fn view_socials(socials: List(config.Social)) -> List(Element(msg)) {
  list.map(socials, fn(social) {
    html.a(
      [
        attribute.class("social"),
        attribute.href(social.url),
        attribute.rel("me"),
      ],
      [
        html.img([
          attribute.alt(social.name),
          attribute.src("/icons/social/" <> social.icon <> ".svg"),
        ]),
      ],
    )
  })
}
