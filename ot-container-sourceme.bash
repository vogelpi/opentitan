# From /etc/profile.d/lowrisc-environment.sh
export SNPSLMD_LICENSE_FILE=27020@license.servers.lowrisc.org
export MODULEPATH=/nas/lowrisc/tools/modulefiles
export XILINXD_LICENSE_FILE=2100@license.servers.lowrisc.org
export CDS_LIC_FILE=5280@license.servers.lowrisc.org
# Init environment modules
source /usr/share/modules/init/bash
module load synopsys/vcs/latest
module load cadence/xcelium/latest
module load cadence/vmanager/latest
module load xilinx/vivado/latest
cd /home/dev/src
