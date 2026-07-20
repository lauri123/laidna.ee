# laidna.ee

Personal technical notes — homelab, electronics, 3D printing, and related
tinkering. Built with [Hugo](https://gohugo.io), themed with a
[fork of risotto](https://github.com/lauri123/risotto).

## Writing

**In the terminal:**

```bash
./dev.sh new content/homelab/proxmox/my-post.md   # create from archetype
./dev.sh                                          # preview at localhost:1313
git add -A && git commit -m "post: my post" && git push
```

**In the browser:** go to [/admin](https://laidna.ee/admin), sign in with a
GitHub token, write, and publish. It commits to this repository directly.

Both routes end in the same place: a commit on `main`.

## How it deploys

`main` is the single source of truth. The server polls this repository every
two minutes, and rebuilds when it sees a new commit:

```
terminal ──push──┐
                 ├──► GitHub (main) ◄── Sveltia /admin
                 │         │
                 │   server fetches (2 min)
                 │         ▼
                 │   Hugo build (pinned container)
                 │         ▼
                 └──► static files behind Caddy
```

CI here only verifies the site builds. It holds no deploy credentials.

## Toolchain

Hugo is **not** installed locally — every command runs through a pinned
container via `./dev.sh`, so local and server builds cannot drift:

`hugomods/hugo:debian-dart-sass-go-git-0.164.0` — Hugo 0.164.0 extended.

Note that hugomods tags containing `reg-` or `std-` are *not* extended
builds, despite appearances. Verify with `docker run --rm <image> hugo
version` and look for `+extended`.

## Swapping the theme

The site is a Hugo module, so a theme swap is a config change — not a
migration. Content deliberately avoids anything theme-specific:

- only built-in shortcodes (`figure`, `highlight`)
- fixed portable front matter: `title`, `date`, `draft`, `tags`, `summary`, `cover`
- site-level overrides in `layouts/` and `assets/` only, never theme edits

To swap, change the import in `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/example/new-theme"
```

then `./dev.sh mod get -u` and adjust `[params]` to the new theme's
conventions. If the theme ships no `go.mod`, fork it and add one — that is
exactly why the risotto fork exists.
