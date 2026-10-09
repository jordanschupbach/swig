# About this fork

This repository is a **modified version of SWIG**, forked from
https://github.com/swig/swig on 2026-10-09 at upstream commit 068bf9b30.
It is maintained at https://github.com/jordanschupbach/swig and is not an
official SWIG release.

The modifications are distributed under the same terms as SWIG itself; see
LICENSE, LICENSE-GPL, LICENSE-UNIVERSITIES and COPYRIGHT. In short: SWIG as a
whole is under the GNU GPL version 3 or later, the Lib and Examples
directories are under the permissive terms given in LICENSE, and the
university licenses apply to the portions they cover. No copyright or license
notice from upstream has been removed or changed.

This file is the "prominent notice" of modification required by section 5(a)
of the GPL version 3. The complete list of modified files and dates is the git
history of every non merge commit not present upstream:

    git log --no-merges upstream/master..master

Each such commit carries a "Fork-Topic:" trailer naming one of the topics
below. "Tools/fork/fork-topics.sh" lists and exports them.

## Change topics

One row per topic. "Upstream" is the intent for the topic and is updated as
it progresses:

- fork-only: specific to this fork, never to be offered upstream
- candidate: written to upstream standards, intended to be offered upstream
- submitted #NNNN: offered upstream as swig/swig pull request NNNN
- merged: accepted upstream; the fork commits are now redundant
- dropped: abandoned or superseded

| Topic | Started | Upstream | Summary |
|---|---|---|---|
| fork-infra | 2026-10-09 | fork-only | Fork notice, agent rules for working on the fork, patch extraction tooling |
| nix-flake | 2026-10-09 | fork-only | Nix flake to build and install SWIG, with a direnv dev shell |
