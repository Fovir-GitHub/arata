//// Site header / nav: logo or site title, socials, menu, search trigger, and
//// theme toggle.
////
//// Mirrors apollo's `templates/partials/nav.html` structure: a `<nav>` with
//// `.left-nav` (site title or logo + `.socials`) and `.right-nav` (menu items
//// + search button + theme toggle).
////
//// Internal links use `route.href/1` so modem intercepts them for client-side
//// navigation. Social links are external and use `attribute.href/1` directly
//// with `rel="me"` (apollo's default). The search button and theme toggle are
//// non-functional placeholders — Phase 5 wires up search, Phase 10 the theme
//// toggle.

import config.{type Config}
import gleam/list
import gleam/option
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import route

/// Render the site header (`<nav>`).
pub fn view(config: Config) -> Element(msg) {
  html.nav([], [
    html.div([attribute.class("left-nav")], [
      view_site_title(config),
      html.div([attribute.class("socials")], view_socials(config.socials)),
    ]),
    html.div(
      [attribute.class("right-nav")],
      // Menu items (internal links) followed by two non-functional
      // placeholder buttons; handlers arrive in Phase 5 (search) and
      // Phase 10 (theme).
      list.append(view_menu(config.menu), [
        view_search_button(),
        view_theme_toggle(),
      ]),
    ),
  ])
}

// LEFT NAV ---------------------------------------------------------------------

fn view_site_title(config: Config) -> Element(msg) {
  case config.logo {
    option.Some(path) ->
      html.a([route.href(route.Home), attribute.class("logo")], [
        html.img([attribute.alt(config.title), attribute.src(path)]),
      ])
    option.None -> html.a([route.href(route.Home)], [html.text(config.title)])
  }
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

// RIGHT NAV --------------------------------------------------------------------

fn view_menu(menu: List(config.MenuItem)) -> List(Element(msg)) {
  list.map(menu, fn(item) {
    // Menu URLs are same-origin paths; modem intercepts the click and routes
    // through `parse_route`. Using `attribute.href` (rather than `route.href`)
    // because the URL is a raw string from config, not a typed `Route`.
    html.a(
      [attribute.href(item.url), attribute.style("margin-right", "0.5em")],
      [html.text(item.name)],
    )
  })
}

fn view_search_button() -> Element(msg) {
  html.button(
    [
      attribute.id("search-button"),
      attribute.class("search-button"),
      attribute.title("Shortcut to open search"),
    ],
    [
      html.img([
        attribute.src("/icons/search.svg"),
        attribute.alt("Search"),
        attribute.class("search-icon"),
      ]),
    ],
  )
}

fn view_theme_toggle() -> Element(msg) {
  // apollo renders this as an `<a id="dark-mode-toggle">` with inline
  // `onclick`. arata uses a `<button>` (no handler yet) carrying both the
  // apollo id and a class so the ported CSS (`#dark-mode-toggle`) applies.
  html.button(
    [attribute.id("dark-mode-toggle"), attribute.class("theme-toggle")],
    [
      html.img([
        attribute.src("/icons/sun.svg"),
        attribute.id("sun-icon"),
        attribute.alt("Light"),
      ]),
      html.img([
        attribute.src("/icons/moon.svg"),
        attribute.id("moon-icon"),
        attribute.alt("Dark"),
      ]),
    ],
  )
}
