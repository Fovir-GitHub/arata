//// Reusable icon-button link, mirroring apollo's
//// `macros/components.html::icon_button` macro.
////
//// Renders as an `<a class="icon-button">` containing an `<img>` (loaded from
//// `/icons/{icon_path}{icon}.svg`) followed by the supplied text. External
//// links open in a new tab with `rel="noopener"` to match apollo's default.
////
//// `icon_path` defaults to `"social/"` (resolving to `/icons/social/…`) for
//// social links; pass `"../"` for UI icons (`calendar`, `map-pin`,
//// `presentation`, `code`) which live directly under `/icons/`.

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Render an icon-button link.
///
/// `icon` is the filename (without extension) of an SVG. `icon_path` is the
/// path prefix under `/icons/`: `"social/"` for social icons (the default),
/// or `"../"` for UI icons that live at `/icons/{icon}.svg` directly.
pub fn view(href: String, text: String, icon: String) -> Element(msg) {
  view_with_path(href, text, icon, "social/")
}

/// Render an icon-button link with a custom icon path prefix.
pub fn view_with_path(
  href: String,
  text: String,
  icon: String,
  icon_path: String,
) -> Element(msg) {
  html.a(
    [
      attribute.class("icon-button"),
      attribute.href(href),
      attribute.target("_blank"),
      attribute.rel("noopener"),
    ],
    [
      html.img([
        attribute.src("/icons/" <> icon_path <> icon <> ".svg"),
        attribute.alt(icon),
      ]),
      html.text(text),
    ],
  )
}
