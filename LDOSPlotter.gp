set xlabel 'Lambda'
set ylabel 'LDOS enhancement'

plot 'Bowtie35_Fine.LDOS' u (2*pi/$4):6 t 'LDOS, D=35 nm' w lp pt 7 ps 1 \
   , 'Bowtie65_Fine.LDOS' u (2*pi/$4):6 t 'LDOS, D=65 nm' w lp pt 7 ps 1 \
   , 'Bowtie95_Fine.LDOS' u (2*pi/$4):6 t 'LDOS, D=95 nm' w lp pt 7 ps 1
