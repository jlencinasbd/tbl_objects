DROP VIEW IF EXISTS tbl.business_accountteam_metrics_dim_organization_v CASCADE;

--create new view
CREATE VIEW tbl.business_accountteam_metrics_dim_organization_v AS

-- Insert select here

-- Get Managers to assign PEM's Managers to manage himself
WITH Managers as 
(
Select distinct so_layer_07_manager as ManagerName,'Level 7' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_06_manager as ManagerName,'Level 6' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_05_manager as ManagerName,'Level 5' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_04_manager as ManagerName,'Level 4' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_03_manager as ManagerName,'Level 3' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_02_manager as ManagerName,'Level 2' as ManagerLevel from ods.workday_supervisory_organization_v
UNION ALL 
Select distinct so_layer_01_manager as ManagerName,'Level 1' as ManagerLevel from ods.workday_supervisory_organization_v
)
,
Managers_PEM as
(
Select distinct b.pem_sfdc_id
,worker
,ManagerLevel
From emart.wef_dim_business_account_v b 
LEFT JOIN emart.wef_fact_service_contract_v sc on b.business_account_sfdc_id = sc.business_account_sfdc_id
LEFT JOIN ods.sfdc_user_v u on b.pem_sfdc_id = u.id
--LEFT JOIN enorm.wef_mdm_user_v u on b.pem_sfdc_id = u.user_sfdc_id
LEFT JOIN ods.workday_workers_v w on u.workday_employee_id = w.employee_id
INNER JOIN Managers m on m.ManagerName = w.worker
WHERE sc.active_flag = 'Yes'
)
,
Managers_SEM as
(
Select distinct b.sem_sfdc_id
,worker
,ManagerLevel
From emart.wef_dim_business_account_v b 
LEFT JOIN emart.wef_fact_service_contract_v sc on b.business_account_sfdc_id = sc.business_account_sfdc_id
LEFT JOIN ods.sfdc_user_v u on b.sem_sfdc_id = u.id
--LEFT JOIN enorm.wef_mdm_user_v u on b.pem_sfdc_id = u.user_sfdc_id
LEFT JOIN ods.workday_workers_v w on u.workday_employee_id = w.employee_id
INNER JOIN Managers m on m.ManagerName = w.worker
WHERE sc.active_flag = 'Yes'
)


Select 
t.*

,CASE mpem.ManagerLevel
WHEN 'Level 7' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+sopem.so_layer_03_manager
        +'-'+sopem.so_layer_04_manager+'-'+sopem.so_layer_05_manager+'-'+sopem.so_layer_06_manager+'-'+pem.first_name + ' ' + pem.last_name 
WHEN 'Level 6' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+sopem.so_layer_03_manager
        +'-'+sopem.so_layer_04_manager+'-'+sopem.so_layer_05_manager+'-'+pem.first_name + ' ' + pem.last_name 
WHEN 'Level 5' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+sopem.so_layer_03_manager
        +'-'+sopem.so_layer_04_manager+'-'+pem.first_name + ' ' + pem.last_name
WHEN 'Level 4' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+sopem.so_layer_03_manager
        +'-'+pem.first_name + ' ' + pem.last_name
WHEN 'Level 3' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+pem.first_name + ' ' + pem.last_name
WHEN 'Level 2' THEN 
sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+pem.first_name + ' ' + pem.last_name
WHEN 'Level 1' THEN 
sopem.so_layer_00_manager+'-'+pem.first_name + ' ' + pem.last_name
ELSE sopem.so_layer_00_manager+'-'+sopem.so_layer_01_manager+'-'+sopem.so_layer_02_manager+'-'+sopem.so_layer_03_manager
        +'-'+sopem.so_layer_04_manager+'-'+sopem.so_layer_05_manager+'-'+sopem.so_layer_06_manager+'-'+sopem.so_layer_07_manager
END as PEM_Management_Chain
,pem.first_name + ' ' + pem.last_name as PEM_Name
,pem.team as PEM_Team
,pem."Group" as PEM_Group


,CASE msem.ManagerLevel
WHEN 'Level 7' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sosem.so_layer_03_manager
        +'-'+sosem.so_layer_04_manager+'-'+sosem.so_layer_05_manager+'-'+sosem.so_layer_06_manager+'-'+sem.first_name + ' ' + sem.last_name 
WHEN 'Level 6' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sosem.so_layer_03_manager
        +'-'+sosem.so_layer_04_manager+'-'+sosem.so_layer_05_manager+'-'+sem.first_name + ' ' + sem.last_name 
WHEN 'Level 5' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sosem.so_layer_03_manager
        +'-'+sosem.so_layer_04_manager+'-'+sem.first_name + ' ' + sem.last_name
WHEN 'Level 4' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sosem.so_layer_03_manager
        +'-'+sem.first_name + ' ' + sem.last_name
WHEN 'Level 3' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sem.first_name + ' ' + sem.last_name
WHEN 'Level 2' THEN 
sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sem.first_name + ' ' + sem.last_name
WHEN 'Level 1' THEN 
sosem.so_layer_00_manager+'-'+sem.first_name + ' ' + sem.last_name
ELSE sosem.so_layer_00_manager+'-'+sosem.so_layer_01_manager+'-'+sosem.so_layer_02_manager+'-'+sosem.so_layer_03_manager
        +'-'+sosem.so_layer_04_manager+'-'+sosem.so_layer_05_manager+'-'+sosem.so_layer_06_manager+'-'+sosem.so_layer_07_manager
END as SEM_Management_Chain
,sem.first_name + ' ' + sem.last_name as SEM_Name
,sem.team as SEM_Team
,sem."Group" as SEM_Group

FROM
(
---------------------------------------------
--- Select all orgs with their PEM id's (table "t")
---------------------------------------------
Select 
--TOP 10
distinct b.business_account_sfdc_id
,b.business_account_hkey
,b.pem_sfdc_id as org_pem_sfdc_id
,upem.workday_employee_id as pem_workday_id 
-- START OLD LOGIC TO GET THE PEM WHEN THERE IS A LOSS
-- replaced by the logic to get the functional lead ,b.pem_sfdc_id 
--,case when pem.functional_lead_sfdc_id is null then b.pem_sfdc_id else 
--  case when pem.active_status_flag='false' then pem.functional_lead_sfdc_id else pem.prev_pem_sfdc_id end end   as org_pem_sfdc_id
-- not necessary for the DS,pem.functional_lead_sfdc_id as prev_pem_sfdc_id
-- END OLD LOGIC TO GET THE PEM WHEN THERE IS A LOSS
,usem.workday_employee_id as sem_workday_id 
,b.sem_sfdc_id
,b.name as organization_name
,b.active_status_flag
,r.org_region_cluster as Region_Cluster
,b.location_country 
,l.lookup_value as Industry_Cluster
, CASE WHEN CASE WHEN tlp.engaged_flag_partner = NULL THEN FALSE ELSE tlp.engaged_flag_partner END 
            = TRUE THEN 'Yes' ELSE 'No' END As TopList_Flag 
,b.tlo_business_account_sfdc_id
,0 as snapshot_date_key_dimorg
,getdate() as snapshot_timestamp_dimorg
,'ACTUALS' as Row_type_dimorg
,(Select --TOP 10 
  CAST(MAX(CAST(p.top_forum_engagement as int)) as bool) FROM enorm.wef_business_position_v p
              WHERE b.business_account_sfdc_id = p.business_account_sfdc_id) as TFE_Flag
,(Select CAST(MAX(case when p.top_forum_engagement='true' AND c.tfe_counterpart is not null then 1 else 0 end) as bool) as Top_TFE_counterpart
      FROM enorm.wef_business_position_v p
       left join  emart.wef_dim_business_account_v ba on  ba.business_account_sfdc_id = p.business_account_sfdc_id
        left join enorm.wef_mdm_constituent_v c on  c.sfdc_id= p.constituent_sfdc_id
        WHERE b.tlo_business_account_sfdc_id = p.top_level_organization_sfdc_id) as TFE_CounterPart_Flag
,b.at_risk_notes
,b.at_risk_date
,b.top_level_organization_name
,b.main_industry_name
From emart.wef_dim_business_account_v b 
left join enorm.wef_mdm_user_v upem on b.pem_sfdc_id = upem.user_sfdc_id
left join enorm.wef_mdm_user_v usem on b.sem_sfdc_id = usem.user_sfdc_id
left join enorm.wef_dict_region_cluster_v r on b.main_region_operation = r.location_region
left join enorm.wef_util_lookup_values_v l on b.main_industry_name = l.lookup_code and l.lookup_name = 'DIM_Industries'
left join (Select 
--TOP 10
        tl.business_account_hkey,tl.engaged_flag_partner
        From emart.wef_business_toplist_penetration_curr_fy_act_vs_fy_v tl
        Where cast(tl.reporting_month as date) = cast(cast(datepart('month',getdate()) as varchar(2))+'/1/'+cast(datepart('year',getdate()) as varchar(4)) as date)
        ) as tlp on b.business_account_hkey = tlp.business_account_hkey    

-- START OLD LOGIC TO GET THE PEM WHEN THERE IS A LOSS
--- getting the previous Engagement Funct Lead for TLO with PEM DEV changes after Loss
--- the idea is to replace the PEM_id by Funct_Lead_id
/*
left join (
Select distinct b.business_account_sfdc_id,min(b.snapshot_date_key)
,let.pem_sfdc_id as prev_pem_sfdc_id,let.pem_name as prev_pem_name
,let.pem_functional_lead as Prev_functional_lead_Engagement,let.pem_team as Prev_pem_team_Engagement,b.top_level_organization_name
,b.pem_sfdc_id,b.pem_name ,u.functional_lead_sfdc_id,u.active_status_flag
From snapshots.emart_wef_dim_business_account_snapshots_v b 
left join
(select --TOP 10
  snapshot_date_key     , business_account_sfdc_id , name
     ,pem_sfdc_id     , pem_name
     , pem_functional_lead     ,pem_team
     , RANK() OVER (PARTITION BY business_account_sfdc_id ORDER BY snapshot_date_key DESC) AS rank 
from snapshots.emart_wef_dim_business_account_snapshots_v 
where primary_org_contract_category<>'Business - No contract' and pem_team not like 'Partner Development%' and snapshot_date_key <> '20220901'
) as let on b.business_account_sfdc_id=let.business_account_sfdc_id and let.rank=1 
and b.snapshot_date_key >= let.snapshot_date_key
and b.primary_org_contract_category='Business - No contract' and b.pem_team like 'Partner Development%' 
left join enorm.wef_mdm_user_v u  on u.user_sfdc_id=let.pem_sfdc_id where b.snapshot_date_key >= let.snapshot_date_key  
group by let.pem_functional_lead ,let.pem_team ,b.top_level_organization_name,b.pem_sfdc_id,b.pem_name 
,let.pem_sfdc_id,let.pem_name ,u.functional_lead_sfdc_id ,b.business_account_sfdc_id,u.active_status_flag
) as pem on b.business_account_sfdc_id=pem.business_account_sfdc_id and pem.pem_sfdc_id=b.pem_sfdc_id
*/
-- END OLD LOGIC TO GET THE PEM WHEN THERE IS A LOSS


-- GET THE SNAPSHOTS

UNION ALL

Select 
--TOP 10
distinct business_account_sfdc_id
,b.business_account_hkey
,b.pem_sfdc_id as org_pem_sfdc_id
--,upem.workday_employee_id as pem_workday_id 
,upem.workday_employee_id as pem_workday_id
--,usem.workday_employee_id as sem_workday_id 
,usem.workday_employee_id as sem_workday_id
,b.sem_sfdc_id
,b.name as organization_name
,b.active_status_flag
,r.org_region_cluster as Region_Cluster
,b.location_country 
,l.lookup_value as Industry_Cluster
, CASE WHEN CASE WHEN tlp.engaged_flag_partner = NULL THEN FALSE ELSE tlp.engaged_flag_partner END 
            = TRUE THEN 'Yes' ELSE 'No' END As TopList_Flag 
,b.tlo_business_account_sfdc_id
,b.snapshot_date_key as snapshot_date_key_dimorg
,b.snapshot_timestamp as snapshot_timestamp_dimorg
,'SNAPSHOTS' as Row_type_dimorg
,(Select CAST(MAX(CAST(p.top_forum_engagement as int)) as bool) FROM enorm.wef_business_position_v p
              WHERE b.business_account_sfdc_id = p.business_account_sfdc_id) as TFE_Flag
,(Select CAST(MAX(case when p.top_forum_engagement='true' AND c.tfe_counterpart is not null then 1 else 0 end) as bool) as Top_TFE_counterpart
      FROM enorm.wef_business_position_v p
       left join  emart.wef_dim_business_account_v ba on  ba.business_account_sfdc_id = p.business_account_sfdc_id
        left join enorm.wef_mdm_constituent_v c on  c.sfdc_id= p.constituent_sfdc_id
        WHERE b.tlo_business_account_sfdc_id = p.top_level_organization_sfdc_id) as TFE_CounterPart_Flag
,b.at_risk_notes
,b.at_risk_date
,b.top_level_organization_name
,b.main_industry_name
From snapshots.emart_wef_dim_business_account_snapshots_v b 
left join enorm.wef_mdm_user_v upem on b.pem_sfdc_id = upem.user_sfdc_id
left join enorm.wef_mdm_user_v usem on b.sem_sfdc_id = usem.user_sfdc_id
--left join snapshots.enorm_wef_mdm_user_snapshots_v upem on b.pem_sfdc_id = upem.user_sfdc_id and b.snapshot_date_key = upem.snapshot_date_key 
--left join snapshots.enorm_wef_mdm_user_snapshots_v usem on b.sem_sfdc_id = usem.user_sfdc_id and b.snapshot_date_key = usem.snapshot_date_key 
left join enorm.wef_dict_region_cluster_v r on b.main_region_operation = r.location_region
left join enorm.wef_util_lookup_values_v l on b.main_industry_name = l.lookup_code and l.lookup_name = 'DIM_Industries' -- and b.snapshot_date_key = l.snapshot_date_key 
left join (Select 
--TOP 10 
        tl.business_account_hkey,tl.engaged_flag_partner,tl.snapshot_date_key
        From snapshots.emart_wef_business_toplist_penetration_curr_fy_snapshots_v tl
        Where cast(tl.reporting_month as date) = cast(cast(datepart('month',getdate()) as varchar(2))+'/1/'+cast(datepart('year',getdate()) as varchar(4)) as date)
        ) as tlp on b.business_account_hkey = tlp.business_account_hkey and b.snapshot_date_key = tlp.snapshot_date_key
WHERE b.snapshot_date_key >= 20220630


) t


-- Join Workday tables to get the SO PEM
LEFT JOIN ods.workday_workers_v pem on t.pem_workday_id = pem.employee_id
LEFT JOIN ods.workday_supervisory_organization_v sopem on pem.so_refid = sopem.so_refid
LEFT JOIN Managers_PEM mpem on mpem.pem_sfdc_id = t.org_pem_sfdc_id

-- Join Workday tables to get the SO SEM
LEFT JOIN ods.workday_workers_v sem on t.sem_workday_id = sem.employee_id
LEFT JOIN ods.workday_supervisory_organization_v sosem on sem.so_refid = sosem.so_refid
LEFT JOIN Managers_SEM msem on msem.sem_sfdc_id = t.sem_sfdc_id




-- End Select here


WITH NO SCHEMA BINDING;

GRANT SELECT ON tbl.business_accountteam_metrics_dim_organization_v TO secure_select_wefbiz;
GRANT DELETE, REFERENCES, INSERT, TRIGGER, RULE, SELECT, UPDATE ON tbl.business_accountteam_metrics_dim_organization_v TO app_tableau_prod;

