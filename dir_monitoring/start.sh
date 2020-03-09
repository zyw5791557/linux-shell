#!/bin/bash

shell_dir=/work/dir_monitoring/

sh ${shell_dir}index.sh ${shell_dir}config.ini  > ${shell_dir}output.log 2>&1
