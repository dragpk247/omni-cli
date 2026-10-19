# Graph Report - omni-cli  (2026-10-19)

## Corpus Check
- 8 files · ~2,975 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 3 file(s) not represented in the graph (top: (none) 2, .example 1)

## Summary
- 47 nodes · 56 edges · 5 communities (3 shown, 2 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 5 edges (avg confidence: 0.5)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f995a765`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- omni-core.sh
- 🌐 OMNI CLI
- omni_is_online
- omni script
- install.sh

## God Nodes (most connected - your core abstractions)
1. `🌐 OMNI CLI` - 6 edges
2. `omni_is_online()` - 5 edges
3. `omni_render_header()` - 4 edges
4. `🚀 Quick Usage` - 4 edges
5. `omni_run_setup()` - 3 edges
6. `omni_detect_device()` - 3 edges
7. `omni-core.sh script` - 2 edges
8. `C_RESET` - 1 edges
9. `C_BOLD` - 1 edges
10. `C_CYAN` - 1 edges

## Surprising Connections (you probably didn't know these)
- `omni-send script` --calls--> `omni_is_online()`  [EXTRACTED]
  bin/omni-send → bin/omni-core.sh  _Bridges community 2 → community 3_

## Import Cycles
- None detected.

## Communities (5 total, 2 thin omitted)

### Community 0 - "omni-core.sh"
Cohesion: 0.11
Nodes (18): C_BLUE, C_BOLD, C_CYAN, C_DIM, C_GREEN, C_MAGENTA, C_RED, C_RESET (+10 more)

### Community 1 - "🌐 OMNI CLI"
Cohesion: 0.20
Nodes (9): 3-Way File Sharing, ⚙️ Configuration, Direct Shortcuts, ⚡ Highlights, Interactive Menu, 📄 License, 🌐 OMNI CLI, 📦 Quick Installation (+1 more)

### Community 3 - "omni script"
Cohesion: 0.29
Nodes (3): omni_detect_device(), omni_run_setup(), omni-core.sh script

## Knowledge Gaps
- **18 isolated node(s):** `C_RESET`, `C_BOLD`, `C_CYAN`, `C_GREEN`, `C_RED` (+13 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 28 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `omni_is_online()` connect `omni_is_online` to `omni-core.sh`, `omni script`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **What connects `C_RESET`, `C_BOLD`, `C_CYAN` to the rest of the system?**
  _18 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `omni-core.sh` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Why does `omni_render_header()` connect `omni_is_online` to `omni-core.sh`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._