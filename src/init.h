/* ------------------------------------------------------------------------
 *
 * init.h
 *		Initialization functions
 *
 * Copyright (c) 2015-2016, Postgres Professional
 *
 * ------------------------------------------------------------------------
 */

#ifndef PATHMAN_INIT_H
#define PATHMAN_INIT_H

#include "relation_info.h"

#include "postgres.h"
#include "storage/lmgr.h"
#include "utils/snapshot.h"
#include "utils/hsearch.h"


extern HTAB	   *partitioned_rels;
extern HTAB	   *parent_cache;
extern bool		initialization_needed;


Size estimate_pathman_shmem_size(void);
void init_shmem_config(void);
bool load_config(void);
void unload_config(void);
Size get_worker_slots_size(void);
void create_worker_slots(void);

void fill_prel_with_partitions(const Oid *partitions,
							   const uint32 parts_count,
							   PartRelationInfo *prel);

Oid *find_inheritance_children_array(Oid parentrelId,
									 LOCKMODE lockmode,
									 uint32 *size);

char *build_check_constraint_name_internal(Oid relid,
										   AttrNumber attno);

bool pathman_config_contains_relation(Oid relid,
									  Datum *values,
									  bool *isnull,
									  TransactionId *xmin);

bool read_pathman_params(Oid relid,
						 Datum *values,
						 bool *isnull);

#endif
