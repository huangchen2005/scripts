drop procedure add_partition_day;
delimiter $$
CREATE PROCEDURE add_partition_day()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare diff int default 0;
	declare diffenence int default 0;
	declare now_month varchar(255) default "";
	declare now_year varchar(255) default "";
	
	declare max_day_will varchar(255) default "";
	declare max_day_now varchar(255) default "";
	declare tmp_month varchar(255) default "";
	declare tmp_month_before varchar(255) default "";
	declare tmp_month_value varchar(255) default "";
	declare tmp_year varchar(255) default "";
	declare tmp_quarter varchar(255) default "";

	declare difference int default 0;
	declare i int default 1;

	declare alter_sql varchar(255) default "";

	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition_day;
	declare continue handler for not found set done = 1;


	set @tmp_sql = concat("select  month(now()) into @now_month");
        prepare stmt from @tmp_sql;
        execute stmt;
        set @tmp_sql = concat("select  year(now()) into @now_year");
        prepare stmt from @tmp_sql;
        execute stmt;

        if @now_month >= 1 and @now_month < 4 then
                set @tmp_day=concat(@now_year,'0101');
        elseif @now_month >=4 and @now_month < 7 then
                set @tmp_day=concat(@now_year,'0401');
        elseif @now_month >=7 and @now_month < 10 then
                set @tmp_day=concat(@this_year,'0701');
        elseif @now_month >=10 and @now_month <=12 then
                set @tmp_day=concat(@now_year,'1001');
        else
                insert into test_sql values(now(),'month error');

        end if;


	set @tmp_sql = concat("select date_format(date_add(",@tmp_day,",interval 9 month), '%Y%m%d') into @max_day_will");
        prepare stmt from @tmp_sql;
        execute stmt;


	open myCursor;
	myLoop:LOOP
		fetch myCursor into table_name;
		if done = 1 then
		leave myLoop;
		end if;
	
		set @tmp_sql = concat("select nl_to_date(max(PARTITION_DESCRIPTION+0)) from INFORMATION_SCHEMA.partitions WHERE TABLE_NAME = '",table_name,"' and  TABLE_SCHEMA ='lens_mobapp_data'  into @max_day_now");
		prepare stmt from @tmp_sql;
		execute stmt;
		
		set @tmp_sql = concat("select (year('",@max_day_will,"')*12 + month('",@max_day_will,"') - year('",@max_day_now,"')*12 - month('",@max_day_now,"')) div 3 into @difference");
		prepare stmt from @tmp_sql;
		execute stmt;



		while i <= @difference do

		       	set @tmp_sql = concat("select date_format(date_add('",@max_day_now,"' ,interval 3*",i," month), '%Y%m%d') into @tmp_month");
			prepare stmt from @tmp_sql;
			execute stmt;

		       	set @tmp_sql = concat("select nl_to_timestamp('",@tmp_month,"')  into @tmp_month_value");
			prepare stmt from @tmp_sql;
			execute stmt;



		       	set @tmp_sql = concat("select date_format(date_add('",@tmp_month,"' ,interval -1 day), '%Y%m%d') into @tmp_month_before");
			prepare stmt from @tmp_sql;
			execute stmt;

	       		set @tmp_sql = concat("select quarter('",@tmp_month_before,"') into @tmp_quarter");
               		prepare stmt from @tmp_sql;
                	execute stmt;
                	set @tmp_sql = concat("select year('",@tmp_month_before,"') into @tmp_year");
                	prepare stmt from @tmp_sql;
                	execute stmt;



                       	set @par_name = concat("par_",@tmp_year,"q",@tmp_quarter);


		       	set @alter_sql = concat("alter table ",table_name," add partition(partition ",@par_name," values less than (",@tmp_month_value,"))");

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


drop procedure del_partition_day;
delimiter $$
CREATE PROCEDURE del_partition_day()
BEGIN
	declare table_name varchar(255) default 0;
	declare tmp_sql varchar(255) default "";
	declare max_par_now varchar(255) default "";
	declare par_del_num varchar(255) default "";
	declare par_del varchar(255) default "";
	declare alter_sql varchar(255) default "";
	declare i int default 0;


	declare done int default -1;
	declare myCursor cursor for select tb_name from op_tb_partition_day;
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
		set @par_del_num = @max_par_now-8-3;

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

drop event manager_partition_day;
delimiter $$
create EVENT if not exists manager_partition_day
ON SCHEDULE EVERY 3 month STARTS '2013-10-01 00:30:00'
ON COMPLETION PRESERVE ENABLE
DO
BEGIN
call add_partition_day;
call del_partition_day;
END
$$
delimiter ;
