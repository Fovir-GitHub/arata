//// Talks page view: renders the `/talks` page as a responsive card grid,
//// mirroring apollo's `templates/talks.html`.
////
//// Unlike the projects grid, talks are NOT column-balanced — apollo renders
//// them in document order. The `.talks-grid` CSS handles the responsive
//// row/column flip (row >= 1024px, column below).

import data/talk.{type Talk}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import view/talk_card

/// Render the talks page: a `.page-header` and the `.talks-grid` of talk cards.
pub fn view(talks: List(Talk)) -> Element(msg) {
  html.div([], [
    html.div([attribute.class("page-header")], [html.text("Talks")]),
    html.main([], [
      html.div([attribute.class("talks-grid")], list.map(talks, talk_card.view)),
    ]),
  ])
}
