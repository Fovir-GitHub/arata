// arata — redirect FFI: reads the deep-link path stashed in sessionStorage by
// the 404.html redirect shim.
//
// When a user hits a deep link (e.g. /posts/hello) on a static host that
// serves 404.html for unknown paths, the shim stores the original path under
// the `arata-redirect` key and bounces to `/`. The SPA's `init` effect calls
// `get_redirect_path()` to retrieve (and clear) that path so the client-side
// router can navigate to the intended route — preserving the deep link
// without the infinite redirect loop caused by `window.location.href = path`.

export function get_redirect_path() {
  try {
    const path = sessionStorage.getItem("arata-redirect");
    if (path) {
      sessionStorage.removeItem("arata-redirect");
      return path;
    }
  } catch {
    // sessionStorage may be unavailable (e.g. privacy mode); treat as no
    // redirect.
  }
  return "";
}
