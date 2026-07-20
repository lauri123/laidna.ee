+++
title = "Setting Up the First Proxmox Node"
date = 2026-07-20T10:00:00+03:00
draft = false
tags = ["proxmox", "homelab", "virtualisation"]
summary = "Notes from building the first node — storage layout, network bridges, and the settings I wish I had changed on day one."
cover = ""
+++

This post exists to prove that nested sections render correctly. It lives at
`content/homelab/proxmox/` and should appear under **Homelab** in the sidebar.

## Storage layout

The default LVM-thin layout is fine for a single node. The decision that
matters later is how much room the root volume gets.

## Network bridges

`vmbr0` bridges the physical NIC. Everything else hangs off VLANs on top.
