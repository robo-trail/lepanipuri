# 🍽️ LePaniPuri: Bimanual Embodied AI for Making Indian Street Food

LePaniPuri is our Embodied AI Hackathon project, built around teaching bimanual SO-101 arms powered by Jetson Thor and the Groot N1.5 model to make [Pani Puri](https://en.wikipedia.org/wiki/Panipuri) - an iconic Indian street food.

This project demonstrates embodied AI applied to a culturally rich manipulation task — preparing pani puri using two coordinated SO-101 arms. Each arm performs a specific role such as:
1. Picking and placing puris
2. Poking holes into the puris
3. Stuffing potato fillings
4. Pouring flavored water through squeeze bottles


## TODO:

- [ ] Update README.md with project specific instructions
- [ ] Add docs for ssh setup and thor setup
- [ ] Calibrate leader-follower
- [ ] Docker for Thor
- [ ] Torch with CUDA
- [ ] Benchmark teleoperation delays on x86 vs ARM
- [ ] Look into new l4t release


## Table of Contents

1. [Key Features](#key-features)
2. [Getting Started](#getting-started)
3. [Version Dependency](#version-dependency)
4. [Prerequisites](#prerequisites)
5. [Troubleshooting](#troubleshooting)
6. [Support](#support)
6. [License](#license)
6. [Acknowledgement](#acknowledgement)


## Key Features

- **Bimanual robot setup** using two pair of SO-101 arms (leader + follower)
- **Jetson Thor deployment** with Docker-based reproducible environments


## Getting Started

For the latest documentation, see [Sphinx Book Theme Template](https://github.com/trushant05/sphinx_book_theme_template). 


## Version Dependency


## Prerequisites 

Ensure that your system is up with the following:
- **Operating System**: Ubuntu 24.04
- **GPU**: NVIDIA Jetson Thor 


## Troubleshooting

Please refer to:
- [FAQ]()
- [Troubleshoting]()
- [Known Issues]()


## Support

[Github Issues](https://github.com/robo-trail/lepanipuri/issues) should only be used to track executable pieces of work with a definite scope and a clear deliverable. These can be fixing bugs, documentation issues, new features, or general updates.


## ⚖️ License

All licenses for dependencies and assets are located in the ['docs/licenses'](docs/licenses) directory.


## 🙌 Acknowledgement

LePaniPuri was developed during the Embodied AI Hackathon 2025 by Seeed Studio, powered by NVIDIA Jetson Thor. Special thanks to the SO-101 arm creators, Isaac Groot team, and the broader coomunity for open-source support.

```bibtex
@misc{LePaniPuri,
    author = {Trushant Adeshara, },
    title = {LePaniPuri: Bimanual Embodied AI for Pani Puri (Indian Street Food)},
    month = {October},
    year = {2025},
    url = {https://github.com/robo-trail/lepanipuri}
}
```