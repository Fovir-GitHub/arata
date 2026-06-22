//// Content model for a talk (video card), mirroring apollo's talks frontmatter.
////
//// apollo renders talks with the `talks.html` template in a responsive grid
//// that flips from row layout (desktop) to column (mobile). Each card shows a
//// video thumbnail with a play-button overlay, the talk title, a truncated
//// description, and a meta row of icon-buttons (date, organizer, slides, code).

import gleam/option.{type Option}

/// A talk card.
pub type Talk {
  Talk(
    slug: String,
    title: String,
    description: String,
    /// ISO-8601 date string shown in the meta row.
    date: String,
    /// Optional thumbnail image URL. When `None`, apollo uses a default
    /// placeholder image (`images/talks/default.webp`).
    thumbnail: Option(String),
    /// Optional video URL — the thumbnail links here.
    video_link: Option(String),
    /// Optional organizer: name + link, shown as an icon-button.
    organizer: Option(#(String, String)),
    /// Optional slides URL.
    slides: Option(String),
    /// Optional source-code URL.
    code: Option(String),
  )
}
