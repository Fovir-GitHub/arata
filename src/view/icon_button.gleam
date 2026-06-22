//// Reusable icon-button link, mirroring apollo's
//// `macros/components.html::icon_button` macro.
////
//// Renders as an `<a class="icon-button">` containing an `<img>` (loaded from
//// `/icons/social/{icon}.svg`) followed by the supplied text. External links
//// open in a new tab with `rel="noopener"` to match apollo's default.

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Render an icon-button link.
///
/// `icon` is the filename (without extension) of an SVG in
/// `static/icons/social/` — e.g. `"github"` resolves to `/icons/social/github.svg`.
pub fn view(href: String, text: String, icon: String) -> Element(msg) {
  html.a(
    [
      attribute.class("icon-button"),
      attribute.href(href),
      attribute.target("_blank"),
      attribute.rel("noopener"),
    ],
    [
      html.img([
        attribute.src("/icons/social/" <> icon <> ".svg"),
        attribute.alt(icon),
      ]),
      html.text(text),
    ],
  )
}
