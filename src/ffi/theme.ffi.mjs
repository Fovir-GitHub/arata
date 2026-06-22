// arata — theme FFI: localStorage persistence and prefers-color-scheme
// subscription.
//
// Mirrors apollo's `static/js/themetoggle.js` behaviour:
//   - `get_theme()` reads `localStorage["theme-storage"]`, falling back to the
//     system preference. Returns the string "light" | "dark" | "auto".
//   - `set_theme(mode)` writes the string to localStorage and applies the
//     `dark`/`light` class on <html> (resolving `auto` against the system
//     preference).
//   - `subscribe_to_system_changes(dispatch)` registers a matchMedia change
//     listener that calls `dispatch(true|false)` when the OS theme changes.
//
// The class on <html> is the single source of truth for the CSS: `:root` is
// light by default, `:root.dark` overrides to dark (see arata.css). This
// matches apollo's `htmlElement.classList.add/remove("dark"/"light")`.

export function get_theme() {
  let stored = null;
  try {
    stored = window.localStorage.getItem("theme-storage");
  } catch {
    // localStorage may be unavailable (e.g. privacy mode); fall back to system.
  }
  if (stored === "light" || stored === "dark" || stored === "auto") {
    return stored;
  }
  // No saved preference — use the system preference.
  return get_system_prefers_dark() ? "dark" : "light";
}

export function set_theme(mode) {
  try {
    window.localStorage.setItem("theme-storage", mode);
  } catch {
    // Ignore write failures (privacy mode, quota, etc.).
  }
  apply_theme(mode);
}

/// Apply the theme to the DOM: toggle the `dark`/`light` classes on <html>.
/// `auto` resolves against the system preference. Also toggles the visibility
/// of the sun/moon/auto icons in the nav toggle.
export function apply_theme(mode) {
  const useDark =
    mode === "dark" || (mode === "auto" && get_system_prefers_dark());
  const html = document.documentElement;
  if (useDark) {
    html.classList.remove("light");
    html.classList.add("dark");
  } else {
    html.classList.remove("dark");
    html.classList.add("light");
  }
  // Toggle icon visibility (sun for light, moon for dark, auto for auto).
  const sun = document.getElementById("sun-icon");
  const moon = document.getElementById("moon-icon");
  const auto = document.getElementById("auto-icon");
  if (sun) sun.style.display = mode === "light" ? "block" : "none";
  if (moon) moon.style.display = mode === "dark" ? "block" : "none";
  if (auto) {
    auto.style.display = mode === "auto" ? "block" : "none";
    if (mode === "auto") {
      auto.style.filter = get_system_prefers_dark() ? "invert(1)" : "invert(0)";
    } else {
      auto.style.filter = "none";
    }
  }
}

export function get_system_prefers_dark() {
  return (
    typeof window !== "undefined" &&
    window.matchMedia &&
    window.matchMedia("(prefers-color-scheme: dark)").matches
  );
}

/// Register a listener for system theme changes. The callback receives `true`
/// when the system switches to dark, `false` for light. Returns an unsubscribe
/// function.
export function subscribe_to_system_changes(dispatch) {
  if (typeof window === "undefined" || !window.matchMedia) return () => {};
  const mql = window.matchMedia("(prefers-color-scheme: dark)");
  const handler = (e) => dispatch(e.matches);
  mql.addEventListener("change", handler);
  return () => mql.removeEventListener("change", handler);
}
