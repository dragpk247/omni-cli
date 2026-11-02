# Graph Report - omni-cli  (2026-11-02)

## Corpus Check
- 18 files · ~17,614 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 3 file(s) not represented in the graph (top: (none) 2, .example 1)

## Summary
- 145 nodes · 241 edges · 14 communities (4 shown, 10 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.56)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `83bb59ab`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- omni-core.sh
- 🌐 OMNI CLI
- omni-laptop script
- install.sh script
- omni_detect_device
- omni-desktop script
- omni-phone script
- Omni.psm1

## God Nodes (most connected - your core abstractions)
1. `omni_is_online()` - 12 edges
2. `omni_detect_device()` - 10 edges
3. `omni_run_setup()` - 7 edges
4. `omni_render_header()` - 7 edges
5. `omni_run_update()` - 7 edges
6. `omni_sync_menu()` - 7 edges
7. `Start-OmniDashboard()` - 7 edges
8. `omni_get_clipboard()` - 6 edges
9. `Import-OmniConfig()` - 6 edges
10. `Invoke-Omni()` - 6 edges

## Surprising Connections (you probably didn't know these)
- `omni-clip script` --calls--> `omni_detect_device()`  [EXTRACTED]
  bin/omni-clip → bin/omni-core.sh  _Bridges community 6 → community 5_
- `omni-desktop script` --calls--> `omni_run_setup()`  [EXTRACTED]
  bin/omni-desktop → bin/omni-core.sh  _Bridges community 5 → community 7_
- `omni-laptop script` --calls--> `omni_run_setup()`  [EXTRACTED]
  bin/omni-laptop → bin/omni-core.sh  _Bridges community 5 → community 2_
- `omni-desktop script` --calls--> `omni_render_custom_tools()`  [EXTRACTED]
  bin/omni-desktop → bin/omni-core.sh  _Bridges community 2 → community 7_
- `omni-phone script` --calls--> `omni_is_online()`  [EXTRACTED]
  bin/omni-phone → bin/omni-core.sh  _Bridges community 5 → community 8_

## Import Cycles
- None detected.

## Communities (14 total, 10 thin omitted)

### Community 0 - "omni-core.sh"
Cohesion: 0.07
Nodes (32): C_BLUE, C_BOLD, C_CYAN, C_DIM, C_GREEN, C_MAGENTA, C_RED, C_RESET (+24 more)

### Community 1 - "🌐 OMNI CLI"
Cohesion: 0.17
Nodes (11): 3-Way File Sharing, ⚙️ Configuration, Direct Shortcuts, ⚡ Highlights, Interactive Menu, 📄 License, Linux / macOS / WSL / Android Termux, 🌐 OMNI CLI (+3 more)

### Community 5 - "omni_detect_device"
Cohesion: 0.15
Nodes (10): omni_detect_device(), omni_exec_custom(), omni_is_online(), omni_pair_device(), omni_run_setup(), omni_run_update(), omni_show_version(), omni_sync_menu() (+2 more)

### Community 12 - "Omni.psm1"
Cohesion: 0.64
Nodes (8): Connect-OmniSsh(), Get-OmniPing(), Get-OmniStatus(), Import-OmniConfig(), Invoke-Omni(), Send-OmniFile(), Start-OmniDashboard(), Sync-OmniClipboard()

## Knowledge Gaps
- **27 isolated node(s):** `OMNI_VERSION`, `C_RESET`, `C_BOLD`, `C_CYAN`, `C_GREEN` (+22 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 67 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `omni_is_online()` connect `omni_detect_device` to `omni-core.sh`, `omni-laptop script`, `omni-clip`, `omni-desktop script`, `omni-phone script`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `OMNI_VERSION`, `C_RESET`, `C_BOLD` to the rest of the system?**
  _27 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `omni-core.sh` be split into smaller, more focused modules?**
  _Cohesion score 0.0677361853832442 - nodes in this community are weakly interconnected._
- **Why does `omni_detect_device()` connect `omni_detect_device` to `omni-core.sh`, `omni-clip`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Should `omni_detect_device` be split into smaller, more focused modules?**
  _Cohesion score 0.14736842105263157 - nodes in this community are weakly interconnected._
- **Why does `omni_get_clipboard()` connect `omni-desktop script` to `omni-core.sh`, `omni-phone script`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Should `omni-share` be split into smaller, more focused modules?**
  _Cohesion score 0.09486166007905138 - nodes in this community are weakly interconnected._