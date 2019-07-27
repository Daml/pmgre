SHAPES=data/2017_T4_ZAPM.shp data/2018_T1_ZAPM.shp data/2018_T2_ZAPM.shp data/2018_T3_ZAPM.shp data/2018_T4_ZAPM.shp data/2019_T1_ZAPM.shp

all: $(SHAPES) data/osm.csv data/zapm.png

data/osm.csv: query.xml
	mkdir -p $(@D)
	curl -s -o $@ -X POST -d @$< https://overpass-api.de/api/interpreter

data/zapm.png: zapm.gp data/zapm.dat
	mkdir -p $(@D)
	gnuplot zapm.gp > $@

data/zapm.dat: $(SHAPES:.shp=.csv)
	mkdir -p $(@D)
	python zapm.py $? > data/ZAPM.dat

data/%.csv: data/%.shp
	mkdir -p $(@D)
	ogr2ogr -lco STRING_QUOTING=IF_NEEDED -dialect sqlite -f "CSV" -sql "SELECT REPLACE(REPLACE(CodeOI,'FRTE','FI'),'ISER', 'IF') AS CID,COUNT(*) AS NBPM,COALESCE(SUM(lgtZAPM),0) AS NBLOC, SUM(lgtMadPM) AS NBRAC FROM '$(basename $(@F))' WHERE INSEE_DEP='38' GROUP BY CodeOI" $@ $<

# Extract SHP bruts
# -----------------

tmp/%.shp: refs/%.zip
	mkdir -p $(@D)
	unzip -d $(@D) $<
	touch $@

tmp/%.shp: refs/%.7z
	mkdir -p $(@D)
	7z e -o$(@D) $<
	touch $@

# Extract SHP clean
# -----------------

data/2017_T4_ZAPM.shp: tmp/2017T4_ZAPM_OD.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

data/2018_T1_ZAPM.shp: tmp/2018T1_ZAPM_OD.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

data/2018_T2_ZAPM.shp: tmp/2018T2_zapm_od.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

data/2018_T3_ZAPM.shp: tmp/2018_T3_zapm_dep_V6.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

data/2018_T4_ZAPM.shp: tmp/zapm_T4_dep_V10.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

data/2019_T1_ZAPM.shp: tmp/2019T1_ZAPM.shp
	mkdir -p $(@D)
	ogr2ogr -f "ESRI Shapefile" -where "INSEE_DEP='38'" $@ $<

# Downloads
# ---------

refs/2017T4_ZAPM_OD.zip:
	mkdir -p $(@D)
	curl -o $@ https://www.data.gouv.fr/s/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20180607-184721/2017T4_ZAPM_OD.zip

refs/2018T1_ZAPM_OD.zip:
	mkdir -p $(@D)
	curl -o $@ https://www.data.gouv.fr/s/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20180607-184623/2018T1_ZAPM_OD.zip

refs/2018T2_zapm_od.7z:
	mkdir -p $(@D)
	curl -o $@ https://static.data.gouv.fr/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20180918-115753/2018t2-zapm-od.7z

refs/2018_T3_zapm_dep_V6.zip:
	mkdir -p $(@D)
	curl -o $@ https://static.data.gouv.fr/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20190305-190551/2018-t3-zapm-dep-v6.zip

refs/zapm_T4_dep_V10.zip:
	mkdir -p $(@D)
	curl -o $@ https://static.data.gouv.fr/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20190305-190428/zapm-t4-dep-v10.zip

refs/2019T1_ZAPM.zip:
	mkdir -p $(@D)
	curl -o $@ https://static.data.gouv.fr/resources/le-marche-du-haut-et-tres-haut-debit-fixe-deploiements/20190625-124056/2019t1-zapm.zip

# Phony stuffs
# ------------

clean:
	rm -rf tmp

purge: clean
	rm -rf data

.PHONY: clean purge
