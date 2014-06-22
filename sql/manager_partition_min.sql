drop procedure add_partition_min;
delimiter $$
CREATE PROCEDURE add_partition_min()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare max_day_now varchar(255) default "";
	declare max_day_will varchar(255) default "";
	declare difference int default 0;
	declare i int default 1;
	declare tmp_day varchar(255) default "";
	declare tmp_day_value varchar(255) default "";
	declare par_name varchar(255) default "";
	declare alter_sql varchar(255) default "";

	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition;
	declare continue handler for not found set done = 1;


	set @tmp_sql = concat("select date_format(date_add(now(),interval 6 day), '%Y%m%d') into @max_day_will");
	prepare stmt from @tmp_sql;
	execute stmt;

	open myCursor;
	myLoop:LOOP
		fetch myCursor into table_name;
		if done = 1 then
		leave myLoop;
		end if;
	
		set @tmp_sql = concat("SELECT max(substring(partition_name,5)) FROM INFORMATION_SCHEMA.partitions WHERE TABLE_NAME = '",table_name,"' and  TABLE_SCHEMA ='lens_mobapp_data'  into @max_day_now");
		prepare stmt from @tmp_sql;
		execute stmt;


		set @tmp_sql = concat("select to_days('",@max_day_will,"') - to_days('",@max_day_now,"') into @difference");
		prepare stmt from @tmp_sql;
		execute stmt;

		
		while i <= @difference do
		       	set @tmp_sql = concat("select date_format(date_add('",@max_day_now,"' ,interval ",i," day), '%Y%m%d') into @tmp_day");
			prepare stmt from @tmp_sql;
			execute stmt;

		       	set @tmp_sql = concat("select nl_to_timestamp(date_format(date_add('",@max_day_now,"' ,interval 1+",i," day), '%Y%m%d')) into @tmp_day_value");
			prepare stmt from @tmp_sql;
			execute stmt;

			set @par_name = concat("par_",@tmp_day);

		       	set @alter_sql = concat("alter table ",table_name," add partition(partition ",@par_name," values less than (",@tmp_day_value,"))");


			insert into test_sql values( now(),  @alter_sql);
			prepare stmt from @alter_sql;
			execute stmt;

	                set i = i+1;
		end while;
		set i = 1;


	end loop myLoop;

	close myCursor;

END;
$$
delimiter ;

drop procedure del_partition_min;
delimiter $$
CREATE PROCEDURE del_partition_min()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare max_par_now varchar(255) default "";
	declare par_del_num varchar(255) default "";
	declare par_del varchar(255) default "";
	declare alter_sql varchar(255) default "";
	declare i int default 0;


	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition;
	declare continue handler for not found set done = 1;

	open myCursor;
	myLoop:LOOP
		fetch myCursor into table_name;
		if done = 1 then
		leave myLoop;
		end if;
	
		set @tmp_sql = concat("select count(*) FROM INFORMATION_SCHEMA.partitions WHERE TABLE_NAME = '",table_name,"' and  TABLE_SCHEMA ='lens_mobapp_data'  into @max_par_now");
		prepare stmt from @tmp_sql;
		execute stmt;
		set @par_del_num = @max_par_now-31-7;

		while i < @par_del_num do
		       	set @tmp_sql = concat("select partition_name from  INFORMATION_SCHEMA.partitions  where TABLE_SCHEMA ='lens_mobapp_data' and table_name='",table_name,"' order by partition_name limit 1 into @par_del");
			prepare stmt from @tmp_sql;
			execute stmt;
		       	set @alter_sql = concat("alter table ",table_name," drop partition ",@par_del);
			prepare stmt from @alter_sql;
			execute stmt;

			insert into test_sql values(now(),concat(i,"--",@par_del,"--",@alter_sql));
	                set i = i+1;
		end while;
		set i = 0;

	end loop myLoop;

	close myCursor;

END;
$$
delimiter ;

drop event manager_partition_min;
delimiter $$
create EVENT if not exists manager_partition_min
ON SCHEDULE EVERY 1 day STARTS '2013-12-24 00:30:00'
ON COMPLETION PRESERVE ENABLE
DO
BEGIN
call add_partition_min;
call del_partition_min;
END
$$
delimiter ;
