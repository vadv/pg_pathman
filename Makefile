# contrib/pg_pathman/Makefile

MODULE_big = pg_pathman
OBJS = src/init.o src/relation_info.o src/utils.o src/partition_filter.o src/runtimeappend.o \
	src/runtime_merge_append.o src/pg_pathman.o src/dsm_array.o src/rangeset.o src/pl_funcs.o \
	src/pathman_workers.o src/hooks.o src/nodes_common.o src/xact_handling.o $(WIN32RES)

EXTENSION = pg_pathman
EXTVERSION = 1.0_rc1
DATA_built = $(EXTENSION)--$(EXTVERSION).sql
PGFILEDESC = "pg_pathman - partitioning tool"

REGRESS = pg_pathman
EXTRA_REGRESS_OPTS=--temp-config=$(top_srcdir)/$(subdir)/conf.add
EXTRA_CLEAN = $(EXTENSION)--$(EXTVERSION).sql ./isolation_output

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/pg_pathman
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

$(EXTENSION)--$(EXTVERSION).sql: init.sql hash.sql range.sql
	cat $^ > $@

ISOLATIONCHECKS=insert_nodes for_update rollback_on_create_partitions

submake-isolation:
	$(MAKE) -C $(top_builddir)/src/test/isolation all

isolationcheck: | submake-isolation
	$(MKDIR_P) isolation_output
	$(pg_isolation_regress_check) \
		--temp-config=$(top_srcdir)/$(subdir)/conf.add \
		--outputdir=./isolation_output \
		$(ISOLATIONCHECKS)
