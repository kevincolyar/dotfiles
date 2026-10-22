# OMP

## Per Machine Config

Per-machine omp settings: omp/.omp/agent/config.<short-hostname>.yml, layered
 over the shared ~/.omp/agent/config.yml. Guarded because most hosts have no
 such file and omp hard-errors on a PI_CONFIG_FILES path that does not exist.

This is accomplished in ~/.zshrc
