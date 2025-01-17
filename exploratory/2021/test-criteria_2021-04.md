2021-04-05

``` r
set.seed(2018)
library(cowplot)
library(ggtext)
library(glue)
library(here)
library(knitr)
library(tidyverse)

theme_set(theme_bw())

mutate_perf <- function(dat) {
  dat %>% 
    mutate(mem_mb = max_rss,
           mem_gb = mem_mb / 1024) %>% 
    rename(sec = s)
}
```

``` r
dat <- read_tsv(here('subworkflows', '3_fit_sample_split', 'results', 
                     'optifit_crit_check.tsv')) %>% 
  mutate_perf() %>% 
  select(dataset, printref, criteria, mcc, fraction_mapped, sec, mem_gb, seed) 
```

Sarah W’s description of the criteria parameter:

> We have a criteria parameter that indicates when the reads should be
> moved. We calculated two mcc coefficients. One for the query reads
> (ignoring the references) and one for the query reads and reference
> OTUs. The screen output shows this as “combo” and “fit” lines. By
> default we move a read if either metric improves. The criteria
> parameter lets you indicate you only want to move if the one or the
> other improves. Options are “both” (default), “combo” or “fit”. In
> practice we found “both” gave the best overall results.

My interpretation of the criteria parameter options:

-   `fit` = “query only mcc” - Move query sequence X to OTU Y if it
    improves the mcc calculated using **only the query seqs**.
-   `combo` = “query & ref mcc” - Move query sequence X to OTU Y if it
    improves the mcc calculated using **the query & reference seqs**.
-   `both` = “either” - Move query sequence X to OTU Y if **either** the
    `fit` mcc (“query only”) or the `combo` mcc (“query & ref”) score
    improves.

I ran the 3 criteria options with the human dataset at 50/50 ref/query
split chosen by simple random sample, method=closed, repeated for 20
seeds.

``` r
dat %>% 
  pivot_longer(c(mcc, fraction_mapped, sec), 
               names_to = "metric") %>% 
  ggplot(aes(x = criteria, y = value, color = printref)) +
  geom_jitter(alpha = 0.5, width = 0.2) +
  scale_color_manual(values = c("darkorange", "cyan4")) +
  facet_wrap("metric", scales = "free", nrow = 3) +
  coord_flip()
```

![](figures/crit_facet-1.png)<!-- -->
