# Graph Report - omni-cli  (2026-10-24)

## Corpus Check
- 15 files · ~13,227 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 3 file(s) not represented in the graph (top: (none) 2, .example 1)

## Summary
- 109 nodes · 188 edges · 12 communities (5 shown, 7 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 9 edges (avg confidence: 0.5)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `dcf0c567`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- omni-core.sh
- 🌐 OMNI CLI
- omni-laptop script
- install.sh
- omni_detect_device
- omni-clip
- omni-desktop script
- omni-phone script
- omni_render_header

## God Nodes (most connected - your core abstractions)
1. `omni_is_online()` - 11 edges
2. `omni_detect_device()` - 9 edges
3. `omni_run_setup()` - 7 edges
4. `omni_render_header()` - 7 edges
5. `omni_run_update()` - 7 edges
6. `omni_sync_menu()` - 7 edges
7. `omni_get_clipboard()` - 6 edges
8. `🌐 OMNI CLI` - 6 edges
9. `omni_wake_mac()` - 5 edges
10. `omni_menu_item()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `omni script` --calls--> `omni_exec_custom()`  [EXTRACTED]
  bin/omni → bin/omni-core.sh  _Bridges community 5 → community 2_
- `omni script` --calls--> `omni_wake_mac()`  [EXTRACTED]
  bin/omni → bin/omni-core.sh  _Bridges community 5 → community 8_
- `omni-clip script` --calls--> `omni_detect_device()`  [EXTRACTED]
  bin/omni-clip → bin/omni-core.sh  _Bridges community 6 → community 5_
- `omni-desktop script` --calls--> `omni_run_setup()`  [EXTRACTED]
  bin/omni-desktop → bin/omni-core.sh  _Bridges community 5 → community 7_
- `omni-desktop script` --calls--> `omni_render_custom_tools()`  [EXTRACTED]
  bin/omni-desktop → bin/omni-core.sh  _Bridges community 2 → community 7_

## Import Cycles
- None detected.

## Communities (12 total, 7 thin omitted)

### Community 0 - "omni-core.sh"
Cohesion: 0.07
Nodes (27): C_BLUE, C_BOLD, C_CYAN, C_DIM, C_GREEN, C_MAGENTA, C_RED, C_RESET (+19 more)

### Community 1 - "🌐 OMNI CLI"
Cohesion: 0.20
Nodes (9): 3-Way File Sharing, ⚙️ Configuration, Direct Shortcuts, ⚡ Highlights, Interactive Menu, 📄 License, 🌐 OMNI CLI, 📦 Quick Installation (+1 more)

### Community 2 - "omni-laptop script"
Cohesion: 0.36
Nodes (3): omni_exec_custom(), omni_exec_custom_tool(), omni_render_custom_tools()

### Community 5 - "omni_detect_device"
Cohesion: 0.21
Nodes (6): omni_detect_device(), omni_pair_device(), omni_run_setup(), omni_run_update(), omni_sync_menu(), omni-core.sh script

### Community 11 - "omni_render_header"
Cohesion: 0.50
Nodes (5): omni_hr(), omni_menu_item(), omni_render_header(), omni_term_cols(), omni_term_lines()

## Knowledge Gaps
- **27 isolated node(s):** `OMNI_VERSION`, `C_RESET`, `C_BOLD`, `C_CYAN`, `C_GREEN` (+22 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 47 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `omni_is_online()` connect `omni-clip` to `omni-core.sh`, `omni-laptop script`, `omni_detect_device`, `omni-desktop script`, `omni-phone script`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **What connects `OMNI_VERSION`, `C_RESET`, `C_BOLD` to the rest of the system?**
  _27 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `omni-core.sh` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._
- **Why does `omni_detect_device()` connect `omni_detect_device` to `omni-core.sh`, `omni-clip`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Why does `omni_get_clipboard()` connect `omni-desktop script` to `omni-core.sh`, `omni-phone script`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._