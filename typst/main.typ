#import "thesis_template.typ": thesis

#show: thesis.with(
  title: "This could be your thesis",
  author: "Your Name",
  header: box(baseline: -0.5em, image("img/logo_eth.svg", height: 35%))
    + h(1fr)
    + box(image("img/logo_lre.svg", height: 60%))
    + v(-1em),
  reporttype: "Master Thesis",
  advisors: (
    (name: "Here be advisor", mail: "their email"),
    (name: "Mrinmaya Sachan", mail: "msachan@ethz.ch"),
  ),
  abstract: lorem(50),
  bibliography: bibliography("bibliography.bib", style: "acl.csl"),
  acknowledgements: text(fill: red)[TODO: acknowledge],
  date: [April 29, 2026],
)

= Introduction

#lorem(600)

This is how to cite:
@thompson-etal-2024-improving

#pagebreak()

= Related work

#lorem(1000)

#pagebreak()

= Methods

#lorem(1000)

= Experiments and results

#lorem(1000)

= Conclusion

#lorem(1000)
