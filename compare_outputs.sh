#!/bin/bash -e

num_of_processes=( 1 2 3 4 )
taudem_versions_dirs=( $taudem_dev_bin_dir $taudem_acc_bin_dir )
taudem_version_names=( "dev" "acc" )
flowdirection_utities=( "d8flowdir" "dinfflowdir" )
flowdirection_types=( "d8" "dinf")
flow_angle_arg=( "p" "ang")
flow_slope_arg=("sd8" "slp")

temp_dir="$taudem_tests_dirs"/tmp
reference_dir="$taudem_tests_dirs"/ReferenceResult
input_dir="$taudem_tests_dirs"/Input

ORIG_PATH=$PATH

if [ -d "$temp_dir" ]; then
    rm -rf $temp_dir
fi

mkdir $temp_dir

counter_pd=0 ; counter_a=0
for pd in ${taudem_versions_dirs[*]}; do

    PATH=$pd:$ORIG_PATH
    p=${taudem_version_names[$counter_pd]}
    counter_pd=$((counter_pd+1))

    for a in ${flowdirection_utities[*]}; do
        a_name=${flowdirection_types[$counter_a]}
        a_angle_arg=${flow_angle_arg[$counter_a]}
        a_slope_arg=${flow_slope_arg[$counter_a]}
        counter_a=$((counter_a+1))
        
        for n in ${num_of_processes[@]}; do 
            
            echo -e "\n"$a_name $a_angle_arg $a_slope_arg $n; sleep 2

            # filled versions
            specific_ref_dir=Base
            specific_ref_dir_fp=$reference_dir/$specific_ref_dir
            echo -e "\nmpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/loganfel.tif -$a_angle_arg $temp_dir/logan"$a_angle_arg"_"$p"_"$n".tif -$a_slope_arg $temp_dir/logan"$a_slope_arg"_"$p"_"$n".tif"
            mpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/loganfel.tif -$a_angle_arg $temp_dir/logan"$a_angle_arg"_"$p"_"$n".tif -$a_slope_arg $temp_dir/logan"$a_slope_arg"_"$p"_"$n".tif 
            compare_rasters.py $specific_ref_dir_fp/logan"$a_angle_arg".tif $temp_dir/logan"$a_angle_arg"_"$p"_"$n".tif || exit 1
            compare_rasters.py $specific_ref_dir_fp/logan"$a_slope_arg".tif $temp_dir/logan"$a_slope_arg"_"$p"_"$n".tif || exit 1
            
            # not filled versions
            echo -e "\nmpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/logan.tif -$a_angle_arg $temp_dir/logan"$flow_angle_arg"nf_"$p"_"$n".tif -$a_slope_arg $temp_dir/logan"$flow_slope_arg"nf_"$p"_"$n".tif"
            mpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/logan.tif -$a_angle_arg $temp_dir/logan"$a_angle_arg"nf_"$p"_"$n".tif -$a_slope_arg $temp_dir/logan"$a_slope_arg"nf_"$p"_"$n".tif 
            compare_rasters.py $specific_ref_dir_fp/logan"$a_angle_arg"nf.tif $temp_dir/logan"$a_angle_arg"nf_"$p"_"$n".tif || exit 1
            compare_rasters.py $specific_ref_dir_fp/logan"$a_slope_arg"nf.tif $temp_dir/logan"$a_slope_arg"nf_"$p"_"$n".tif || exit 1

            specific_ref_dir=Geographic
            specific_ref_dir_fp=$reference_dir/$specific_ref_dir
            echo -e "\nmpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/enogeofel.tif -$a_angle_arg $temp_dir/enogeo"$a_angle_arg"_"$p"_"$n".tif -$a_slope_arg $temp_dir/enogeo"$a_slope_arg"_"$p"_"$n".tif"
            mpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/enogeofel.tif -$a_angle_arg $temp_dir/enogeo"$a_angle_arg"_"$p"_"$n".tif -$a_slope_arg $temp_dir/enogeo"$a_slope_arg"_"$p"_"$n".tif 
            compare_rasters.py $specific_ref_dir_fp/enogeo"$a_angle_arg".tif $temp_dir/enogeo"$a_angle_arg"_"$p"_"$n".tif || exit 1
            compare_rasters.py $specific_ref_dir_fp/enogeo"$a_slope_arg".tif $temp_dir/enogeo"$a_slope_arg"_"$p"_"$n".tif || exit 1

            specific_ref_dir=gridtypes
            specific_ref_dir_fp=$reference_dir/$specific_ref_dir
            echo -e "\nmpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/loganfel1.bin -$a_angle_arg $temp_dir/bil"$a_angle_arg"_"$p"_"$n".bil -$a_slope_arg $temp_dir/bin"$a_slope_arg"_"$p"_"$n".bin"
            mpiexec -n "$n" "$a" -fel $specific_ref_dir_fp/loganfel1.bin -$a_angle_arg $temp_dir/bil"$a_angle_arg"_"$p"_"$n".bil -$a_slope_arg $temp_dir/bin"$a_slope_arg"_"$p"_"$n".bin
            compare_rasters.py $specific_ref_dir_fp/bil"$a_angle_arg".bil $temp_dir/bil"$a_angle_arg"_"$p"_"$n".bil || exit 1
            compare_rasters.py $specific_ref_dir_fp/bin"$a_slope_arg".bin $temp_dir/bin"$a_slope_arg"_"$p"_"$n".bin || exit 1

        done
    done
    counter_a=0
done
