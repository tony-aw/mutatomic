
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mutatomic

<!-- badges: start -->

[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/badge/ORCID-0000--0001--9498--8379-green.svg)](https://orcid.org/0000-0001-9498-8379)
<!-- badges: end -->

mutatomic: Tools for Safe Pass-by-Reference Modification Semantics on
Atomic Objects

## Description

Provides tools, including a new class (‘mutatomic’), for safe
pass-by-reference modification semantics on atomic objects. Primary
purpose for this package is so the ‘mutatomic’ class and its related
tools are accessible for other packages that wish to implement safe
pass-by-reference semantics for atomic objects.

 

## Get Started

To get started see `?mutatomic_help` or click `here`.

 

## Installing & Loading

One can install ‘mutatomic’ from GitHub like so:

``` r
remotes::install_github("https://github.com/tony-aw/mutatomic")
```

One can attach the package - thus exposing its functions to the
namespace - using:

``` r
library(mutatomic)
```

 
