Introduction to the Bioconductor
================
Mburu
5/27/2020

## Current version is using bioc manager

# Bioconductor version

In the video, you learned about the Bioconductor project. One advantage
of this fantastic resource is its continuous improvements, reflected in
scheduled releases. Hence, checking the current version is important for
the reproducibility of your analysis.

Important note: For this course, you will be using the BiocInstaller
package to install and check package versions, as we will be using
Bioconductor version 3.6. For details on the latest Bioconductor
installation instructions see Bioconductor install page.

The package BiocInstaller has been installed using
source(“<https://bioconductor.org/biocLite.R>”). Remember, you can
check the Bioconductor version using the function biocVersion() from the
BiocInstaller package.

``` r
# Load the BiocInstaller package
#install.packages("BiocManager")

library(BiocManager)

# Check R version
#version
sessionInfo()
```

    ## R version 4.0.0 (2020-04-24)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 18363)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_Kenya.1252  LC_CTYPE=English_Kenya.1252   
    ## [3] LC_MONETARY=English_Kenya.1252 LC_NUMERIC=C                  
    ## [5] LC_TIME=English_Kenya.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] BiocManager_1.30.10
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.0.0  magrittr_1.5    tools_4.0.0     htmltools_0.4.0
    ##  [5] yaml_2.2.1      Rcpp_1.0.4.6    stringi_1.4.6   rmarkdown_2.1  
    ##  [9] knitr_1.28      stringr_1.4.0   xfun_0.14       digest_0.6.25  
    ## [13] rlang_0.4.6     evaluate_0.14

``` r
# Explicit syntax to check the Bioconductor version
BiocManager::version()
```

    ## [1] '3.11'

## BiocLite to install packages

As example to install packages we will use the BSgenome package. This is
a data package which contains representations of several genomes. When
you install a new package it usually calls installations for its
dependencies that takes some time, hence we have already installed
BSgenome for you to use on this exercise.

Note: Using Bioconductor version 3.7 or earlier, packages can be
installed using the following code:

# Using Bioconductor version 3.6

source(“<https://bioconductor.org/biocLite.R>”) biocLite(“BSgenome”)

# Load the package

library(BSgenome) For versions 3.8 or higher, you will use the
BiocManager instead.

For this exercise, you should not use source() or biocLite() to install
BSgenome. This has already been done for you.

You can load the package using library(packageName) and check the
package’s version using the function packageVersion(“packageName”)

``` r
#install("BSgenome")
# Load the BSgenome package
library(BSgenome)

# Check the version of the BSgenome package
packageVersion("BSgenome")
```

    ## [1] '1.56.0'

# S4 class definition

We will use the class BSgenome, which is already loaded for you.

Let’s check the formal definition of this class by using the function
showClass(“className”). Check the BSgenome class results and find its
parent classes (Extends) and the classes that inherit from it
(Subclasses).

  - Well done\! The BSgenome is a powerful class and inherits from
    GenomeDescription, which you will see later on, and has
    MaskedBSgenome as subclass.

<!-- end list -->

``` r
showClass("BSgenome")
```

    ## Class "BSgenome" [package "BSgenome"]
    ## 
    ## Slots:
    ##                                                                      
    ## Name:               pkgname     single_sequences   multiple_sequences
    ## Class:            character OnDiskNamedSequences        RdaCollection
    ##                                                                      
    ## Name:            source_url        user_seqnames   injectSNPs_handler
    ## Class:            character            character    InjectSNPsHandler
    ##                                                                      
    ## Name:           .seqs_cache         .link_counts        nmask_per_seq
    ## Class:          environment          environment              integer
    ##                                                                      
    ## Name:                 masks             organism          common_name
    ## Class:        RdaCollection            character            character
    ##                                                                      
    ## Name:              provider     provider_version         release_date
    ## Class:            character            character            character
    ##                                                 
    ## Name:          release_name              seqinfo
    ## Class:            character              Seqinfo
    ## 
    ## Extends: "GenomeDescription"
    ## 
    ## Known Subclasses: "MaskedBSgenome"

# Interaction with classes

Let’s say we have an object called a\_genome from class BSgenome. With
a\_genome, you can ask questions like these:

# What is a\_genome’s main class?

class(a\_genome) \# “BSgenome”

# What is a\_genome’s other classes?

is(a\_genome) \# “BSgenome”, “GenomeDescription”

# Is a\_genome an S4 representation?

isS4(a\_genome) \# TRUE If you want to find out more about the a\_genome
object, you can use the accessor show(a\_genome) or use other specific
accessors from the list of .S4methods(class = “BSgenome”).

  - Keep up the good work\! You can now check other objects and
    investigate if they are S4 objects, their classes, and their
    accessors. Remember, you can use .S4methods() or showMethods() to
    check the accessors list of a class or a function.

<!-- end list -->

``` r
# Investigate the a_genome using show()
# Read a_genome
library(BSgenome.Scerevisiae.UCSC.sacCer3)
a_genome <- BSgenome.Scerevisiae.UCSC.sacCer3
show(a_genome)
```

    ## Yeast genome:
    ## # organism: Saccharomyces cerevisiae (Yeast)
    ## # provider: UCSC
    ## # provider version: sacCer3
    ## # release date: April 2011
    ## # release name: SGD April 2011 sequence
    ## # 17 sequences:
    ## #   chrI    chrII   chrIII  chrIV   chrV    chrVI   chrVII  chrVIII chrIX  
    ## #   chrX    chrXI   chrXII  chrXIII chrXIV  chrXV   chrXVI  chrM           
    ## # (use 'seqnames()' to see all the sequence names, use the '$' or '[[' operator
    ## # to access a given sequence)

``` r
# Investigate some other accesors
organism(a_genome)
```

    ## [1] "Saccharomyces cerevisiae"

``` r
provider(a_genome)
```

    ## [1] "UCSC"

``` r
seqinfo(a_genome)
```

    ## Seqinfo object with 17 sequences (1 circular) from sacCer3 genome:
    ##   seqnames seqlengths isCircular  genome
    ##   chrI         230218      FALSE sacCer3
    ##   chrII        813184      FALSE sacCer3
    ##   chrIII       316620      FALSE sacCer3
    ##   chrIV       1531933      FALSE sacCer3
    ##   chrV         576874      FALSE sacCer3
    ##   ...             ...        ...     ...
    ##   chrXIII      924431      FALSE sacCer3
    ##   chrXIV       784333      FALSE sacCer3
    ##   chrXV       1091291      FALSE sacCer3
    ##   chrXVI       948066      FALSE sacCer3
    ##   chrM          85779       TRUE sacCer3

# Discovering the Yeast genome

Let’s continue to explore the yeast genome using the package
BSgenome.Scerevisiae.UCSC.sacCer3 which is already installed for you.

As with other data in R, we can use head() and tail() to explore the
yeastGenome object. We can also subset the genome by chromosome by using
`$` as follows: object\_name `$` chromosome\_name. If you need the names
of the chromosomes use the names() function. Another nifty function is
nchar(), used to count the number of characters in a sequence.

``` r
# Load the yeast genome
library(BSgenome.Scerevisiae.UCSC.sacCer3)

# Assign data to the yeastGenome object
yeastGenome <- BSgenome.Scerevisiae.UCSC.sacCer3

# Get the head of seqnames and tail of seqlengths for yeastGenome
head(seqnames(yeastGenome))
```

    ## [1] "chrI"   "chrII"  "chrIII" "chrIV"  "chrV"   "chrVI"

``` r
tail(seqlengths(yeastGenome))
```

    ##  chrXII chrXIII  chrXIV   chrXV  chrXVI    chrM 
    ## 1078177  924431  784333 1091291  948066   85779

``` r
# Print chromosome M, alias chrM
yeastGenome$chrM
```

    ## 85779-letter DNAString object
    ## seq: TTCATAATTAATTTTTTATATATATATTATATTATA...TACAGAAATATGCTTAATTATAATATAATATCCATA

``` r
# Count characters of the chrM sequence
nchar(yeastGenome$chrM)
```

    ## [1] 85779

## Partitioning the Yeast genome

Genomes are often big, but interest usually lies in specific regions of
them. Therefore, we need to subset a genome by extracting parts of it.
To pick a sequence interval use getSeq() and specify the name of the
chromosome, and the start and end of the sequence interval:

getSeq(yeastGenome, names = “chrI”, start = 100, end = 150) Notice that
names is optional; if not specified, it will return all chromosomes. The
parameters start and end are also optional and, if not specified, will
take the default values 1 and the length of the sequence respectively.

  - Congratulations, this might have been the beginning of your first
    sequence analysis\!

<!-- end list -->

``` r
# Load the yeast genome
library(BSgenome.Scerevisiae.UCSC.sacCer3)

# Assign data to the yeastGenome object
yeastGenome <- BSgenome.Scerevisiae.UCSC.sacCer3

# Get the first 30 bases of each chromosome
getSeq(yeastGenome, start = 1, end = 30)
```

    ## DNAStringSet object of length 17:
    ##      width seq                                              names               
    ##  [1]    30 CCACACCACACCCACACACCCACACACCAC                   chrI
    ##  [2]    30 AAATAGCCCTCATGTACGTCTCCTCCAAGC                   chrII
    ##  [3]    30 CCCACACACCACACCCACACCACACCCACA                   chrIII
    ##  [4]    30 ACACCACACCCACACCACACCCACACACAC                   chrIV
    ##  [5]    30 CGTCTCCTCCAAGCCCTGTTGTCTCTTACC                   chrV
    ##  ...   ... ...
    ## [13]    30 CCACACACACACCACACCCACACCACACCC                   chrXIII
    ## [14]    30 CCGGCTTTCTGACCGAAATTAAAAAAAAAA                   chrXIV
    ## [15]    30 ACACCACACCCACACCACACCCACACCCAC                   chrXV
    ## [16]    30 AAATAGCCCTCATGTACGTCTCCTCCAAGC                   chrXVI
    ## [17]    30 TTCATAATTAATTTTTTATATATATATTAT                   chrM
