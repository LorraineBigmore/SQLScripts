	

	while (1=1)
	begin
	select GETDATE()
	print '*********overall memory - sys.dm_os_memory_brokers***************'
	select type, name, memory_node_id, pages_kb/1024 as pages_MB
	from sys.dm_os_memory_clerks where type like '%xtp%'
	select * from sys.dm_os_memory_brokers where memory_broker_type='MEMORYBROKER_FOR_XTP'
	print '*********overall memory - dm_os_memory_objects***************'
	SELECT *    FROM sys.dm_os_memory_objects WHERE type LIKE '%xtp%' 
	
	print '*******index stats****************'
	select object_name(object_id),* from sys.dm_db_xtp_index_stats where object_id=object_id('****')
	SELECT 
	object_name(hs.object_id) AS 'object name', 
	i.name as 'index name', 
	hs.total_bucket_count,
	hs.empty_bucket_count,
	floor((cast(empty_bucket_count as float)/total_bucket_count) * 100) AS 'empty_bucket_percent',
	hs.avg_chain_length, 
	hs.max_chain_length
	FROM sys.dm_db_xtp_hash_index_stats AS hs 
	JOIN sys.indexes AS i 
	ON hs.object_id=i.object_id AND hs.index_id=i.index_id
	
	print '*******system memory - dm_xtp_system_memory_consumers****************'
	
	select * from sys.dm_xtp_system_memory_consumers
	select sum(allocated_bytes)/(1024*1024) as total_allocated_MB, sum(used_bytes)/(1024*1024) as total_used_MB from sys.dm_xtp_system_memory_consumers
	
	
	print '*******object memory - sys.dm_db_xtp_memory_consumers****************'
	select object_name(object_id),* from sys.dm_db_xtp_table_memory_stats
	select  convert(char(20), object_name(object_id)) as Name, * from sys.dm_db_xtp_memory_consumers
	
	print '*******GC stats****************'
	
	select * from sys.dm_xtp_gc_stats
	select * from sys.dm_xtp_gc_queue_stats order by current_queue_depth desc
	
	
	waitfor delay '00:05:00'
	End