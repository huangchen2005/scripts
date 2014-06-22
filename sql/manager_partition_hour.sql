drop procedure add_partition_hour;
delimiter $$
CREATE PROCEDURE add_partition_hour()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare diff int default 0;
	declare diffenence int default 0;
	declare last_weekend varchar(255) default "";
	declare max_weekend_now varchar(255) default "";
	declare max_weekend_will varchar(255) default "";
	declare tmp_weekend varchar(255) default "";
	declare tmp_weekend_value varchar(255) default "";
	declare tmp_weekend_before varchar(255) default "";
	declare tmp_year varchar(255) default "";
	declare tmp_week varchar(255) default "";

	declare difference int default 0;
	declare i int default 1;

	declare alter_sql varchar(255) default "";

	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition_hour;
	declare continue handler for not found set done = 1;

	set @tmp_sql = concat("select  dayofweek(now())-1 into @diff");
        prepare stmt from @tmp_sql;
        execute stmt;
        set @tmp_sql = concat("select date_format(date_add(now(),interval -",@diff," day), '%Y%m%d') into @last_weekend");
        prepare stmt from @tmp_sql;
        execute stmt;
	set @tmp_sql = concat("select date_format(date_add('",@last_weekend,"' ,interval 7*3 day), '%Y%m%d') into @max_weekend_will");
        prepare stmt from @tmp_sql;
        execute stmt;


	open myCursor;
	myLoop:LOOP
		fetch myCursor into table_name;
		if done = 1 then
		leave myLoop;
		end if;
	
		set @tmp_sql = concat("select nl_to_date(max(PARTITION_DESCRIPTION+0)) from INFORMATION_SCHEMA.partitions WHERE TABLE_NAME = '",table_name,"' and  TABLE_SCHEMA ='lens_mobapp_data'  into @max_weekend_now");
		prepare stmt from @tmp_sql;
		execute stmt;
		

		set @tmp_sql = concat("select (to_days('",@max_weekend_will,"') - to_days('",@max_weekend_now,"')) div 7 into @difference");
		prepare stmt from @tmp_sql;
		execute stmt;

		
		while i <= @difference do

		       	set @tmp_sql = concat("select date_format(date_add('",@max_weekend_now,"' ,interval 7*",i," day), '%Y%m%d') into @tmp_weekend");
			prepare stmt from @tmp_sql;
			execute stmt;

		       	set @tmp_sql = concat("select nl_to_timestamp('",@tmp_weekend,"')  into @tmp_weekend_value");
			prepare stmt from @tmp_sql;
			execute stmt;

		       	set @tmp_sql = concat("select date_format(date_add('",@tmp_weekend,"' ,interval -1 day), '%Y%m%d') into @tmp_weekend_before");
			prepare stmt from @tmp_sql;
			execute stmt;

	       		set @tmp_sql = concat("select week('",@tmp_weekend_before,"',4) into @tmp_week");
               		prepare stmt from @tmp_sql;
                	execute stmt;
                	set @tmp_sql = concat("select year('",@tmp_weekend_before,"') into @tmp_year");
                	prepare stmt from @tmp_sql;
                	execute stmt;


		        if @tmp_week <10 then
                        	set @par_name = concat("par_",@tmp_year,"w0",@tmp_week);
                	else   
                        	set @par_name = concat("par_",@tmp_year,"w",@tmp_week);
                	end if;

		       	set @alter_sql = concat("alter table ",table_name," add partition(partition ",@par_name," values less than (",@tmp_weekend_value,"))");

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

drop procedure del_partition_hour;
delimiter $$
CREATE PROCEDURE del_partition_hour()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare max_par_now varchar(255) default "";
	declare par_del_num varchar(255) default "";
	declare par_del varchar(255) default "";
	declare alter_sql varchar(255) default "";
	declare i int default 0;


	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition_hour;
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
		set @par_del_num = @max_par_now-13-3;

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

drop event manager_partition_hour;
delimiter $$
create EVENT if not exists manager_partition_hour
ON SCHEDULE EVERY 1 week STARTS '2013-12-22 00:30:00'
ON COMPLETION PRESERVE ENABLE
DO
BEGIN
call add_partition_hour;
call del_partition_hour;
END
$$
delimiter ;
