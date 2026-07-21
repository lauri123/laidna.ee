# laidna.ee — personal technical blog (Hugo + risotto)

## Toolchain
- Hugo is NOT installed and must not be. Everything runs via `./dev.sh` (pinned container).
- `./dev.sh` with NO args starts a long-running dev server — it will hang a scripted call.
  Pass args for one-shot builds: `./dev.sh --gc`, `./dev.sh new content/x/y.md`.
- Image pin `hugomods/hugo:debian-dart-sass-go-git-0.164.0`. Tags containing `reg-`/`std-`
  are NOT extended builds despite the naming — verify with `hugo version | grep +extended`.

## Theme
- Theme is a fork: `github.com/lauri123/risotto` (adds go.mod, deprecation fixes,
  cover-driven og:image, Pagefind markers, per-page SEO head — descriptions/canonical/
  JSON-LD — and tag links in the post aside).
- After ANY change to the fork, repin: `./dev.sh mod get -u github.com/lauri123/risotto@main`.
  A plain `mod get -u` silently resolves to inherited upstream tag v0.5.1 and freezes the theme.
- Theme CSS prepends `#` to every h1 — never write a literal `#` in a layout heading.

## Content rules
- Homepage content is `content/_index.md`. A file in `content/homepage/` is an orphan page
  and leaves the front page blank.
- Two-tier front matter: posts = title/date/draft/tags/summary/cover;
  branch pages (`_index.md`) = title/description only.
- Built-in shortcodes only (`figure`, `highlight`). Theme-specific ones break swappability.
- Post `summary` feeds the meta description, RSS, and /llms.txt — always write one.
- Page build options use `[build]` (`_build` was removed in Hugo 0.145); `search.md`
  sets `list = "never"` to stay out of feeds/sitemap while still rendering.

## Previewing
- A production build hard-codes asset URLs to `https://laidna.ee/`, so serving `public/`
  from localhost looks COMPLETELY unstyled. Build with `--baseURL http://127.0.0.1:PORT/`
  and serve on that same port.

## Deploy
- Push to `main` — the server polls and rebuilds within ~2 min. There is no manual deploy.
- Browser editing at `/admin` (Sveltia) commits to this same repo; both paths converge on main.
- Search is Pagefind, indexed server-side at deploy. Its index is WebAssembly, so any CSP
  must include `'wasm-unsafe-eval'` or search silently returns zero results.
