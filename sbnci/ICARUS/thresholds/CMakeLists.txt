set( ${product}_threshold_dir "${product}/${version}/ICARUS/thresholds" )
FILE( GLOB threshold_files *ComparisonChiSquareTh.txt )
install( FILES ${threshold_files} DESTINATION ${${product}_threshold_dir} )
