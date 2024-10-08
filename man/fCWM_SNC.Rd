% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fCWM_SNC.R
\name{fCWM_SNC}
\alias{fCWM_SNC}
\title{Calculate community weighted means and species niche centroids for 
double constrained correspondence analysis}
\usage{
fCWM_SNC(
  response = NULL,
  dataEnv = NULL,
  dataTraits = NULL,
  formulaEnv = NULL,
  formulaTraits = NULL,
  divideBySiteTotals = TRUE,
  dc_CA_object = NULL,
  minimal_output = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{response}{matrix, data frame of the abundance data 
(dimension \emph{n} x \emph{m}) or list with community weighted means (CWMs)
from \code{\link{fCWM_SNC}}. See Details for analyses starting from community
weighted means. Rownames of \code{response}, if any, are carried through.}

\item{dataEnv}{matrix or data frame of the row predictors, with rows 
corresponding to those in \code{response}. (dimension \emph{n} x \emph{p}).}

\item{dataTraits}{matrix or data frame of the column predictors, with rows 
corresponding to the columns in \code{response}.
(dimension \emph{m} x \emph{q}).}

\item{formulaEnv}{formula or one-sided formula for the rows (samples) with 
row predictors in \code{dataEnv}. When two-sided, the left hand side of 
the formula is not used. Specify row covariates (if any ) by 
adding \code{+ Condition(covariate-formula)} to \code{formulaEnv} as 
in \code{\link[vegan]{rda}}. The \code{covariate-formula} should not contain 
a \code{~} (tilde). Default: \code{NULL} for \code{~.}, i.e. all variables 
in \code{dataEnv} are predictor variables.}

\item{formulaTraits}{formula or one-sided formula for the columns (species) 
with column predictors in \code{dataTraits}. When two-sided, the left hand 
side of the formula is not used. Specify column covariates (if any ) by 
adding \code{+ Condition(covariate-formula)} to \code{formulaTraits} as 
in \code{\link[vegan]{cca}}. The \code{covariate-formula} should not contain 
a \code{~} (tilde). Default: \code{NULL} for \code{~.}, i.e. all variables 
in \code{dataTraits} are predictor traits.}

\item{divideBySiteTotals}{logical; default \code{TRUE} for closing the 
data by dividing the rows in the \code{response} by their total.}

\item{dc_CA_object}{optional object from an earlier run of this function. 
Useful if the same formula for the columns (\code{formulaTraits}), 
\code{dataTraits} and \code{response} are used with a new formula for the 
rows. If set, the data of the previous run is used and the result of its 
first step is taken for the new analysis.}

\item{minimal_output}{logical. Default \code{TRUE} for use of the return 
value as \code{response} in a call to \code{\link{dc_CA}}.}

\item{verbose}{logical for printing a simple summary (default: TRUE)}
}
\value{
The default returns a list of CWMs, SNCs, weights, \code{formulaTraits} and
a list of data with elements \code{dataEnv} and \code{dataTraits}. When 
\code{minimal_output = FALSE}, many more statistics are given that are 
mainly technical or recomputed when the return value is used as 
\code{response} in a call to \code{\link{dc_CA}}.
}
\description{
Double constrained correspondence analysis (dc-CA) can be calculated directly 
from community weighted means (CWMs), with the trait data from which the 
CWMs are calculated, and the environmental data and weights for species 
and sites (the abundance totals for species and sites). Statistical testing
at the species level requires also the species niche centroids (SNCs).
The function \code{fCWM_SNC} calculates the CWMs and SNCs from the trait 
and environmental data, respectively, using a formula interface, so as to
allow categorical traits and environmental variables. The resulting object
can be set as the \code{response} argument in \code{\link{dc_CA}} so as to
give the same output as a call to \code{\link{dc_CA}} with the abundance
data as \code{response}, at least up to sign changes of the axes.
}
\details{
The argument \code{formulaTraits} determines which CWMs are calculated.
The CWMs are calculated from the trait data (non-centered, non-standardized).
With trait covariates, the other predictor traits are adjusted for the trait 
covariates by weighted regression, after which the overall weighted mean 
trait is added. This has the advantage that each CWM has the scale of the 
original trait.

The SNCs are calculated analogously from environmental data.

Empty (all zero) rows and columns in \code{response} are removed from 
the \code{response} and the corresponding rows from \code{dataEnv} and 
\code{dataTraits}. Subsequently, any columns with missing values are 
removed from  \code{dataEnv} and \code{dataTraits}. It gives an error 
(object 'name_of_variable' not found), if variables with missing entries
are specified in \code{formulaEnv} and \code{formulaTraits}.

In the current implementation, \code{formulaEnv} and \code{formulaTraits} 
should contain variable names as is, \emph{i.e.} transformations of 
variables in the formulas gives an error ('undefined columns selected') 
when the \code{\link{scores}} function is applied.
}
\examples{
data("dune_trait_env")

# rownames are carried forward in results
rownames(dune_trait_env$comm) <- dune_trait_env$comm$Sites

CWMSNC <- fCWM_SNC(formulaEnv = ~ A1 + Moist + Manure + Use + Condition(Mag),
                   formulaTraits = ~ SLA + Height + LDMC + Condition(Seedmass) + Lifespan,
                   response = dune_trait_env$comm[, -1],  # must delete "Sites"
                   dataEnv = dune_trait_env$envir,
                   dataTraits = dune_trait_env$traits)
names(CWMSNC)
#CWMSNC$SNC <- NULL # would give correct dc-CA but no species-level t-values or test
mod <- dc_CA(response = CWMSNC) # formulas and data are in CWMSNC!
# note that output also gives the environment-constrained inertia,
# which is a bonus compare to the usual way to carry out a dcCA.
anova(mod)

}
\references{
Kleyer, M., Dray, S., Bello, F., Lepš, J., Pakeman, R.J., Strauss, 
B., Thuiller, W. & Lavorel, S. (2012) Assessing species and community 
functional responses to environmental gradients: which multivariate methods?
Journal of Vegetation Science, 23, 805-821.
\doi{10.1111/j.1654-1103.2012.01402.x}

ter Braak, CJF, Šmilauer P, and Dray S. 2018. Algorithms and biplots for
double constrained correspondence analysis.
Environmental and Ecological Statistics, 25(2), 171-197.
\doi{10.1007/s10651-017-0395-x} 

ter Braak C.J.F. and  P. Šmilauer  (2018). Canoco reference manual
and user's guide: software for ordination (version 5.1x).
Microcomputer Power, Ithaca, USA, 536 pp.

Oksanen, J., et al. (2022)
vegan: Community Ecology Package. R package version 2.6-4.
\url{https://CRAN.R-project.org/package=vegan}.
}
\seealso{
\code{\link{dc_CA}}, \code{\link{plot.dcca}}, 
\code{\link{scores.dcca}}, \code{\link{print.dcca}} and 
\code{\link{anova.dcca}}
}
