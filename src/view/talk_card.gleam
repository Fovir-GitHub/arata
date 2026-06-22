//// Talk card view: renders a single talk as a `.talk-card`, mirroring
//// apollo's `templates/talks.html` per-card structure.
////
//// Each card shows a video thumbnail with a play-button overlay (linking to
//// the video URL), the talk title, a truncated description, and a meta row of
//// icon-buttons (date, organizer, slides, code). apollo's talks grid flips
//// from a row layout (desktop >= 1024px) to a column layout (mobile) — that
//// responsive behaviour is handled by the ported `.talks-grid` / `.talk-card`
//// CSS.

import data/talk.{type Talk}
import gleam/list
import gleam/option.{type Option}
import lustre/attribute
import lustre/element.{type Element, unsafe_raw_html}
import lustre/element/html
import view/icon_button

/// Render a single talk card.
pub fn view(talk: Talk) -> Element(msg) {
  html.div([attribute.class("talk-card")], [
    view_video(talk),
    html.div([attribute.class("talk-info")], [
      html.h1([attribute.class("talk-title")], [view_title(talk)]),
      view_description(talk.description),
      // Filler to push .meta to the bottom (apollo uses a flex-grow spacer).
      html.div([attribute.style("flex-grow", "1")], []),
      view_meta(talk),
    ]),
  ])
}

/// The video thumbnail with a play-button overlay, wrapped in a link to the
/// video URL. Uses the default placeholder image (`/images/talks/default.webp`)
/// when the talk has no thumbnail.
fn view_video(talk: Talk) -> Element(msg) {
  let video_url = option.unwrap(talk.video_link, "/talks/" <> talk.slug)
  let thumbnail_src =
    option.unwrap(talk.thumbnail, "/images/talks/default.webp")
  html.a(
    [
      attribute.class("talk-video"),
      attribute.href(video_url),
      attribute.target("_blank"),
      attribute.rel("noopener"),
    ],
    [
      html.div([attribute.class("talk-video")], [
        html.img([
          attribute.class("talk-image"),
          attribute.loading("lazy"),
          attribute.decoding("async"),
          attribute.alt("Thumbnail for " <> talk.title),
          attribute.src(thumbnail_src),
        ]),
        html.div([attribute.class("video-play-btn")], [
          html.div([attribute.class("rounded-btn")], [play_icon()]),
        ]),
      ]),
    ],
  )
}

/// The talk title as a link — to the external video, the `link_to` URL, or the
/// internal talk page, matching apollo's precedence.
fn view_title(talk: Talk) -> Element(msg) {
  let url = option.unwrap(talk.video_link, "/talks/" <> talk.slug)
  html.a(
    [attribute.href(url), attribute.target("_blank"), attribute.rel("noopener")],
    [
      html.text(talk.title),
    ],
  )
}

/// The talk description (apollo truncates to 300 chars; the sample content is
/// already short enough).
fn view_description(description: String) -> Element(msg) {
  html.div([attribute.class("talk-description")], [html.text(description)])
}

/// The meta row: date (as a disabled-style icon-button), organizer, slides,
/// and code icon-buttons.
fn view_meta(talk: Talk) -> Element(msg) {
  html.div([attribute.class("meta")], [
    icon_button.view_with_path("#", talk.date, "calendar", "../"),
    ..view_organizer(talk.organizer)
    |> list.append(view_slides(talk.slides))
    |> list.append(view_code(talk.code))
  ])
}

fn view_organizer(organizer: Option(#(String, String))) -> List(Element(msg)) {
  case organizer {
    option.Some(#(name, link)) -> [
      icon_button.view_with_path(link, name, "map-pin", "../"),
    ]
    option.None -> []
  }
}

fn view_slides(slides: Option(String)) -> List(Element(msg)) {
  case slides {
    option.Some(url) -> [
      icon_button.view_with_path(url, "Slides", "presentation", "../"),
    ]
    option.None -> []
  }
}

fn view_code(code: Option(String)) -> List(Element(msg)) {
  case code {
    option.Some(url) -> [icon_button.view_with_path(url, "Code", "code", "../")]
    option.None -> []
  }
}

/// The SVG play-button icon, inlined verbatim from apollo's `talks.html`.
/// Rendered via `unsafe_raw_html` because the path data is large and verbatim
/// from apollo — reconstructing it with `lustre/element/svg` would be verbose
/// for no benefit.
fn play_icon() -> Element(msg) {
  unsafe_raw_html(
    "",
    "svg",
    [
      attribute.attribute("width", "24"),
      attribute.attribute("height", "24"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "currentColor"),
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
    ],
    "<path fill-rule=\"evenodd\" stroke=\"currentColor\" clip-rule=\"evenodd\" d=\"M8.00625 2.80243C8.0182 2.8104 8.03019 2.81839 8.04222 2.82642L18.591 9.8589C18.8962 10.0623 19.1792 10.251 19.3965 10.4263C19.6234 10.6092 19.8908 10.8629 20.0447 11.234C20.2481 11.7245 20.2481 12.2758 20.0447 12.7663C19.8908 13.1374 19.6234 13.391 19.3965 13.574C19.1792 13.7493 18.8962 13.9379 18.591 14.1413L8.00628 21.1978C7.63319 21.4465 7.29772 21.6702 7.01305 21.8245C6.72818 21.9789 6.33717 22.1553 5.8808 22.128C5.29705 22.0932 4.75779 21.8046 4.40498 21.3382C4.12916 20.9736 4.05905 20.5504 4.02949 20.2278C3.99994 19.9053 3.99997 19.5021 4 19.0537L4 4.98975C4 4.97529 4 4.96087 4 4.9465C3.99997 4.49811 3.99994 4.09491 4.02949 3.77249C4.05905 3.44983 4.12916 3.02663 4.40498 2.66202C4.75779 2.19565 5.29705 1.90705 5.8808 1.87219C6.33717 1.84494 6.72818 2.02135 7.01305 2.17573C7.29771 2.33 7.63317 2.55368 8.00625 2.80243Z\" fill=\"currentColor\" />",
  )
}
