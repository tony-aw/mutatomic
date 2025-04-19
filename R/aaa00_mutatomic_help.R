#' mutatomic
#'  
#' @description
#' Tools for Safe Pass-By-Reference Modification Semantics on Atomic Objects \cr \cr
#' 
#' 
#' @section What is 'mutatomic'?:
#' 'mutatomic' is an 'R' package that provides 2 things:
#' 
#'  - For regular 'R' users: \cr
#'  A new class of \link[base]{atomic} vectors, matrices, and arrays,
#'  called \link{mutatomic},
#'  that provides (safer) support for pass-by-reference semantics. \cr
#'  It also provides an optional helper function, called \link{currentBindings}.
#'  - For package back-end: \cr
#'  A set of tools for safer pass-by-reference modification semantics
#'  for atomic objects,
#'  as 'R' does not natively provide pass-by-reference mechanics
#' (except via it's internal C API or through a package like 'Rcpp'). \cr
#' The developer tools provided by 'mutatomic' were primarily designed
#' for the 'squarebrackets' and 'broadcast' packages,
#' but authors of other packages are welcome to use 'mutatomic' also. \cr
#' 
#' 'mutatomic' does not come with pass-by-reference functions itself,
#' except for 2 simple example functions (\link{ma_set} and \link{setapply}). \cr
#' \cr
#' 
#' 
#' @section For Regular 'R' Users:
#' Regular 'R' users can construct objects of class 'mutatomic',
#' or convert objects to class 'mutatomic'; \cr
#' see \link{mutatomic_class}. \cr
#' \cr
#' Depending on the situation end users may also use the \link{currentBindings} function. \cr
#' \cr
#' The 'mutatomic' package also comes with a few help pages,
#' that end users can refer to,
#' to gain a better understanding of the pass-by-reference semantics
#' supported by 'mutatomic'. \cr
#' These help pages are the following: 
#' 
#'  - \link{mutatomic_class}: \cr
#'  Explains the 'mutatomic' class.
#'  - \link{mutatomic_PassByReference}: \cr
#'  Explains Pass-by-Reference semantics, and its important consequences.
#'  - \link{mutatomic_coercion}: \cr
#'  Explains the difference in coercion rules between
#'  modification through Pass-by-Reference semantics and
#'  modification through copy (i.e. pass-by-value). \cr \cr
#' 
#' 
#' @section For Package Back-End:
#' 'mutatomic' provides tools for package authors to program with mutable atomic objects. \cr
#' Arguably the most important function in 'mutatomic' for developers is
#' the \link{stopifnot_ma_safe2mutate} function. \cr
#' This function checks if an atomic object is safe to mutate,
#' and gives an error otherwise. \cr
#' \cr
#' What follows is technical information on 'mutatomic',
#' and why a 'mutatomic' class is needed;
#' this is of no interest for regular 'R' users. \cr
#' \cr
#' 
#' 
#' @section Technical - Why is 'mutatomic' needed?:
#' Consider the following code: \cr
#' 
#' ```{r, eval = FALSE}
#' x <- base::letters
#' collapse::setv(x, "a", "xxx")
#' ```
#' 
#' the above code modifies `base::letters` by reference,
#' and nothing is stopping the user from changing base 'R' while 'R' is still running! \cr
#' Now, obviously `collapse::setv()` was meant for internal programming purposes,
#' and not to be called by amateurs. \cr
#' But what if one wishes to design an 'R' package
#' that provides pass-by-reference mechanics for atomic objects
#' in a somewhat safe way? \cr
#' \cr
#' This is where the 'mutatomic' package comes in. \cr
#' 'mutatomic' provides a new class which can be considered the atomic version of the 'data.table' class,
#' and through this class package authors can protect the user from changing things like `base:letters`. \cr
#' \cr
#' 
#' 
#' @section Technical - How does 'mutatomic' solve the issue?:
#' 'mutatomic' first and fore-most provides a new class, called 'mutatomic'. \cr
#' If a function demands an atomic object is of class 'mutatomic' to allow pass-by-reference semantics,
#' the above issue is (mostly) prevented. \cr
#' The issue is prevented through the following means: \cr
#'  - Creating an object of class 'mutatomic',
#'  at least when using the functions provided by this package,
#'  will copy the original object. \cr
#'  So when calling `x <- mutatomic(base::letters)`, `x` no longer refers to `base::letters`.
#'  - When a function demands an object is of class 'mutatomic',
#'  it is (almost) guaranteed it does not refer to an base 'R' object,
#'  so something like `base::letters` will never be modified by reference.
#'  - 'mutatomic' stores a list of most base 'R' (atomic) object addresses when it is loaded. \cr
#'  The \link{is.mutatomic} function checks this list,
#'  creating extra certainty that base 'R' is never modified by reference.
#'  - The 'mutatomic' class is not just defined by a class name attribute. \cr
#'  The class comes with additional attributes to ensure it truly has been created by the functions of this package. \cr
#'  Although these attributes can be mimicked with enough effort,
#'  it is very unlikely for an object to \bold{accidentally} have these attributes. \cr
#'  The \link{is.mutatomic} and \link{stopifnot_ma_safe2mutate} functions check for these attributes,
#'  creating extra security. \cr
#'  - 'mutatomic' respects the lock of a binding,
#'  if there is any. \cr \cr
#'  
#'  
#' @author \strong{Author, Maintainer}: Tony Wilkes \email{tony_a_wilkes@outlook.com} (\href{https://orcid.org/0000-0001-9498-8379}{ORCID})
#' 
#'
#' @references The badges shown in the documentation of this R-package were made using the services of: \url{https://shields.io/}
#'
#' @name aaa00_mutatomic_help
#' @rdname aaa00_mutatomic_help
#' @aliases mutatomic-package
#' @aliases mutatomic_help
#' @useDynLib mutatomic, .registration=TRUE
#' @importFrom Rcpp evalCpp
#' @method `[` mutatomic
#' @method `[<-` mutatomic
#' 
NULL
#> NULL
