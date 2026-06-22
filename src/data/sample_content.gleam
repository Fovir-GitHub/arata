//// Sample content for arata.
////
//// This module is a thin compatibility layer. The SPA loads content from
//// `content_index.json` at startup (see `content/runtime.gleam`). The
//// build-time content loader (`content/loader.gleam`) reads `.md` files and
//// the build pipeline serializes them to JSON.
////
//// Projects and talks remain Gleam constants (structured data for card grids,
//// no markdown bodies).

import data/project.{type Project, Project}
import data/talk.{type Talk, Talk}
import gleam/option.{None, Some}

pub fn projects() -> List(Project) {
  [
    Project(
      slug: "arata",
      title: "arata",
      description: "A faithful reimplementation of the apollo blog theme in Gleam and Lustre.",
      link_to: Some("https://github.com/yonzilch/arata"),
      image: None,
      github: Some("https://github.com/yonzilch/arata"),
      demo: None,
      tags: ["gleam", "lustre", "blog"],
    ),
    Project(
      slug: "apollo",
      title: "apollo (upstream)",
      description: "The original Zola blog theme arata is based on — minimal and typography-driven.",
      link_to: Some("https://github.com/not-matthias/apollo"),
      image: None,
      github: Some("https://github.com/not-matthias/apollo"),
      demo: Some("https://not-matthias.github.io/apollo/"),
      tags: ["zola", "rust", "blog"],
    ),
    Project(
      slug: "lustre",
      title: "Lustre",
      description: "An opinionated Gleam frontend framework following The Elm Architecture.",
      link_to: Some("https://hexdocs.pm/lustre"),
      image: None,
      github: Some("https://github.com/lustre-labs/lustre"),
      demo: None,
      tags: ["gleam", "frontend", "mvu"],
    ),
    Project(
      slug: "gleam",
      title: "Gleam",
      description: "A typed, functional language that compiles to JavaScript and Erlang.",
      link_to: Some("https://gleam.run"),
      image: None,
      github: Some("https://github.com/gleam-lang/gleam"),
      demo: None,
      tags: ["language", "functional", "erlang", "javascript"],
    ),
  ]
}

pub fn talks() -> List(Talk) {
  [
    Talk(
      slug: "introducing-arata",
      title: "Introducing arata: apollo in Gleam",
      description: "A walk through porting a Zola theme to a Lustre single-page app — the design-system port, the routing shell, and the Elm-architecture patterns that keep it maintainable.",
      date: "2025-02-10",
      thumbnail: None,
      video_link: Some("https://www.youtube.com/watch?v=example"),
      organizer: Some(#("Gleam Conf", "https://gleam.run")),
      slides: Some("https://example.com/slides"),
      code: Some("https://github.com/yonzilch/arata"),
    ),
    Talk(
      slug: "the-elm-architecture",
      title: "The Elm Architecture in practice",
      description: "How Model-View-Update with managed effects scales from a counter to a full blog theme — and why keeping side effects as data makes refactoring safe.",
      date: "2025-03-05",
      thumbnail: None,
      video_link: Some("https://www.youtube.com/watch?v=example2"),
      organizer: Some(#("Functional Conf", "https://example.com")),
      slides: None,
      code: None,
    ),
  ]
}
