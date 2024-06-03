# Load the ncdf4 library
library(ncdf4)

# Set the path to your NetCDF4 file
nc_file_path <- "tasmax_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc"

# Open the NetCDF4 file
nc_data <- nc_open(nc_file_path)

# Get the list of variable names
variable_names <- names(nc_data$var)

# Print the variable names
print(variable_names)

# Close the NetCDF4 file
nc_close(nc_data)
