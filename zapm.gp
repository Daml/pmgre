set terminal png size 800,1000
set multiplot layout 2, 1
set grid

set xdata time
set timefmt "%Y-%m-%d"
set xtics format "%b %Y"
set xtics "2017-07-01", 3*2629746, "2030-12-31"
set xtic rotate by -45 scale 0
set ytic rotate by -45 scale 0

set title "Logements raccordables"
plot 'data/zapm.dat' using 1:4 with lines lt 1 lw 2 title "ZTD", \
    '' using 1:7 with lines lw 2 lt rgb "#FF6D00" title "Orange",\
    '' using 1:10 with lines lw 2 lt rgb "#0057AB" title "Isère Fibre"

set title "ZAPM"
plot 'data/zapm.dat' using 1:2 with lines lt 1 lw 2 title "ZTD", \
    '' using 1:5 with lines lw 2 lt rgb "#FF6D00" title "Orange",\
    '' using 1:8 with lines lw 2 lt rgb "#0057AB" title "Isère Fibre"
