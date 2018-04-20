SELECT COUNT(*)
  FROM [IA_Reporting].[dbo].[20180418_GitLab]

  --306138


    select count(distinct Project) from [IA_Reporting].[dbo].[20180418_GitLab]
	--1341
	--1323 with 20180410

	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add email_prefix varchar(100)

  --grab the prefix from the email - anything before @ sign
  update [IA_Reporting].[dbo].[20180418_GitLab]
  set email_prefix = left(email, charindex('@', email))

  --get rid of @ sign in the field
  update [IA_Reporting].[dbo].[20180418_GitLab]
  set email_prefix = REPLACE(email_prefix, '@','')

  SELECT TOP 100 * FROM [IA_Reporting].[dbo].[20180418_GitLab]

	
	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add match varchar(1)

	--add supervisor and final employee name and LANID
	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add supervisor varchar(100)
	,empname varchar(100)
	,LANID varchar(4)

	--now do the matching only on email prefixes that are only 4 characters long, which most of them are LANIDs to filtered engineers table
	update A
	set a.match = 'Y',
	a.empname= b.empname,
	a.supervisor = b.[SupervisorName ],
	a.LANID = b.AeiInformation1
	from [IA_Reporting].[dbo].[20180418_GitLab] a 
	inner join [IA_Reporting].[dbo].[OS_FEB_2018_EE_Engineers] b on 
	a.email_prefix = b.AeiInformation1
	where LEN(email_prefix) = 4
	--15336

	--same thing here but matching to contractors list and on records that do not have anymore matches
	update A
	set a.match = 'Y',
	a.empname= b.FULL_NAME,
	a.supervisor = b.[SUPERVISOR_NAME],
	a.LANID = b.[LAN_ID]
	from [IA_Reporting].[dbo].[20180418_GitLab] a inner join [IA_Reporting].[dbo].[OS_FEB_2018_CWK_engineers] b on 
	a.email_prefix =b.LAN_ID	
	where isnull(a.match,'') <>'Y'
	and LEN(email_prefix) = 4
	--2936

	SELECT TOP 100 * FROM [IA_Reporting].[dbo].[20180418_GitLab]

		--how many did we update?
	select count(*) from [IA_Reporting].[dbo].[20180418_GitLab]
	 where isnull(match,'') = 'Y'
	 --18272out of 306138 - ~6%

	 --check if it makes sense
	select distinct name, empname, email from 	[IA_Reporting].[dbo].[20180418_GitLab]
	where match = 'Y'

	--how many unique names we don't have matched
	select distinct name from [IA_Reporting].[dbo].[20180418_GitLab]
	where isnull(match,'') <> 'Y'
	order by name
	--3848 not matched

	-- some lanIDs in the name field
	select distinct name from [IA_Reporting].[dbo].[20180418_GitLab]
	where isnull(match,'') <> 'Y' and len(name) = 4
	order by name
	--121

		--match 4 character names to lanID in FTE list
	update A
	set a.match = 'Y',
	a.empname= b.empname,
	a.supervisor = b.[SupervisorName ],
	a.lanID = b.AeiInformation1
	from [IA_Reporting].[dbo].[20180418_GitLab] a inner join [IA_Reporting].[dbo].[OS_FEB_2018_EE_Engineers] b on 
	a.name = b.AeiInformation1
	where isnull(a.match,'') <>'Y' and len(name) = 4
	--4470

	select distinct name, empname from [IA_Reporting].[dbo].[20180418_GitLab]
	where match = 'Y'
	--251

	select distinct email_prefix from [IA_Reporting].[dbo].[20180418_GitLab]
	where isnull(match,'') <>'Y'
	--3498

	--match 4 character names to lanID in contractors list
	update A
	set a.match = 'Y',
	a.empname= b.FULL_NAME,
	a.supervisor = b.[SUPERVISOR_NAME],
	a.lanid = b.[LAN_ID]
	from [IA_Reporting].[dbo].[20180418_GitLab] a inner join 	[IA_Reporting].[dbo].[OS_FEB_2018_CWK_engineers] b on 
	a.name =b.LAN_ID	
	where isnull(a.match,'') <>'Y' and len(name) = 4
	--314
	

	select distinct name from [IA_Reporting].[dbo].[20180418_GitLab]
	where isnull(match,'') <> 'Y'
	order by name
	--3681 after Removed special charater


	SELECT x.* INTO  [IA_Reporting].[dbo].[Employees_Contractors_Feb2018]
	FROM(
	SELECT EmpName,AeiInformation1,[SupervisorName ] FROM [IA_Reporting].[dbo].[OS_FEB_2018_EE_Engineers]
	UNION ALL
	SELECT FULL_NAME,LAN_ID,[SUPERVISOR_NAME] FROM [IA_Reporting].[dbo].[OS_FEB_2018_CWK_engineers])x
	--2330


	----did the fuzzymatch on names and used that table
	
	UPdate A
	set a.match = 'Y',
	a.empname= b.Column1,
	a.supervisor = b.[Supervisor],
	a.LANID = b.Column2
		from [IA_Reporting].[dbo].[20180418_GitLab] a inner join 
	[dbo].[FuzzyMatch_20180418] b
	on a.Name = b.NAME
	where isnull(match,'') <> 'Y'
	--140928 


	

	--how many records do we have not matched
	select count(*) from [IA_Reporting].[dbo].[20180418_GitLab] 
	where isnull(match,'') <> 'Y'
	--142154 out of 306138

	
 SELECT DISTINCT NAME  FROM [IA_Reporting].[dbo].[20180418_GitLab] 
 where isnull(match,'') <> 'Y'
 --4011 total Names including special charaters
 --2917 not matched names out of 4011


 --create a date field so we can chronologically order it 
	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add [date] varchar(11)
	--create a date field so we can chronologically order it 
	update [IA_Reporting].[dbo].[20180418_GitLab]
	set date = cast([day]as varchar)+' '+cast([month] as varchar)+' '+cast([year] as varchar)
	
	--create a date field so we can chronologically order it 
	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	alter column [date] date 
	
	--look at the latest date for each path
	select project, max(date) from [IA_Reporting].[dbo].[20180418_GitLab]
	group by project
	order by max(date)
	--2018-03-24

	--add a field to indicate which paths are too old to look at anything less than 4/15
	alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add older varchar(1)

	--look at the latest date per path and figure out what paths are older than a year
	with CTE as
	(select path, date, older, row_number() over(partition by path order by date desc) as rownum  from [IA_Reporting].[dbo].[20180418_GitLab])
	
	select * from  CTE
	where rownum =1 and date <'2017-04-16'
	--62  paths have oldest date more than a year ago

	with CTE as
	(select path, date, older, row_number() over(partition by path order by date desc) as rownum  from [IA_Reporting].[dbo].[20180418_GitLab])
	
	update CTE
	set older = 'Y' 
	where rownum =1 and date <'2017-04-16'
	--62 paths set to older

	-- now to update all records with those path to be older
	update [IA_Reporting].[dbo].[20180418_GitLab]
	set older = 'Y'
	where isnull(older,'') = '' and path in 
	(select path from [IA_Reporting].[dbo].[20180418_GitLab] where older = 'Y')
	--2226 row(s) affected)

	--check
	select count(distinct path) from [IA_Reporting].[dbo].[20180418_GitLab]
	where older = 'Y'
	--62

	--how many records do we have that will have a name and not old?
	select count(*) from  [IA_Reporting].[dbo].[20180418_GitLab]
	where match = 'Y' and isnull(older,'') <> 'Y'
	--162768
	

	--how many don't have name match or too old?
	select count(*) from  [IA_Reporting].[dbo].[20180418_GitLab]
	where isnull(match,'') <> 'Y' or isnull(older,'') = 'Y'
	---143370

	SELECT 162768+143370 --306138


	---Updated Anna's table [OS_senior_leader] by adding 4 more records

	SELECT COUNT(*) FROM  [IA_Reporting].[dbo].[20180418_GitLab] a
	inner join [IA_Reporting].[dbo].[OS_senior_leader] b on a.supervisor = b.supervisor
	WHERE match = 'Y' and isnull(older,'') <> 'Y';

	SELECT DISTINCT supervisor,empname,lanid FROM  [IA_Reporting].[dbo].[20180418_GitLab]
	WHERE supervisor not in (SELECT DISTINCT supervisor from [IA_Reporting].[dbo].[OS_senior_leader])
	--Smith David Wong Karen


	UPDATE [IA_Reporting].[dbo].[20180418_GitLab]
	SET Senior_Leader ='Radtke, Herman James III'
	WHERE Senior_Leader ='Radtke III, Herman'

	INSERT INTO [dbo].[OS_senior_leader]
	(supervisor,Senior_Leader)
	VALUES
	('Oldham, Katie','Gill, Brian')



	 alter table [IA_Reporting].[dbo].[20180418_GitLab]
	 add Senior_leader varchar(100)

	 update A
	 set 
	 a.Senior_Leader = b.Senior_leader 
	 from [IA_Reporting].[dbo].[20180418_GitLab] a inner join [IA_Reporting].[dbo].[OS_senior_leader] b on a.supervisor = b.supervisor
	 --184564

	 	--Get the latest update date for each path
	Alter table [IA_Reporting].[dbo].[20180418_GitLab]
	add recent_update_date date

	--updating each path with the most recent date
	--CTE created to rank the dates from newest to oldest, picking the row1 to grab the newest date
	with CTE as
	(select path, date, row_number() over(partition by path order by date desc) as rownum  from [IA_Reporting].[dbo].[20180418_GitLab])
	update A
	set a.recent_update_date =cte.date
	from [IA_Reporting].[dbo].[20180418_GitLab] a inner join cte on a.path =cte.path
	where rownum = 1

	--(306138 row(s) affected)


	 select project, path, senior_leader,recent_update_date, projectsize,
	 count(*) CNT 
	 from [IA_Reporting].[dbo].[20180418_GitLab]
	 where  isnull(older,'')<>'Y' 
	 group by project, path, senior_leader,recent_update_date,projectsize,older
	 order by project, path, senior_leader,recent_update_date



	  select project, path, senior_leader, recent_update_date,projectsize,count(*) CNT from [IA_Reporting].[dbo].[20180418_GitLab]
	 where Senior_leader is null and isnull(older,'')<>'Y' and path not in 
	 ( select distinct path from [IA_Reporting].[dbo].[20180418_GitLab] where senior_leader is not NULL)
	 group by project, path, senior_leader,recent_update_date,projectsize
	 order by project, path, senior_leader


	

SELECT DISTINCT Project FROM [IA_Reporting].[dbo].[20180418_GitLab]
where  isnull(older,'')<>'Y' 
--1282
--1341 total projects


SELECT MAX(recent_update_date) from [IA_Reporting].[dbo].[20180418_GitLab]
	 where  isnull(older,'')<>'Y' 