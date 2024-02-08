-- Monitor Resource semphores

Use Tempdb
go

SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
GO

SET NOCOUNT ON

DECLARE @runtime datetime
DECLARE @lastruntime datetime
SET @lastruntime = '19000101'

declare @waitercount_regular int
declare @waitercount_small int
set @waitercount_regular=0
set @waitercount_small = 0

while (1=1)
begin
	select @waitercount_regular = waiter_count from sys.dm_exec_query_resource_semaphores where resource_semaphore_id =0
	select @waitercount_small = waiter_count from sys.dm_exec_query_resource_semaphores where resource_semaphore_id =1

	if (@waitercount_regular<>0 or @waitercount_small <>0 )
	begin
	SET @runtime = GETDATE()
	PRINT ''
	PRINT 'Start time: ' + CONVERT (varchar (50), GETDATE(), 121)
	PRINT ''
	
	  RAISERROR ('-- dm_exec_query_resource_semaphores --', 0, 1) WITH NOWAIT;
	  SELECT CONVERT (varchar(30), @runtime, 121) as runtime,resource_semaphore_id,target_memory_kb,total_memory_kb,available_memory_kb,
	   granted_memory_kb,used_memory_kb,grantee_count,waiter_count,timeout_error_count
	   from sys.dm_exec_query_resource_semaphores

	  PRINT ''
	  RAISERROR ('-- dm_exec_query_memory_grants --', 0, 1) WITH NOWAIT;
	  SELECT CONVERT (varchar(30), @runtime, 121) as runtime , session_id,scheduler_id,DOP,request_time,grant_time,
	  requested_memory_kb,granted_memory_kb,used_memory_kb,timeout_sec,query_cost,timeout_sec,resource_semaphore_id,wait_order,is_next_candidate,
	  wait_time_ms,
		REPLACE (REPLACE (cast(s2.text as varchar(4000)), CHAR(10), ' '), CHAR(13), ' ')  AS sql_statement
	  from sys.dm_exec_query_memory_grants 
	  CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2 
	 waitfor delay '0:00:10'
end
waitfor delay '0:00:15'
set @waitercount_regular=0
set @waitercount_small = 0

end
