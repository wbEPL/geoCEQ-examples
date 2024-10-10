# 1) download the remotes pacakage if you do not all ready have this installed.
#    this package is needed to download a package from Github
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")

# 2) Check if the GeoappPackage is installed, if it is not it is installed from GitHub
if (!requireNamespace("GeoappPackage", quietly = TRUE)) remotes::install_github("wbEPL/Georgia_CEQ_package", force = TRUE, upgrade = FALSE)

# 3) Load the package
library("GeoappPackage")

# 4) Start the tool
#    make sure to edit the path_to_presim and path_to_baseline
run_georgia_ceq_app(
  path_to_presim = "PATH_TO_PRESIM_FILE/presim.rds",
  path_to_baseline = "PATH_TO_BASELINE_FILE/baseline.rds"
  )
