use EIP
GO
select distinct MEMP_Employee_ID as Psno, memp_name as Name,MCADR_Description                               
from sqlmas.gen_m_users ,                                 
lnt.dbo.job_master j, eip.sqlmas.GEN_M_Employees, lnt.dbo.sector_master s  , sqlmas.gen_m_cadres                           
where  memp_cadre_code =MCADR_Cadre_Code and MCADR_Company_Code=MEMP_Company_Code
                       
and muser_company_code=memp_company_code                          
---and muser_isactive='N'  
--and MEMP_Employee_ID IN ('82768')
and MEMP_Employee_ID in ('82768','163941','242900','14969','20036375','20106031','20039643','173463','242791','136671','20144663','10004553','10006901','81773','20053537','20023068','20114058','20047574','20020116','163434','20047781','87486','20021480','138176','164235','20042029','15097','444271','242951','20138213','20107687','20036570','243900','20144512','10004541','20020510','20123643','174240','82714','20064405','10007071','20029735','10054515','243391','20045396','198611','444321','196533','14544','196714','10007043','20131196','20144815','84962','20051411','20032731','13590','20038817','138475','173696','444269','20063609','20053712','20054244','20047379','444096','10004074','20146582','137200','20041029','20102310','20039997','20061145','20051834','10052178','20073844','20059894','20054814','20067793','13895','444098','20027936','198024','20043499','20061236','10006130','198687','11621','20104087','20133206','137765','20120817','196628','20043370','198848','20148671','196606','83553','15907','20103232','10007277','137488','20019285','20038664','198164','10005598','20131905','80279','20048266','80653','10005643','197289','244072','10007925','20038554','444321','20141921','20030628','196357','20044170','184776','20030036','12479','20032719','138302','20051708','20148117','20131196','20046484','20035944','20024989','20033092','20133206','20143963','163358','20033328','163358','20033328','20102153','20068151','20073196','20092396','164182','243280','10054196','20058405','20041854','163763','20059419','20028574','20046324','10054157','20112519','20039564','243235','20056672','198973','10006457','20046754','20038263','20032049','20048116','84388','20138851','20023655','20038923','66201','10013051','164388','444411','20046783','20141031','10052642','20041936','10005544','20026080','10004024','137227','20102919','174815','197509','20084503','20024523','20063046','10006739','20033362','20030636','10004589','20031392','84526','83922','20032248','20106383','87797','20033376','20044487','20043381','20032391','84601','137993','20143430','173703','20117224','15367','20054590','10006556','20120013','20030987','20094984','20020555','82044','173874','196817','20037374','20041209','20022752','20022074','20035899','10005814','20033358','14110','20047768','20024609','20023475','10052562','20021108','242721','20022272','173799','83026','10007762','20107009','10052338','243411','10054812','20045393','20061426','20115348','10052375','20035889','80368','137487','20081353','197725','10006549','20050757','10005201','242175','83308','10005613','20028619','20124672','10009001','20146771','20050031','20059153','174429','20113641','20144258','10054528','10052688','138543','20128291','20067363','20032306','244636','20031065','84970','10005961','20051592','84454','20049135','197781','10005459','20096147','10007665','20076347','20045597','20072935','20073370','20058472','87952','20074035','164549','10004061','174197','20149180','173313','20120049','10007498','242475','20073839','136540','20092511','174217','184614','196943','198396','10054710','20068490','20102960','20035752','20140202','164836','197151','20039960','20130883','20063760','20120075','20078946','20064931','15841','20104303','20105488','80988','20152686','244741','10004152','20047245','20148128','20047542','20060918','20044389','20125270','20108279','20056192','13765','20046274','10054512','242435','10009466','164921','20037023','10054395','20058906','20053512','196920','20022332','10007829','80030','20088137','10054723','20027597','10005553','10005727','10054019','20064546','20034963','20035695','10054398','244762','138305','20023058','20036490','196736','87817','163389','244604','20124672','20070942','173618','20053242','197732','10004676','243760','20131195','242101','20093718','20017834','20120693','242666','20062767','20050804','242805','242530','20073184','444087','10054179','10052618','10005299','10005953','20034417','10005601','243719','137175','10006211','20038698','13151','20023952','20026725','173107','20128149','10052323','10007186','20064166','20120013','137343','20117221','200837','20051192','20145967','20038343','83231','444452','20025512','198238','164947','197244','20049986','20027617','10007149','10005753','14993','20026076','10005776','84471','20047758','20036300','15066','10005818','20050390','20153474','20073697','20048536','10007174','20074044','138866','20017593','20058764','20038241','10006964','164933','20073348','244898','173134','20140221','10052250','10006307','20029048','196549','10005413','20046487','20090524','20065631','20065592','20054324','80445','20022101','20044552','198058','10009320','10004037','20008532','13661','20027160','10054046','10007576','20011431','87964','20048561','85596','20114052','20020490','20116316','20030644','20073727','15367','173653','20050826','20098926','20043543','244978','20036763')
--AND LUJFR_Job_Code='QGMAP013'
                   
order by s.short_description,memp_name  


select *from eip.sqlmas.gen_m_cadres

select *from  eip.sqlmas.GEN_M_Employees

select *From eip.sqlmas.GEN_M_Functional_Roles