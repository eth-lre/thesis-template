// Copyright 2026 ETH Zurich.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
//
// Edited by: Vilém Zouhar <vzouhar@ethz.ch>
// Original author of IIS Thesis Report Template: Tim Fischer <fischeti@iis.ee.ethz.ch>


#import "@preview/gentle-clues:1.3.1": code, task

/// Include all pages of a PDF file as full-width images.
/// Use an absolute path (e.g. "/examples/task.pdf") so it resolves from the
/// Typst root regardless of which file calls this function.
/// The page count must be specified manually as Typst does not expose PDF metadata.
#let include-pdf(path, pages: 1) = {
  for i in range(1, pages + 1) {
    image(path, width: 100%, page: i)
  }
}

/// PULP color palette — each entry is a dict with `base`, `light`, and `very-light` variants.
#let pulp-colors = (
  red: (
    base: rgb("#A8322C"),
    light: rgb("#A8322CC8"),
    very-light: rgb("#A8322C96"),
  ),
  blue: (
    base: rgb("#1269B0"),
    light: rgb("#1269B0C8"),
    very-light: rgb("#1269B096"),
  ),
  green: (
    base: rgb("#168638"),
    light: rgb("#168638C8"),
    very-light: rgb("#16863896"),
  ),
  orange: (
    base: rgb("#F29545"),
    light: rgb("#F29545C8"),
    very-light: rgb("#F2954596"),
  ),
  purple: (
    base: rgb("#910569"),
    light: rgb("#910569C8"),
    very-light: rgb("#91056996"),
  ),
  olive: (
    base: rgb("#48592C"),
    light: rgb("#48592CC8"),
    very-light: rgb("#48592C96"),
  ),
  marine: (
    base: rgb("#007996"),
    light: rgb("#007996C8"),
    very-light: rgb("#00799696"),
  ),
  gray: (
    base: rgb("#ABABAB"),
    light: rgb("#ABABABC8"),
    very-light: rgb("#ABABAB96"),
  ),
)


/// The IIS Thesis template
#let thesis(
  /// The title of the thesis
  title: none,
  /// The name of the author
  author: none,
  /// The email of the author
  email: none,
  /// The date of the thesis (defaults to today)
  date: none,
  /// The type of report (e.g. "Master Thesis", "Semester Project")
  reporttype: none,
  /// Title page logo. Accepts any content (e.g. image("fig/logo.svg")).
  header: none,
  /// Abstract content block. Pass content directly or via `include "/abstract.typ"`.
  abstract: none,
  /// Acknowledgements content block. Pass content directly or via `include "/acknowledgements.typ"`.
  acknowledgements: none,
  /// Additional appendices. Array of content blocks, each starting with a level-1
  /// heading. Rendered before the assignment description and declaration of originality.
  /// Defaults to the Typst Quick Guide; pass your own array to replace it.
  appendix: none,
  /// The bibliography, rendered in the backmatter. Pass a bibliography() object.
  bibliography: none,
  advisors: none,
  /// The actual body of the thesis
  body,
) = {
  // Global page & typography settings
  set page(paper: "a4", margin: (
    top: 25mm,
    bottom: 25mm,
    left: 30mm,
    right: 30mm,
  ))
  set text(size: 12pt, lang: "en")
  set par(justify: true)
  set list(indent: 1em)

  // Color all links as blue (e.g. email addresses)
  show link: set text(fill: pulp-colors.blue.base)
  show ref: set text(fill: pulp-colors.blue.base)

  // Heading styles
  // Lenny style: large faint chapter number above a rule, title below
  show heading.where(level: 1): it => {
    // Only break for numbered (mainmatter) chapters; frontmatter headings
    // are already inside page() blocks so a break here creates an empty page.
    if it.numbering != none { pagebreak(weak: true) }
    v(2em)
    if it.numbering != none {
      block(text(
        size: 60pt,
        fill: luma(220),
        weight: "bold",
        counter(heading).display(),
      ))
    }
    line(length: 100%, stroke: 0.5pt)
    v(0.5em)
    block(above: 0em, below: 1em, text(size: 22pt, weight: "bold", it.body))
  }
  show heading.where(level: 2): set text(size: 16pt, weight: "bold")
  show heading.where(level: 2): set block(above: 1.2em, below: 0.6em)
  show heading.where(level: 3): set text(
    size: 14pt,
    weight: "bold",
    style: "italic",
  )
  show heading.where(level: 3): set block(above: 1em, below: 0.5em)
  // Level 4: inline paragraph heading — bold text followed by em-space
  show heading.where(level: 4): it => {
    text(weight: "bold", it.body)
    h(1em)
  }

  // Frontmatter uses roman page numbering e.g. i, ii, iii.
  // Set this BEFORE the title page so no extra page break is inserted.
  // The title page overrides numbering to none for just that one page.
  set page(numbering: "i")

  // Cover page
  page(
    numbering: none,
    header: header,
    {
      line(length: 100%)
      v(1em)

      align(center, {
        smallcaps(text(size: 12pt)[
          Department of Computer Science
          // Information Technology and Electrical Engineering\
          // Integrated Systems Laboratory\
          // #semester
        ])
        v(2em)
        text(size: 28pt, weight: "bold", title)
        v(1em)
        smallcaps(text(size: 16pt, reporttype))
      })

      v(2em)

      v(1fr)

      align(center, {
        text(size: 18pt, author)
        linebreak()
        v(0.5em)
        text(size: 12pt, date)

        v(20pt)
        text(size: 12pt)[
          Advisors:\
          #advisors.map(x => x.name).join(linebreak())
        ]
      })

      v(1fr)

      line(length: 100%)
      v(0.5em)
    },
  )

  // Reset page counter to 1 for frontmatter (after title page)
  counter(page).update(1)

  // Acknowledgements
  page({
    show heading: set heading(numbering: none, outlined: false)
    heading(level: 1)[Acknowledgements]
    acknowledgements
  })

  // Abstract
  page({
    show heading: set heading(numbering: none, outlined: false)
    heading(level: 1)[Abstract]
    abstract
  })

  // Brief declaration of originality (full version in appendix)
  page({
    show heading: set heading(numbering: none, outlined: false)
    heading(level: 1)[Declaration of Originality]
    [I hereby confirm that I am the sole author of the written work here
      enclosed and that I have compiled it in my own words. Parts excepted
      are corrections of form and content by the supervisor.
      // For a detailed version of the declaration of originality, please refer to @app:originality.
    ]
  })

  // Table of contents, list of figures and tables
  {
    // Disable number and outline for the ToC heading
    show heading: set heading(numbering: none, outlined: false)
    // Make chapter entries bold
    show outline.entry.where(level: 1): set text(size: 14pt, weight: "bold")
    outline(title: [Contents], depth: 3, indent: 1em)
    pagebreak()
  }

  // Mainmatter, switching back to arabic numbering and resetting the page counter again.
  set page(numbering: "1")
  counter(page).update(1)
  set heading(numbering: "1.1")

  // The actual body of the thesis
  body

  pagebreak()
  // User-provided appendices
  if appendix != none {
    // Appendix
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
    pagebreak()
  }

  // Backmatter with bibliography
  bibliography
}
